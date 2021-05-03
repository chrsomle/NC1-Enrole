//
//  TaskList.swift
//  priorit
//
//  Created by Christianto Budisaputra on 02/05/21.
//

import UIKit

class TaskList: UIViewController, TaskCellDelegate {

  let manager = TaskManager()
  var tasks = [Task]()
  @IBOutlet weak var tableView: UITableView!
  var cellOrigin: CGPoint!

  var prevCell: TaskCell?
  let removeAction = CALayer()

  override func viewDidLoad() {
    super.viewDidLoad()
    tasks = manager.fetch()
    tableView.tableFooterView = UIView(frame: .zero)
    removeAction.cornerRadius = 8
    removeAction.backgroundColor = UIColor.systemRed.cgColor
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .darkContent
  }

  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  @IBAction func dismiss(_ sender: Any) {
    self.dismiss(animated: true)
  }

}

extension TaskList: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    tasks.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as! TaskCell
    cell.titleLabel.text = tasks[indexPath.row].title
    cell.dateAddedLabel.text = tasks[indexPath.row].dateAdded?.toString()
    cell.task = tasks[indexPath.row]
    cell.delegate = self

    let gestures = UIPanGestureRecognizer(target: self, action: #selector(handleGestures))
    cell.addGestureRecognizer(gestures)

    let alpha = 1.2 - (CGFloat(indexPath.row) / CGFloat(tasks.count))
    cell.cellContent.backgroundColor = UIColor(hue: 42/360, saturation: 80/100, brightness: 100/100, alpha: alpha)
    return cell
  }

  @objc func handleGestures(_ sender: UIPanGestureRecognizer) {
    let location = sender.location(in: tableView)
    let translation = sender.translation(in: view)

    if let indexPath = tableView.indexPathForRow(at: location) {

      guard let cell = tableView.cellForRow(at: indexPath) else { return }

      switch sender.state {

      case .began:
        if let prevCell = prevCell, cell != prevCell {
          UIView.animate(withDuration: 0.3) {
            prevCell.contentView.frame.origin.x = 0
          }
        }

        removeAction.frame = CGRect(x: cell.contentView.frame.width, y: 0, width: 96, height: 72)
        removeAction.opacity = 0

        UIView.animate(withDuration: 0.3) {
          cell.contentView.frame.origin.x = 0
        }

      case .changed:
        if translation.y > -8 && translation.y < 8 {
          cell.contentView.center = CGPoint(x: cell.contentView.center.x + translation.x, y: cell.contentView.center.y)
          sender.setTranslation(.zero, in: view)

          if translation.x < -2 {
            cell.layer.insertSublayer(removeAction, at: 0)
            UIView.animate(withDuration: 0.3) {
              cell.contentView.frame.origin.x = -108
              self.removeAction.opacity = 1
              self.removeAction.frame.origin.x = cell.contentView.frame.width - 120
            }
          } else {
            UIView.animate(withDuration: 0.3) {
              cell.contentView.frame.origin.x = 0
            }
          }
        }
      case .ended:
        self.prevCell = cell as? TaskCell

      default:
        break
      }
    }
  }

}
