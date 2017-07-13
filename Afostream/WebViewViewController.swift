//
//  WebViewViewController.swift
//  Afostream
//
//  Created by Bahri on 11/07/2017.
//  Copyright © 2017 Bahri. All rights reserved.
//

import UIKit

class WebViewViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var webView: UIWebView!
    var url :String = ""
    @IBAction func bntBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }
    override func viewDidLoad() { 
        super.viewDidLoad()
        
        webView.delegate = self
        if let url = URL(string: self.url) {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let docUrl :String = request.url!.absoluteString
        
        
        if docUrl.lowercased().range(of: "callback-android")  != nil
            {
            
                //let index :Int = docUrl.lastIndexOf("?")!.distanc
                
                 let index = docUrl.distance(from: docUrl.startIndex, to: docUrl.lastIndexOf("?")!)
                
                
                let indexSub = docUrl.index(docUrl.startIndex, offsetBy: index)
                
                let nextIndex = docUrl.index(indexSub, offsetBy: 1)

                let data : String = docUrl.substring(from: nextIndex)
             
                
                
             
                if let trs :String = data.base64Decoded() {

                    let json = convertToDictionary (text: trs)
                    
                     let statusCode = json?["statusCode"] as! Int
                    
                    if statusCode == 200 {
                        let data = json?["data"] as? [String: Any]
                        let access_token = data?["access_token"] as! String
                        let refresh_token = data?["refresh_token"] as! String
                        let token = data?["token"] as! String
                        let expires_in = data?["expires_in"] as! Int
                        
                        
                        GlobalVar.StaticVar.access_token=access_token
                        GlobalVar.StaticVar.refresh_token=refresh_token
                        GlobalVar.StaticVar.expires_in=expires_in
                  
                        
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController")
                        self.present(vc!, animated: true, completion: nil)
                        
                        //dismiss(animated: true, completion: nil)

                        
                    }
                    
                    
             
                
                }
                       
            
            
        }
        
        return true
    }
    

    func webViewDidStartLoad(_ webView: UIWebView) {
        
        self.progressBar.setProgress(0.1, animated: false)
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        self.progressBar.setProgress(1.0, animated: true)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        self.progressBar.setProgress(1.0, animated: true)
    }

}
