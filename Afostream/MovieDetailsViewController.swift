//
//  MovieDetailsViewController.swift
//  Afostream
//
//  Created by Bahri on 29/05/2017.
//  Copyright © 2017 Bahri. All rights reserved.
//

import UIKit
import SDWebImage

class MovieDetailsViewController: UIViewController {
    @IBOutlet weak var imgMovie: UIImageView!
    
    var Movie :MovieModel!
    

    override func viewWillAppear(_ animated: Bool) {
         self.imgMovie.sd_setImage(with: URL(string: Movie.imageUrl), placeholderImage:#imageLiteral(resourceName: "FanartPlaceholderSmall"))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
   
    }
    

   

}
