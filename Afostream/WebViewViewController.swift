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
        
        let docUrl = request.url!.absoluteString
        
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
