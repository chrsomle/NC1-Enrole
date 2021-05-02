//
//  Dump.swift
//  priorit
//
//  Created by Christianto Budisaputra on 02/05/21.
//

import UIKit

class Dump: UIViewController {

  lazy var manager = TaskManager()
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  var delegate: TaskCellDelegate!

  @IBOutlet weak var contentView: UIStackView!
  @IBOutlet var buttons: [UIButton]!

  override func viewDidLoad() {
    super.viewDidLoad()

    // Design
    contentView.layer.cornerRadius = 12
    buttons.forEach {
      $0.layer.cornerRadius = 8
    }
  }

  @IBAction func dismiss(_ sender: Any) {
    self.dismiss(animated: true)
  }

  @IBAction func dumpAll(_ sender: Any) {
    let alert = UIAlertController(title: "Confirm Your Action", message: "Are you sure you're going to dump all completed tasks?", preferredStyle: .alert)
    let dumpAction = UIAlertAction(
      title: "Dump",
      style: .destructive,
      handler: { _ in
        self.manager.drop()
        self.dismiss(animated: true) {
          self.delegate.tasks = self.manager.fetch()
        }
      })
    let cancleAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
      self.dismiss(animated: true)
    })
    alert.addAction(dumpAction)
    alert.addAction(cancleAction)

    self.present(alert, animated: true)
  }

  @IBAction func dumpCompleted(_ sender: Any) {
    let alert = UIAlertController(title: "Confirm Your Action", message: "Are you sure you're going to dump all completed tasks?", preferredStyle: .alert)
    let dumpAction = UIAlertAction(
      title: "Dump",
      style: .destructive,
      handler: { _ in
        let tasks: [Task] = self.manager.fetch()
        var completedTasks = [Task]()
        tasks.forEach {
          if $0.completed {
            completedTasks.append($0)
          }
        }
        self.manager.remove(tasks: completedTasks)
        self.dismiss(animated: true) {
          self.delegate.tasks = self.delegate.manager.fetch()
        }
      })
    let cancleAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
      self.dismiss(animated: true)
    })
    alert.addAction(dumpAction)
    alert.addAction(cancleAction)

    self.present(alert, animated: true)
  }


}
