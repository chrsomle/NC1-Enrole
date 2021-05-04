import UIKit
import CoreData
import NotificationCenter

class Main: UIViewController, TaskCellDelegate {

  // MARK: - Properties
  let manager = TaskManager()
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  lazy var priorityPicker = UIPickerView()

  // Computed Properties
  var highestPriorityTask: Task? {
    didSet {
      if let task = highestPriorityTask {
        // Setup Task Title and Date
        if let title = task.title,
           let dateAdded = task.dateAdded {
          jumbotronTitle.text = title
          jumbotronDateAdded.text = dateAdded.toString()
        }

        // Configure Completed Mark
        jumbotronCompletedMark.image = getImage(task.completed)
        jumbotronCompletedMark.alpha = 1
        jumbotronCompletedMark.isUserInteractionEnabled = true
        jumbotronCompletedMark.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(completeTask)))
      }

    }
  }
  var tasks = [Task]() {
    didSet {
      if tasks.count > 0 {

        if tasks.count > 1 {
          // Toggle On Prioritized Tasks Table View
          emptyIllustration.isHidden = true
          tasksTable.isHidden = false
        } else {
          // Toggle Off Prioritized Tasks Table View
          emptyIllustration.isHidden = false
          tasksTable.isHidden = true
        }

        // Show "See More" Button
        seeMoreButton.alpha = 1

        // Assign Highest Priority Task
        highestPriorityTask = tasks.removeFirst()

        // Set Prioritized Tasks Table Height
        let count = tasks.count
        let cellHeight = 87
        if count < 5 { tableHeight.constant = count < 4 ? emptyIllustration.frame.height : CGFloat(count * cellHeight) - 10 }
      } else {
        // Toggle Off Prioritized Tasks Table View
        emptyIllustration.isHidden = false
        tasksTable.isHidden = true

        // Hide "See More" Button
        seeMoreButton.alpha = 0

        // Hide The Completed Mark
        jumbotronCompletedMark.alpha = 0
        jumbotronCompletedMark.isUserInteractionEnabled = false

        // Show Greetings
        jumbotronTitle.text = "👀 Hi there!"
        jumbotronDateAdded.text = "You currently have no unfinished tasks."
      }

      tasksTable.reloadData()
    }
  }

  // MARK: - Outlets
  @IBOutlet weak var tableHeight: NSLayoutConstraint!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var contentStackView: UIStackView!

  // Highest Priority Task
  @IBOutlet weak var jumbotron: UIStackView!
  @IBOutlet weak var jumbotronTitle: UILabel!
  @IBOutlet weak var jumbotronDateAdded: UILabel!
  @IBOutlet weak var jumbotronCompletedMark: UIImageView!

  // Next Prioritized Tasks List
  @IBOutlet weak var seeMoreButton: UIButton!
  @IBOutlet weak var emptyIllustration: UIStackView!
  @IBOutlet weak var tasksTable: UITableView!

  // Add Task
  @IBOutlet weak var titleTextField: TextField!
  @IBOutlet var priorities: [UITextField]!
  @IBOutlet var priorityPickers: [UIStackView]!
  @IBOutlet weak var addTaskButton: UIButton!

  // MARK: - Overrides
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .darkContent
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Setups
    setupTitleTextField()
    priorities.forEach {
      $0.inputView = priorityPicker
      $0.text = intensity[2]
      $0.superview?.backgroundColor = UIColor(hue: 44/360, saturation: 72/100, brightness: 100/100, alpha: 1)
    }
    setupObservers()
    tasks = manager.fetch()

    priorityPicker.delegate = self
    priorityPicker.dataSource = self

    tasksTable.delegate = self
    tasksTable.dataSource = self
    tasksTable.tableFooterView = UIView(frame: .zero)
    let layer = CALayer()
    layer.frame = jumbotron.bounds
    layer.contents = UIImage(named: "Mountain")?.cgImage
    layer.position = CGPoint(x:jumbotron.bounds.midX, y:jumbotron.bounds.midY + 20)
    jumbotron.layer.masksToBounds = true
    jumbotron.layer.addSublayer(layer)
    jumbotron.backgroundColor = UIColor.Palette.primary
    design()
  }

  override func viewWillAppear(_ animated: Bool) {
    tasks = manager.fetch()

    // When user directly adding task without dismissing their keyboard, when Task List is being dismissed, the scrolling before presenting Task List View Controller will persist. Hence, it's neccessary to "reset" the scrolling.
    scrollX()
  }

  // MARK: - Methods
  func getImage(_ isCompleted: Bool) -> UIImage {
    return isCompleted ? UIImage(systemName: "checkmark.seal.fill")! : UIImage(systemName: "checkmark.seal")!
  }

  func scrollX(offset: CGFloat = 0) {
    let y = offset - (view.frame.height - contentStackView.frame.height) + 48
    scrollView.setContentOffset(CGPoint(x: 0, y: offset == 0 ? 0 : y), animated: true)
  }

  @objc func keyboardWillShow(_ notification: Notification) {
    if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
      let keyboardRectangle = keyboardFrame.cgRectValue
      let keyboardHeight = keyboardRectangle.height
      scrollX(offset: keyboardHeight)
    }
  }

  @objc func completeTask(_ sender: Any? = nil) {
    if let task = highestPriorityTask {
      highestPriorityTask = manager.update(task: task, title: task.title!, impact: task.impact, confidence: task.confidence, effort: task.effort, completed: !task.completed)
      tasks = manager.fetch()
    }
  }

  func setupObservers() {
    // Keyboard Observer
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
  }

  func setupTitleTextField() {
    titleTextField.delegate = self
    titleTextField.attributedPlaceholder = NSAttributedString(string: "Attend Daily Meeting", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
  }

  func design() {
    [addTaskButton, jumbotron].forEach { $0.layer.cornerRadius = 8 }
    priorityPickers.forEach { $0.layer.cornerRadius = 4 }
    // Create a new Attributed String
    let attributedString = NSMutableAttributedString.init(string: "see more")

    // Add Underline Style Attribute.
    attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range:
        NSRange.init(location: 0, length: attributedString.length));
    seeMoreButton.setAttributedTitle(attributedString, for: .normal)
  }

  // MARK: - Actions
  @IBAction func addTaskTapped(_ sender: Any) {
    if let title = titleTextField.text,
       title.count > 0,
       let effort = priorities[0].text,
       let confidence = priorities[1].text,
       let impact = priorities[2].text {
      let i = impact.score(),
          c = confidence.score(),
          e = effort.score()
      manager.add(title: title, impact: i, confidence: c, effort: e)
      tasks = manager.fetch()
      titleTextField.text = ""
      scrollX()

      // Dismiss Any Active Keyboard / Pickers
      if tasks.count > 4 {
        seeMore(self)
      } else {
        titleTextField.resignFirstResponder()
        priorities.forEach { $0.resignFirstResponder() }
      }
    } else {
      let alert = UIAlertController(title: "Alert", message: "Please provide a name for the task.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { _ in self.dismiss(animated: true) }))
      self.present(alert, animated: true)
    }
  }

  @IBAction func seeMore(_ sender: Any) {
    let taskList = storyboard?.instantiateViewController(identifier: "taskList") as! TaskList
    self.present(taskList, animated: true)
  }

}

