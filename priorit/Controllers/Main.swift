import UIKit
import CoreData
import NotificationCenter

class Main: UIViewController {

  // MARK: - Properties
  let manager = TaskManager()
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  var tasks = [Task]() {
    didSet {
      for (index, element) in tasks.enumerated() {
        print("\(index): ", terminator: "")
        phrase(task: element)
      }
      if tasks.count > 0 {
        emptyIllustration.isHidden = true
        tasksTable.isHidden = false
      } else {
        emptyIllustration.isHidden = false
        tasksTable.isHidden = true
      }
      tasksTable.reloadData()
    }
  }
  lazy var priorityPicker = UIPickerView()

  // MARK: - Outlets
  @IBOutlet weak var titleTextField: TextField!
  @IBOutlet weak var addTaskButton: UIButton!
  @IBOutlet weak var jumbotron: UIStackView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet var priorities: [UITextField]!
  @IBOutlet var priorityPickers: [UIStackView]!
  @IBOutlet weak var emptyIllustration: UIStackView!
  @IBOutlet weak var tasksTable: UITableView!

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .darkContent
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    manager.drop()

    // Setups
    setupTitleTextField()
    priorities.forEach {
      $0.inputView = priorityPicker
      $0.text = intensity[3]
    }
    setupObservers()
    tasks = manager.fetch()

    priorityPicker.delegate = self
    priorityPicker.dataSource = self

    tasksTable.delegate = self
    tasksTable.dataSource = self
    tasksTable.tableFooterView = UIView(frame: .zero)

    design()
  }

  func scrollX(offset: CGFloat = 0) {
    scrollView.setContentOffset(CGPoint(x: 0, y: offset == 0 ? 0 : offset - 48), animated: true)
  }

  @objc func keyboardWillShow(_ notification: Notification) {
    if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
      let keyboardRectangle = keyboardFrame.cgRectValue
      let keyboardHeight = keyboardRectangle.height
      scrollX(offset: keyboardHeight)
    }
  }

  func setupObservers() {
    // 1. Keyboard Observer
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
  }

  func setupTitleTextField() {
    titleTextField.delegate = self
    titleTextField.attributedPlaceholder = NSAttributedString(string: "Attend Daily Meeting", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
  }

  func design() {
    [addTaskButton, jumbotron].forEach { $0.layer.cornerRadius = 8 }
    priorityPickers.forEach { $0.layer.cornerRadius = 4 }
  }

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
    }
  }
}

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
        let alpha = CGFloat(row + 1) / 8 + 0.25
        $0.superview?.backgroundColor = UIColor(hue: 42/360, saturation: 80/100, brightness: 100/100, alpha: alpha)
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

    cell.titleLabel.text = task.title
    cell.dateAddedLabel.text = task.dateAdded?.toString()
    if task.completed { cell.completedImage.image = UIImage(systemName: "checkmark.seal.fill") }

    return cell
  }
}