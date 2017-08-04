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

class PaymentViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate,STPPaymentContextDelegate{
    
    var paymentContext: STPPaymentContext?
    
    var theme: STPTheme?
    
    let companyName = "Afrostream"
    let paymentCurrency = "eur"
   
    
     var numberFormatter: NumberFormatter?
    
    var PlansList = [PlanModel]()
    
    var SelectedPlan :PlanModel?
      var product = ""
    
    @IBOutlet weak var bntValidate: UIButton!
    
    @IBOutlet weak var tableView: UITableView!

    
    
    var laoding_spinner:UIActivityIndicatorView=UIActivityIndicatorView()
    
    var paymentInProgress: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                if self.paymentInProgress {
                    self.laoding_spinner.startAnimating()
                    self.laoding_spinner.alpha = 1
                    self.bntValidate.alpha = 0
                }
                else {
                    self.laoding_spinner.stopAnimating()
                    self.laoding_spinner.alpha = 0
                    self.bntValidate.alpha = 1
                }
            }, completion: nil)
        }
    }

    
    lazy var searchBar = UISearchBar()
    @IBAction func bntCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func bntValidate(_ sender: Any) {
        
        if self.SelectedPlan != nil {
            
            self.paymentContext?.paymentAmount = Int(self.SelectedPlan!.amountInCents)!
            
            self.paymentInProgress = true
          
            self.paymentContext?.requestPayment()

            
        }else
        {
            ShowAlert(Title: "Error", Message: "Please select paiement plan")
        }
        
        
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
       
    init() {
   
        
        
        super.init(nibName: nil, bundle: nil)

       

        
        
    
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        
        
        
        
        
        super.init(coder: aDecoder)
     
        //fatalError("init(coder:) has not been implemented")
    }

    
    

    
    func MakeGetListPlan(access_token:String)
    {
        
        if access_token.isEmpty
        {
            ShowAlert(Title: NSLocalizedString("Error", comment: ""), Message: NSLocalizedString("ErrorAccessToken", comment: ""))
            return
        }
        
        let headers = [
            "Authorization": "Bearer " + access_token
            
        ]
        
        
        
        
        
        
        
        self.StartLoadingSpinner()
        
        let url = GlobalVar.StaticVar.BaseUrl + "/api/billings/internalplans"  + GlobalVar.StaticVar.ApiUrlParams + "&clientVersion=" + GlobalVar.StaticVar.app_version_code
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch(response.result) {
            case .success(_):
                
                
                
                self.StopLoadingSpinner()
                
              
             
                
                if let dt = response.result.value as? NSArray?  {
                    self.PlansList.removeAll()
                    
                    
                    for PlanData in dt!  {
                 
                        
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
                    
                    
                    self.tableView?.reloadData()
                    
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
      self.SelectedPlan = PlansList[indexPath.row]
 
        
    }
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settingsVC  = StripeSettings()
        let settings : Settings = settingsVC.settings
        
        
        let stripePublishableKey = GlobalVar.StaticVar.StripeKey
        let backendBaseURL = GlobalVar.StaticVar.BaseUrl + "/api/billings/customerKey"
        
        
        self.theme = settings.theme
        StripeAPIClient.sharedClient.baseURLString = backendBaseURL
        
        
        let config = STPPaymentConfiguration.shared()
        config.publishableKey = stripePublishableKey
        config.appleMerchantIdentifier = ""
        config.companyName = "Afrostream"
        config.requiredBillingAddressFields = .none
        config.requiredShippingAddressFields = .email
    
        
        let customerContext = STPCustomerContext(keyProvider: StripeAPIClient.sharedClient)
     
        self.paymentContext = STPPaymentContext(customerContext: customerContext,
                                                configuration: config,
                                                theme: settings.theme)
        let userInformation = STPUserInformation()
        self.paymentContext?.prefilledInformation = userInformation

        
        self.paymentContext?.paymentCurrency = self.paymentCurrency
        
        
        
        
        var localeComponents: [String: String] = [
            NSLocale.Key.currencyCode.rawValue: self.paymentCurrency,
            ]
        localeComponents[NSLocale.Key.languageCode.rawValue] = NSLocale.preferredLanguages.first
        let localeID = NSLocale.localeIdentifier(fromComponents: localeComponents)
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: localeID)
        numberFormatter.numberStyle = .currency
        numberFormatter.usesGroupingSeparator = true
        self.numberFormatter = numberFormatter
        
        self.paymentContext?.delegate = self
        self.paymentContext?.hostViewController = self
   
        
        self.MakeGetListPlan(access_token: GlobalVar.StaticVar.access_token)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
       StripeAPIClient.sharedClient.completeCharge(paymentResult,
                                                amount: (self.paymentContext?.paymentAmount)!,
                                                shippingAddress: self.paymentContext?.shippingAddress,
                                                shippingMethod: self.paymentContext?.selectedShippingMethod,
                                                completion: completion, firstName: GlobalVar.StaticVar.user_first_name,lastName : GlobalVar.StaticVar.user_last_name , internalPlanUuid :(SelectedPlan?.internalPlanUuid)! ,CouponInternalPlanUuid: "",billingProviderName: (SelectedPlan?.providerName)!,couponCode : "",couponsCampaignTypeValue: "" )
        
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        self.paymentInProgress = false
        let title: String
        let message: String
        switch status {
        case .error:
            title = "Error"
            message = error?.localizedDescription ?? ""
        case .success:
            title = "Success"
            message = "You bought a \(self.product)!"
        case .userCancellation:
            return
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        print("Payment Method")
        if let paymentMethod = paymentContext.selectedPaymentMethod {
            print( paymentMethod.label)
        }
        else {
            print("Select Payment")
        }

       
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        let alertController = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            // Need to assign to _ because optional binding loses @discardableResult value
            // https://bugs.swift.org/browse/SR-1681
            _ = self.navigationController?.popViewController(animated: true)
        })
        let retry = UIAlertAction(title: "Retry", style: .default, handler: { action in
            self.paymentContext?.retryLoading()
        })
        alertController.addAction(cancel)
        alertController.addAction(retry)
        self.present(alertController, animated: true, completion: nil)
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
