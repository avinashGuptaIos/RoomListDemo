//
//  RoomDataTableViewCell.swift
//  RoomListDemo
//
//  Created by mac on 16/05/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import UIKit

class RoomDataTableViewCell: UITableViewCell {
    @IBOutlet weak var lablel1: UILabel!
    
    var roomData: RoomData! {
        didSet{
            setUpRoomDataTableViewCell()
        }
    }
    
    static func reuseIdentifier() -> String {
      return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lablel1.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUpRoomDataTableViewCell() {
        lablel1.text = "\(roomData.org?.name ?? "") - \(roomData.property?.name ?? "") - \(roomData.room?.name ?? "")"
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
