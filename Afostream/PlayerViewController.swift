//
//  PlayerViewController.swift
//  Afostream
//
//  Created by Bahri on 14/06/2017.
//  Copyright © 2017 Bahri. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class PlayerViewController: AVPlayerViewController {
    
    var videoURL:String = ""
 
    
    func loadVideo()
    {
        let vidURL = URL(string: self.videoURL)
         self.player = AVPlayer(url: vidURL!)
        self.player?.play()
   }
    

    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: Selector(("finishedPlaying:")), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadVideo()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
