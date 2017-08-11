//
//  LoginViewController.swift
//  Afostream
//
//  Created by Bahri on 05/05/2017.
//  Copyright © 2017 Bahri. All rights reserved.
//

import UIKit
import Alamofire
import FacebookCore
import FacebookLogin

class LoginViewController: UIViewController {

   
    @IBOutlet weak var txtUser: DesignableUITextField!
    @IBOutlet weak var txtPass: DesignableUITextField!
    
    @IBAction func bntOrange(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        
        vc.url = GlobalVar.StaticVar.BaseUrl + "/auth/orange/signin?clientType=legacy-api.android"
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func bntBouygue(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        
        vc.url = GlobalVar.StaticVar.BaseUrl + "/auth/bouygues/signin?clientType=legacy-api.android"
        self.present(vc, animated: true, completion: nil)

        
    }
    
    @objc fileprivate func facebookSignIn() {
        let loginManager = LoginManager()
        print("LOGIN MANAGER: \(loginManager)")
        loginManager.logIn([ .publicProfile, .email,.userFriends ], viewController: self) { loginResult in
            print("LOGIN RESULT! \(loginResult)")
            switch loginResult {
            case .failed(let error):
                print("FACEBOOK LOGIN FAILED: \(error)")
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
                print("GRANTED PERMISSIONS: \(grantedPermissions)")
                print("DECLINED PERMISSIONS: \(declinedPermissions)")
                print("ACCESS TOKEN \(accessToken)")
                
                
                let parameters = ["fields":"email,first_name,last_name,picture"]
                
                
                FBSDKGraphRequest(graphPath: "me", parameters: parameters).start(completionHandler: { (connection, result, error) in
                    
                    if error != nil {
                        print (error)
                        return
                    }
                     if let result = result as? [String: Any] {
                    guard let email = result["email"] as? String else {
                        // No email? Fail the login
                        return
                    }
                  
                    
                    guard let firstname = result["first_name"] as? String else {
                        // No username? Fail the login
                        return
                    }
                    
                    guard let lastname = result["last_name"] as? String else {
                        // No username? Fail the login
                        return
                    }
                    
                    
                   
                    print (email)
                    print (firstname)
                    print (accessToken.authenticationToken)
                    self.MakeGeoFacebook(FbToken: accessToken.authenticationToken, Email: email, Firstname: firstname, Lastname: lastname)

                    }
                    
                })
                
                
            }
        }
    }
    @IBAction func bntFacebook(_ sender: Any) {
        self.facebookSignIn()
            }
    
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
    
    func MakeGeoFacebook(FbToken:String ,Email :String,Firstname:String ,Lastname:String)
    {
        
        
        let headers = [
            "Content-Type": "application/json"
            
        ]
        
        self.StartLoadingSpinner()
        
        Alamofire.request(GlobalVar.StaticVar.BaseUrl + "/auth/geo", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch(response.result) {
            case .success(_):
                
                self.StopLoadingSpinner()
                if let JSON = response.result.value as? [String: Any] {
                    var countryCode = JSON["countryCode"] as! String
                    
                    if countryCode == "null" || countryCode == ""  {
                    countryCode="--"
                    }
                    
                    let language = Locale.preferredLanguages[0]
                    GlobalVar.StaticVar.CountryCode=countryCode
                    GlobalVar.StaticVar.ApiUrlParams="?country=" + countryCode + "&language=" + language
                    self.MakeLoginFacebook(FbToken: FbToken, Email: Email, Firstname: Firstname, Lastname: Lastname)
                    
                    
                    
                    
                }
                break
                
            case .failure(_):
                self.StopLoadingSpinner()
                print("There is an error")
                break
            }
        }
        
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
                    
                    if  let error = JSON["error"] as? String
                    {
                         let error_description = JSON["error_description"] as! String
                        print (error_description)
                        self.ShowAlert(Title: "Error", Message: error_description)
                        return
                        
                    }

                    
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

       func MakeLoginFacebook(FbToken:String ,Email :String,Firstname:String ,Lastname:String)
    {
        
        
        
        let headers = [
            "Content-Type": "application/json"
    
        ]
        let parameters = [
            "grant_type": "facebook",
            "client_id": GlobalVar.StaticVar.clientApiID,
            "client_secret": GlobalVar.StaticVar.clientSecret,
            "token": FbToken
          
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
