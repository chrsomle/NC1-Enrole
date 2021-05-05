//
//  Info.swift
//  priorit
//
//  Created by Christianto Budisaputra on 05/05/21.
//

import UIKit

class Info: UIView {

  @IBOutlet var cards: [UIStackView]!

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  @IBAction func dismiss(_ sender: Any) {
    UIView.animate(withDuration: 0.3) {
      self.superview?.alpha = 0
    } completion: { _ in
      self.superview?.removeFromSuperview()
    }
  }
}
