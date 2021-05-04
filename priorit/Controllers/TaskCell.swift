import UIKit

protocol TaskCellDelegate {
  var tasks: [Task] { get set }
  var manager: TaskManager { get }
}

class TaskCell: UITableViewCell {

  var delegate: TaskCellDelegate!
  var task: Task! {
    didSet {
      self.layoutSubviews()
    }
  }
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var dateAddedLabel: UILabel!
  @IBOutlet weak var completedImage: UIImageView!
  @IBOutlet weak var cellContent: UIStackView!

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    cellContent.layer.cornerRadius = 8
    completedImage.image = task.completed ? UIImage(systemName: "checkmark.seal.fill") : UIImage(systemName: "checkmark.seal")
    completedImage.isUserInteractionEnabled = true
    completedImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(completeTask)))
  }

  @objc func completeTask() {
    task = delegate.manager.update(task: task, title: task.title!, impact: task.impact, confidence: task.confidence, effort: task.effort, completed: !task.completed)
    delegate.tasks = delegate.manager.fetch()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

}
