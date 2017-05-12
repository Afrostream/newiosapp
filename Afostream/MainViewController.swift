//
//  MainViewController.swift
//  Afostream
//
//  Created by Bahri on 09/05/2017.
//  Copyright © 2017 Bahri. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var MenuBnt: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if revealViewController() != nil
        {
            MenuBnt.target=self.revealViewController()
            MenuBnt.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
}
