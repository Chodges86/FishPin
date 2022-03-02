//
//  TableViewCell.swift
//  Fish Pin
//
//  Created by Caleb Hodges on 2/3/22.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var entryField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
