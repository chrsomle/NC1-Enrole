//
//  TaskManager.swift
//  priorit
//
//  Created by Christianto Budisaputra on 30/04/21.
//

import UIKit
import CoreData

struct TaskManager {

  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

  func fetch(isList: Bool = false) -> [Task] {
    var tasks = [Task]()
    do {
      let request: NSFetchRequest<Task> = Task.fetchRequest()
      request.sortDescriptors = [
        NSSortDescriptor(key: "priority", ascending: false),
        NSSortDescriptor(key: "dateAdded", ascending: isList)
      ]
      tasks = try context.fetch(request)
    } catch { print(error.localizedDescription) }
    return tasks
  }

  func drop() {
    let tasks = self.fetch()
    tasks.forEach { context.delete($0) }

    do {
      try context.save()
    } catch {
      print(error.localizedDescription)
    }
  }

  func add(title: String, impact: Int16, confidence: Int16, effort: Int16) {
    let task = Task(context: context)
    self.assign(title: title, impact: impact, confidence: confidence, effort: effort, to: task)
    task.dateAdded = Date()
    do {
      try context.save()
    } catch {
      print(error.localizedDescription)
    }
  }

  func update(task: Task, title: String, impact: Int16, confidence: Int16, effort: Int16) {
    self.assign(title: title, impact: impact, confidence: confidence, effort: effort, to: task)
    do {
      try context.save()
    } catch {
      print(error.localizedDescription)
    }
  }

  func remove(tasks: [Task]) {
    tasks.forEach { context.delete($0) }
    do {
      try context.save()
    } catch {
      print(error.localizedDescription)
    }
  }

  private func assign(title: String, impact: Int16, confidence: Int16, effort: Int16, to task: Task) {
    task.title = title
    task.impact = impact
    task.confidence = confidence
    task.effort = effort
    task.priority = impact * confidence * effort
  }

}

