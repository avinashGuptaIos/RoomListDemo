//
//  LockDetailsTableViewCell.swift
//  RoomListDemo
//
//  Created by mac on 16/05/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import UIKit

class LockDetailsTableViewCell: UITableViewCell {

 @IBOutlet weak var headingLabel: UILabel!
 @IBOutlet weak var subHeadingLabel: UILabel!

    
    static func reuseIdentifier() -> String {
      return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        headingLabel.text = nil
        subHeadingLabel.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUpLockDetailsTableViewCell(lockDetails: CDLockDetails, indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            headingLabel.text = "Name : "
            subHeadingLabel.text = lockDetails.name
        case 1:
            headingLabel.text = "Mac : "
            subHeadingLabel.text = lockDetails.mac
            
        case 2:
            headingLabel.text = "Description : "
            subHeadingLabel.text = lockDetails.desctn
        default:
            prepareForReuse()
        }
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
