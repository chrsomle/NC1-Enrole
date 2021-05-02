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

  override func viewDidLoad() {
    super.viewDidLoad()
    tasks = manager.fetch()
    tableView.tableFooterView = UIView(frame: .zero)
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
    let alpha = 1.2 - (CGFloat(indexPath.row) / CGFloat(tasks.count))
    cell.cellContent.backgroundColor = UIColor(hue: 42/360, saturation: 80/100, brightness: 100/100, alpha: alpha)
    return cell
  }

}
