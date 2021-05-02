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
    cards.forEach { $0.layer.cornerRadius = 8 }
  }


  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */

}
