import UIKit

class TaskCell: UITableViewCell {


  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var dateAddedLabel: UILabel!
  @IBOutlet weak var completedImage: UIImageView!
  @IBOutlet weak var cellContent: UIStackView!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func layoutSubviews() {
    super.layoutSubviews()
//    contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
    cellContent.layer.cornerRadius = 8
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

}
