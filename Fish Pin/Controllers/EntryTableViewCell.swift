//
//  EntryTableViewCell.swift
//  Fish Pin
//
//  Created by Caleb Hodges on 10/3/21.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var entryTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
