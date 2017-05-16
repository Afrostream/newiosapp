//
//  LoginViewController.swift
//  Afostream
//
//  Created by Bahri on 05/05/2017.
//  Copyright © 2017 Bahri. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

   
    @IBOutlet weak var txtUser: DesignableUITextField!
    @IBOutlet weak var txtPass: DesignableUITextField!
    
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let defaults = UserDefaults.standard
        if let User = defaults.string(forKey: "username") {
            txtUser.text = User
        }
        if let Pass = defaults.string(forKey: "password") {
           txtPass.text=Pass
        }
        
        

        _ = UITapGestureRecognizer(target: self, action:Selector(("tap:")))
      //  view.addGestureRecognizer(tapGesture)
    }
    
       func MakeLogin(Username:String ,Password :String)
    {
        
        if Username.isEmpty || Password.isEmpty
        {
            ShowAlert(Title: NSLocalizedString("Error", comment: ""), Message: NSLocalizedString("ErrorLoginField", comment: ""))
            return
        }
        
        let headers = [
            "Content-Type": "application/json"
    
        ]
        let parameters = [
            "grant_type": "password",
            "client_id": GlobalVar.StaticVar.clientApiID,
            "client_secret": GlobalVar.StaticVar.clientSecret,
            "username": Username,
            "password": Password
        ]
        
        self.StartLoadingSpinner()
        
        Alamofire.request(GlobalVar.StaticVar.BaseUrl + "/auth/oauth2/token", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch(response.result) {
            case .success(_):
                
                self.StopLoadingSpinner()
                if let JSON = response.result.value as? [String: Any] {
                    let access_token = JSON["access_token"] as! String
                    let refresh_token = JSON["refresh_token"] as! String
                    let expires_in = JSON["expires_in"] as! Int
                    let token_type = JSON["token_type"] as! String
                    
                    GlobalVar.StaticVar.access_token=access_token
                    GlobalVar.StaticVar.refresh_token=refresh_token
                    GlobalVar.StaticVar.expires_in=expires_in
                    GlobalVar.StaticVar.token_type=token_type
                    
                    let defaults = UserDefaults.standard
                    defaults.set(Username, forKey:"username")
                    defaults.set(Password, forKey:"password")
                    
                    print( GlobalVar.StaticVar.access_token)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController")
                    self.present(vc!, animated: true, completion: nil)
                    
                    
                    
                    
                    
                }
                break
                
            case .failure(_):
                 self.StopLoadingSpinner()
                print("There is an error")
                break
            }
        }

    }
    @IBAction func bntSignin(_ sender: UIButton) {
        
        
        Alamofire.request(GlobalVar.StaticVar.BaseUrl + "/auth/geo", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch(response.result) {
            case .success(_):
                if let JSON = response.result.value as? [String: Any] {
                        let country = JSON["countryCode"] as! String
                    let language :String = "FR"
                    GlobalVar.StaticVar.CountryCode=country
                   GlobalVar.StaticVar.ApiUrlParams = "?country="+country + "&language="+language
                    
                    let user:String = self.txtUser.text!
                    let password:String = self.txtPass.text!
                    
                    self.MakeLogin(Username: user, Password: password)
                    
                    
                
                }
                break
                
            case .failure(_):
                let errorMessage = "General error message"
                
                
                print(errorMessage) //Contains General error message or specific.
                break
            }
        }
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tap(gesture:UITapGestureRecognizer)
    {
    txtUser.resignFirstResponder()
        txtPass.resignFirstResponder()
    }

   

}
