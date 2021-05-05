//
//  PopUp.swift
//  priorit
//
//  Created by Christianto Budisaputra on 05/05/21.
//

import UIKit

class PopUp: UIView {


  @objc private func handleTap(_ sender: UITapGestureRecognizer) {
    let location = sender.location(in: self)
    if !info.frame.contains(location) {
      UIView.animate(withDuration: 0.2) {
        self.alpha = 0
      } completion: { _ in
        self.removeFromSuperview()
      }
    }
  }

  private let info: UIView = {
    let nib = (Bundle.main.loadNibNamed("Info", owner: self, options: nil))?[0] as! Info
    nib.cards.forEach {
      $0.layer.cornerRadius = 8
      $0.backgroundColor = UIColor.Palette.primary
    }
    nib.translatesAutoresizingMaskIntoConstraints = false
    nib.layer.cornerRadius = 12
    return nib
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    addGestureRecognizer(tap)

    self.backgroundColor = .clear
    UIView.animate(withDuration: 0.2) {
      self.backgroundColor = #colorLiteral(red: 0.1333158016, green: 0.1333456039, blue: 0.1333118975, alpha: 0.4)
    }
    self.frame = UIScreen.main.bounds

    self.addSubview(info)
    info.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    info.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    info.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

}
