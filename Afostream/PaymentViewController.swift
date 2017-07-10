//
//  PaymentViewController.swift
//  Afostream
//
//  Created by Bahri on 07/07/2017.
//  Copyright © 2017 Bahri. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import Stripe

class PaymentViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    
    
    var PlansList = [PlanModel]()
    
    @IBOutlet weak var tableView: UITableView!

    
    
    var laoding_spinner:UIActivityIndicatorView=UIActivityIndicatorView()
    
    lazy var searchBar = UISearchBar()
    @IBAction func bntCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func bntValidate(_ sender: Any) {
    }
    @IBAction func bntCgu(_ sender: Any) {
        
        let url = URL(string: "http://www.facebook.com")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            //If you want handle the completion block than
            UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                print("Open url : \(success)")
            })
        }
        
    }
 
    @IBAction func bntWithdrawal(_ sender: Any) {
        
        let url = URL(string: "http://www.facebook.com")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            //If you want handle the completion block than
            UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                print("Open url : \(success)")
            })
        }
    }
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
    
    
    func MakeGetListPlan(access_token:String)
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
        
        
        
        Alamofire.request(GlobalVar.StaticVar.BaseUrl + "/api/billings/internalplans"  + GlobalVar.StaticVar.ApiUrlParams + "&clientVersion=" + GlobalVar.StaticVar.app_version_code, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch(response.result) {
            case .success(_):
                
                
                
                self.StopLoadingSpinner()
                
              
                
                
                if let dt = response.result.value as! NSArray?  {
                    self.PlansList.removeAll()
                    
                    
                    for PlanData in dt  {
                 
                        
                      if let Plan = PlanData as? [String: Any] {
                        
                        
                        let internalPlanUuid = Plan["internalPlanUuid"] as! String
                        let amountInCents = Plan["amountInCents"] as! String
                        let name = Plan["name"] as! String
                        let amount = Plan["amount"] as! String
                        let description = Plan["description"] as! String
                        let currency = Plan["currency"] as! String
                        let periodUnit = Plan["periodUnit"] as! String
                        let periodLength = Plan["periodLength"] as! String
                        
                            if let providerPlans = Plan["providerPlans"]  as? [String: Any] {
                        
                                
                        
                                    var isCouponCodeCompatible:Bool = false
                                    var providerPlanUuid=""
                                    var providerName=""
                                
                        
                               
                                    if let stripe = providerPlans["stripe"]  as? [String: Any] {
                        
                                    isCouponCodeCompatible = stripe["isCouponCodeCompatible"] as! Bool
                                    providerPlanUuid=stripe["providerPlanUuid"] as! String
                        
                                    providerName="stripe";
                                    }
                                
                        
                        
                                
                                    if let google = providerPlans["google"]  as? [String: Any] {
                               
                        
                                    isCouponCodeCompatible = google["isCouponCodeCompatible"]  as! Bool
                                    providerPlanUuid=google["providerPlanUuid"] as! String
                                    providerName="google";
                                    }
                                
                                let pl  = PlanModel(internalPlanUuid: internalPlanUuid, amountInCents: amountInCents, name: name, description: description, currency: currency, periodUnit: periodUnit, periodLength: periodLength, amount: amount, isCouponCodeCompatible: isCouponCodeCompatible, Showlogo: true, providerPlanUuid: providerPlanUuid, providerName: providerName)
                                
                                self.PlansList.append(pl)
                        
                                
                          }
                        
                        }
                        
                            
                            
                            
                        
                        
                        
                    }
                    
                    
                    self.tableView.reloadData()
                    
                }
                
                
                
                
                
                
                
                
                
                
                break
                
            case .failure(_):
                self.StopLoadingSpinner()
                print("There is an error")
                break
            }
        }
        
    }
    

    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.PlansList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PaymentTableViewCell
        
        cell.lblName.text = PlansList[indexPath.row].name
   
        cell.lblDescription.text = PlansList[indexPath.row].description
        cell.lblPrice.text = PlansList[indexPath.row].amount + " " +  PlansList[indexPath.row].currency
        
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       /* let title = PlansList[indexPath.row].title
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
        vc.title = title
        vc.Movie =  MoviesList[indexPath.row]
        self.navigationItem.title = ""
        self.navigationController?.pushViewController(vc,animated: true)*/
        
    }
    

    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.MakeGetListPlan(access_token: GlobalVar.StaticVar.access_token)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
