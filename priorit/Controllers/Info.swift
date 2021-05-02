//
//  Info.swift
//  priorit
//
//  Created by Christianto Budisaputra on 02/05/21.
//

import UIKit

class Info: UIViewController {

  @IBOutlet weak var contentView: UIStackView!
  @IBOutlet var cards: [UIStackView]!

  override func viewDidLoad() {
    super.viewDidLoad()

    contentView.layer.cornerRadius = 12
    cards.forEach {
      $0.layer.cornerRadius = 8
      $0.backgroundColor = UIColor.Palette.primary
    }
  }

  @IBAction func dismiss(_ sender: Any) {
    self.dismiss(animated: true)
  }

}
