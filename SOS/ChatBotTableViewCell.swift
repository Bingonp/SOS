//
//  ChatBotTableView.swift
//  Voice Recognition
//
//  Created by Neha Patil on 4/9/23.
//

import UIKit

class ChatBotTableViewCell: UITableViewCell {
  
    @IBOutlet weak var leftImage: UIImageView!
   
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var imageSender: UIImageView!
    @IBOutlet weak var allContentView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        messageLabel.text = ""
        messageLabel.text = ""
        allContentView.layer.cornerRadius = allContentView.frame.size.height / 5
        
        messageLabel.numberOfLines = 0
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
