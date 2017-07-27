//
//  RegisterUserViewController.swift
//  Afostream
//
//  Created by Bahri on 05/07/2017.
//  Copyright © 2017 Bahri. All rights reserved.
//

import UIKit

import Alamofire
import SDWebImage

class RegisterUserViewController: UIViewController {

    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtFirstnName: UITextField!
  
    
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var txtRetypePassword: UITextField!
    
    @IBOutlet weak var bntRegister: UIButton!
       @IBOutlet weak var txtEmail: UITextField!
      @IBOutlet weak var bntCancel: UIButton!
    
    var laoding_spinner:UIActivityIndicatorView=UIActivityIndicatorView()
    
 
    
    func StartLoadingSpinner()
    {
        laoding_spinner.center=self.view.center
        laoding_spinner.hidesWhenStopped=true
        laoding_spinner.activityIndicatorViewStyle=UIActivityIndicatorViewStyle.gray
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

    
    @IBAction func bntCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
  
    @IBAction func bntRegister(_ sender: Any) {
        
        let Firstname = txtFirstnName.text?.trim()
        let Lastname = txtLastName.text?.trim()
        let Email = txtEmail.text?.trim()
        let Phone = txtPhone.text?.trim()
        let Password = txtPassword.text?.trim()
        let RetypePass = txtRetypePassword.text?.trim()
        
        if Firstname == nil || Firstname! == "" {
            ShowAlert(Title: NSLocalizedString("Error", comment: ""), Message: NSLocalizedString("RegisterErrorFirstname", comment: ""))
            return
            
        }
        
        if Lastname == nil || Lastname! == "" {
            ShowAlert(Title: NSLocalizedString("Error", comment: ""), Message: NSLocalizedString("RegisterErrorLastname", comment: ""))
            return
            
        }

        if Email == nil || Email! == "" {
            ShowAlert(Title: NSLocalizedString("Error", comment: ""), Message: NSLocalizedString("RegisterErrorEmail", comment: ""))
            return
            
        }

        if Phone == nil || Phone! == "" {
            ShowAlert(Title: NSLocalizedString("Error", comment: ""), Message: NSLocalizedString("RegisterErrorPhone", comment: ""))
            return
            
        }
        
        if Password == nil || Password! == "" {
            ShowAlert(Title: NSLocalizedString("Error", comment: ""), Message: NSLocalizedString("RegisterErrorPassword", comment: ""))
            return
            
        }
        
        if RetypePass == nil || RetypePass! == "" {
            ShowAlert(Title: NSLocalizedString("Error", comment: ""), Message: NSLocalizedString("RegisterErrorRetypePass", comment: ""))
            return
            
        }
        
        
        if RetypePass != Password {
            ShowAlert(Title: NSLocalizedString("Error", comment: ""), Message: NSLocalizedString("RegisterErrorPassNotMatch", comment: ""))
            return
            
        }
      self.MakeGetApiAccess( Firstname: Firstname!, Lastname: Lastname!, Email: Email!, Password: Password!, Phone: Phone!)


        
  }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func MakeRegisterUser(access_token:String,Firstname:String,Lastname:String,Email:String,Password:String,Phone:String)
    {
        
        if access_token.isEmpty
        {
            ShowAlert(Title: NSLocalizedString("Error", comment: ""), Message: NSLocalizedString("ErrorAccessToken", comment: ""))
            return
        }
        
        let headers = [
            "Authorization": "Bearer " + access_token
            
        ]
        
        
        
        let parameters = [
            "first_name": Firstname,
            "last_name": Lastname,
            "email": Email,
            "password": Password,
            "telephone": Phone
            
        ]
        
        
        
        
        self.StartLoadingSpinner()
        
        
        
        Alamofire.request(GlobalVar.StaticVar.BaseUrl + "/api/users/" , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch(response.result) {
            case .success(_):
                
                
                
                self.StopLoadingSpinner()
                
                if let data = response.result.value as? [String: Any] {
                    
                    if  let error = data["error"] as? String
                    {
                        if let error_description = data["message"] as? String
                        {
                        print (error_description)
                        self.ShowAlert(Title: "Error", Message: error_description)
                        }
                        return
                        
                    }

                    
                    if let access_token = data["access_token"]  {
                        GlobalVar.StaticVar.access_token = access_token as! String
                    }
                    
                    if let refresh_token = data["refresh_token"]  {
                        GlobalVar.StaticVar.refresh_token = refresh_token as! String
                    }
                    
                    if let expires_in = data["expires_in"]  {
                        GlobalVar.StaticVar.expires_in = expires_in as! Int
                    }
                    
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
    
    
    func MakeGetApiAccess(Firstname:String,Lastname:String,Email:String,Password:String,Phone:String)
    {
        
               
        let headers = [
                 "Content-Type": "application/json"
            
        ]
        
        
        
        let parameters = [
            "grant_type": "client_credentials",
            "client_id": GlobalVar.StaticVar.clientApiID,
            "client_secret": GlobalVar.StaticVar.clientSecret
        
            
        ]
        
        
        
        
        self.StartLoadingSpinner()
        
        
        
        Alamofire.request(GlobalVar.StaticVar.BaseUrl + "/auth/oauth2/token" , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch(response.result) {
            case .success(_):
                
                
                
                self.StopLoadingSpinner()
                
                if let data = response.result.value as? [String: Any] {
                    
                    if let access_token = data["access_token"]  {
                        GlobalVar.StaticVar.access_token_api = access_token as! String
                        
                        self.MakeRegisterUser(access_token: GlobalVar.StaticVar.access_token_api, Firstname: Firstname, Lastname: Lastname, Email: Email, Password: Password, Phone: Phone)

                    }
                    
                    
                }
                
                
                
                
                
                
                
                
                
                
                
                break
                
            case .failure(_):
                self.StopLoadingSpinner()
                print("There is an error")
                break
            }
        }
        
    }


 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 

}
