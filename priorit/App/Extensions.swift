//
//  Extensions.swift
//  priorit
//
//  Created by Christianto Budisaputra on 28/04/21.
//

import Foundation
import UIKit

extension UserDefaults{

  func setTasksCount(to count: Int) {
    set(count, forKey: "tasksCount")
  }

  func getTasksCount() -> Int {
    return integer(forKey: "tasksCount")
  }
}

class TextField: UITextField {
  let padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

  override open func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }

  override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }

  override open func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }

}

extension String {
  func score() -> Int16 {
    switch self {
    case "Near Zero":
      return 1
    case "Very Low":
      return 2
    case "Low":
      return 4
    case "Medium":
      return 6
    case "High":
      return 8
    case "Very High":
      return 10
    default:
      return 0
    }
  }
}

extension Date {
  func toString() -> String {
    let formatter = DateFormatter()
    formatter.timeStyle = .medium
    formatter.dateStyle = .medium
    return "Added on \(formatter.string(from: self))"
  }
}
