import UIKit

class TaskCell: UITableViewCell {


  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var dateAddedLabel: UILabel!
  @IBOutlet weak var completedImage: UIImageView!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

}