// MARK: - Extension

extension Main: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    intensity.count
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    intensity[row]
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    priorities.forEach {
      if $0.isEditing {
        $0.text = intensity[row]
        let modifier = CGFloat(row) * 4
        $0.superview?.backgroundColor = UIColor(hue: (42 + modifier/4)/360, saturation: (80 - modifier)/100, brightness: 100/100, alpha: 1)
        $0.resignFirstResponder()
      }
    }
    scrollX()
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    scrollX()
    textField.resignFirstResponder()
    return true
  }
}

extension Main: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let count = tasks.count
    return count < 5 ? count : 4
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tasksTable.dequeueReusableCell(withIdentifier: "taskCell") as! TaskCell
    let task = tasks[indexPath.row]

    cell.task = task
    cell.delegate = self
    cell.titleLabel.text = task.title
    cell.dateAddedLabel.text = task.dateAdded?.toString()
    if task.completed { cell.completedImage.image = UIImage(systemName: "checkmark.seal.fill") }
    let modifier = CGFloat(indexPath.row) * 4
    cell.cellContent.backgroundColor = UIColor(hue: (42 + modifier/4)/360, saturation: (80 - modifier)/100, brightness: 100/100, alpha: 1)
    return cell
  }

  // Debugging Purpose – Remove Item
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//      let removeActionHandler = { [self] (action: UIContextualAction, view: UIView, completion: @escaping (Bool) -> Void) in
//        self.manager.remove(tasks: [tasks[indexPath.row]])
//        self.tasks = self.manager.fetch()
//      }
//      let removeAction = UIContextualAction(style: .destructive, title: "Remove", handler: removeActionHandler)
//      return UISwipeActionsConfiguration(actions: [removeAction])
//    }
}
