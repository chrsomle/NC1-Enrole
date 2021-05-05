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
  var currCell: TaskCell?
  let textLayer: CATextLayer = {
    let textLayer = CATextLayer()
    textLayer.alignmentMode = .center
    textLayer.fontSize = 17
    textLayer.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    textLayer.string = "Remove"
    textLayer.foregroundColor = UIColor.white.cgColor
    textLayer.contentsScale = UIScreen.main.scale
    textLayer.frame = CGRect(x: 0, y: 26, width: 96, height: 72)
    return textLayer
  }()
  var removeAction: CALayer = {
    let layer = CALayer()
    layer.cornerRadius = 8
    layer.backgroundColor = UIColor.systemRed.cgColor
    return layer
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    tasks = manager.fetch()
    tableView.tableFooterView = UIView(frame: .zero)
    setupTextLayer()
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .darkContent
  }

  func setupTextLayer() {
    removeAction.addSublayer(textLayer)
  }

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
    let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    gestures.delegate = self
    cell.addGestureRecognizer(gestures)
    cell.addGestureRecognizer(tap)

    let modifier = CGFloat(indexPath.row) * 4
    cell.cellContent.backgroundColor = UIColor(hue: (42 + modifier/4)/360, saturation: (80 - modifier)/100, brightness: 100/100, alpha: 1)

    return cell
  }

  @objc func handleTap(_ sender: UITapGestureRecognizer) {
    let location = sender.location(in: currCell)
    if let currCell = currCell {
      if removeAction.frame.contains(location) {
        if let index = tableView.indexPath(for: currCell) {
          UIView.animate(withDuration: 0.5) {
            currCell.contentView.frame.origin.x += currCell.contentView.frame.origin.x
          }
          removeAction.removeFromSuperlayer()
          DispatchQueue.main.async {
            self.tableView.deleteRows(at: [index], with: .right)
          }
          manager.remove(tasks: [tasks[index.row]])
          tasks = manager.fetch()
        }
      }
    }
  }

  @objc func handleGestures(_ sender: UIPanGestureRecognizer) {

    let location = sender.location(in: tableView)
    let translation = sender.translation(in: view)

    if let indexPath = tableView.indexPathForRow(at: location) {

      guard let cell = tableView.cellForRow(at: indexPath) as? TaskCell else { return }

      switch sender.state {

      case .began:
        if let prevCell = prevCell, cell != prevCell {
          UIView.animate(withDuration: 0.3) {
            prevCell.contentView.frame.origin.x = 0
          }
        }
        currCell = cell
        removeAction.frame = CGRect(x: cell.contentView.frame.width, y: 0, width: 96, height: 72)
      case .changed:
        if translation.y > -6 && translation.y < 6 {
          cell.contentView.center = CGPoint(x: cell.contentView.center.x + translation.x, y: cell.contentView.center.y)
          sender.setTranslation(.zero, in: view)

          removeAction.opacity = 0

          if translation.x < -4 {
            cell.layer.insertSublayer(removeAction, at: 0)
            cell.completedImage.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.3) {
              self.removeAction.opacity = 1
              cell.contentView.frame.origin.x = -108
              self.removeAction.frame.origin.x = cell.contentView.frame.width - 120
            }
          } else {
            cell.completedImage.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.3) {
              cell.contentView.frame.origin.x = 0
            }
          }
        }

      case .ended:
        self.prevCell = cell

      default:
        break
      }

    }
  }

}

extension TaskList: UIGestureRecognizerDelegate {
  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
      let translation = panGestureRecognizer.translation(in: tableView)
      if abs(translation.x) > abs(translation.y) {
        return true
      }
    }
    return false
  }
}
