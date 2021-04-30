import Foundation

func phrase(task: Task) {
  let formatter = DateFormatter()
  formatter.dateStyle = .medium
  formatter.timeStyle = .medium

  print(
  """
  \(task.title!) is \(task.completed ? "completed" : "not completed"),
  it was created on \(formatter.string(from: task.dateAdded!)).
  It has priority of \(task.priority).

  """)
}
