//
//  FavTableViewCell.swift
//  Afostream
//
//  Created by Bahri on 26/06/2017.
//  Copyright © 2017 Bahri. All rights reserved.
//

import UIKit

class FavTableViewCell: UITableViewCell {

    @IBOutlet weak var lblMovie: UILabel!
    @IBOutlet weak var imgMovie: UIImageView!
    
    @IBOutlet weak var favBnt: UIButton!
      var Movie :MovieModel!
    
    @IBAction func bntFavClick(_ sender: Any) {
        let refreshAlert = UIAlertController(title: "Refresh", message: "All data will be lost.", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            print(self.Movie.movieID)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
       
        self.parentViewController?.present(refreshAlert, animated: true, completion: nil)
        
    }
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
