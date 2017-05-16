//
//  MainViewController.swift
//  Afostream
//
//  Created by Bahri on 09/05/2017.
//  Copyright © 2017 Bahri. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage




class MainViewController: UIViewController {

    @IBOutlet weak var MenuBnt: UIBarButtonItem!
    
    var laoding_spinner:UIActivityIndicatorView=UIActivityIndicatorView()
    func StartLoadingSpinner()
    {
        laoding_spinner.center=self.view.center
        laoding_spinner.hidesWhenStopped=true
        laoding_spinner.activityIndicatorViewStyle=UIActivityIndicatorViewStyle.whiteLarge
        self.view.addSubview(laoding_spinner)
        laoding_spinner.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    func StopLoadingSpinner()
    {
        laoding_spinner.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        
    }
    func ShowAlert(Title:String ,Message:String)
    {
        let alertController = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func MakeGetUserInfo(access_token:String)
    {
        
        if access_token.isEmpty
        {
            ShowAlert(Title: NSLocalizedString("Error", comment: ""), Message: NSLocalizedString("ErrorAccessToken", comment: ""))
            return
        }
        
        let headers = [
            "Authorization": "Bearer " + GlobalVar.StaticVar.access_token
            
        ]
      
        
        self.StartLoadingSpinner()
        
        Alamofire.request(GlobalVar.StaticVar.BaseUrl + "/api/users/me", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch(response.result) {
            case .success(_):
                
                self.StopLoadingSpinner()
                if let JSON = response.result.value as? [String: Any] {
                    var user_id = JSON["_id"] as! Int
                    var user_first_name = JSON["first_name"] as! String
                    var user_last_name = JSON["last_name"] as! String
                    var user_picture_url = JSON["picture"] as! String
                    
                    var user_gender = JSON["gender"] as! String
                    var user_birthday = JSON["birthDate"] as! String
                    var user_postalAddressCountry = JSON["postalAddressCountry"] as! String
                    var user_postalAddressCity = JSON["postalAddressCity"] as! String
                     var user_postalAddressStreet = JSON["postalAddressStreet"] as! String
                    
                    var user_phone = JSON["telephone"] as! String
                    var user_email = JSON["email"] as! String
                   
              
                    if user_first_name == "null" {user_first_name = ""}
                    if user_last_name == "null" {user_first_name = ""}
                    if user_picture_url == "null" {user_first_name = ""}
                    if user_gender == "null" {user_first_name = ""}
                    if user_birthday == "null" {user_first_name = ""}
                    if user_postalAddressCountry == "null" {user_first_name = ""}
                    if user_postalAddressCity == "null" {user_first_name = ""}
                    
                    if user_postalAddressStreet == "null" {user_first_name = ""}
                    if user_phone == "null" {user_first_name = ""}
                    if user_email == "null" {user_first_name = ""}
                    
                    GlobalVar.StaticVar.user_id = user_id
                    GlobalVar.StaticVar.user_first_name = user_first_name
                    GlobalVar.StaticVar.user_last_name = user_last_name
                    GlobalVar.StaticVar.user_email = user_email
                    GlobalVar.StaticVar.user_phone = user_phone
                    GlobalVar.StaticVar.user_gender = user_gender
                    GlobalVar.StaticVar.user_birthday = user_birthday
                    GlobalVar.StaticVar.user_picture_url = user_picture_url
                    GlobalVar.StaticVar.user_postalAddressCity = user_postalAddressCity
                    GlobalVar.StaticVar.user_address = user_postalAddressStreet
                    GlobalVar.StaticVar.user_postalAddressCountry = user_postalAddressCountry
                    
                 
                    
               
                    
                    
                    
                }
                break
                
            case .failure(_):
                self.StopLoadingSpinner()
                print("There is an error")
                break
            }
        }
        
    }
    
    
    
    func MakeGetCategories(access_token:String)
    {
        
        if access_token.isEmpty
        {
            ShowAlert(Title: NSLocalizedString("Error", comment: ""), Message: NSLocalizedString("ErrorAccessToken", comment: ""))
            return
        }
        
        let headers = [
            "Authorization": "Bearer " + GlobalVar.StaticVar.access_token
            
        ]
        
        GlobalVar.StaticVar.catNameArr=[NSLocalizedString("Home", comment: "") ,NSLocalizedString("Favoris", comment: "") ,NSLocalizedString("Account", comment: "") ]
        GlobalVar.StaticVar.menuImgArr=[UIImage(named: "UserAccountIcon")!,UIImage(named: "UserAccountIcon")!,UIImage(named: "UserAccountIcon")!]
        

        self.StartLoadingSpinner()
        
                print (GlobalVar.StaticVar.ApiUrlParams)
        
        Alamofire.request(GlobalVar.StaticVar.BaseUrl + "/api/categorys/menu" + GlobalVar.StaticVar.ApiUrlParams, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch(response.result) {
            case .success(_):
                
                print (response.result)
                
                self.StopLoadingSpinner()
                if let JSON = response.result.value as! NSArray? {
                    
                    
                    
                    for element in JSON {
                        if let data = element as? [String: Any] {
                            let idcat = data["_id"] as! Int
                            let label = data ["label"] as! String
                            
                            GlobalVar.StaticVar.catIDArr.append(idcat)
                            GlobalVar.StaticVar.catNameArr.append(label)
                        }

                    }
                
                    
              
                    /*let label = JSON["label"] as! String
                    let id = JSON["_id"] as! Int
                    GlobalVar.StaticVar.catNameArr.append(label)
                    GlobalVar.StaticVar.catIDArr.append(id)
                    print (label)*/
                    
                    
                    
                    
                    
                    
                    
                }
                break
                
            case .failure(_):
                self.StopLoadingSpinner()
                print("There is an error")
                break
            }
        }
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if revealViewController() != nil
        {
            MenuBnt.target=self.revealViewController()
            MenuBnt.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            
            self.MakeGetUserInfo(access_token:  GlobalVar.StaticVar.access_token)
            self.MakeGetCategories(access_token:  GlobalVar.StaticVar.access_token)
            
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
}
