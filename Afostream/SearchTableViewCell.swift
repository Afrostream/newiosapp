//
//  SearchTableViewCell.swift
//  Afostream
//
//  Created by Bahri on 04/07/2017.
//  Copyright © 2017 Bahri. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgMovie: UIImageView!
    var Movie :MovieModel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
