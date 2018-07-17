//
//  CustomMessageCell.swift
//  StasChat
//
//  Created by Stanislav Cherkasov on 14.07.2018.
//  Copyright © 2018 Stanislav Cherkasov. All rights reserved.
//

import UIKit

class CustomMessageCell: UITableViewCell {

    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var senderUserNameLabel: UILabel!
    @IBOutlet var messageBodyLabel: UILabel!
    @IBOutlet var messageBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
