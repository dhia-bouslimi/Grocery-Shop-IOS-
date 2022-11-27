//
//  TableViewCell.swift
//  Shop
//
//  Created by hamza-dridi on 19/11/2022.
//

import UIKit

class TableViewCell: UITableViewCell {
  

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var numero: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
