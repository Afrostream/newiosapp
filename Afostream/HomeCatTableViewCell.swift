//
//  HomeCatTableViewCell.swift
//  Afostream
//
//  Created by Bahri on 20/06/2017.
//  Copyright © 2017 Bahri. All rights reserved.
//

import UIKit

class HomeCatTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgMovie: UIImageView!
    @IBOutlet weak var bntFav: UIButton!
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
