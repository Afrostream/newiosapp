//
//  StripeAPIClient.swift
//  Afostream
//
//  Created by Bahri on 28/07/2017.
//  Copyright © 2017 Bahri. All rights reserved.
//

import UIKit

import Foundation
import Stripe
import Alamofire

class StripeAPIClient: NSObject, STPEphemeralKeyProvider {
   
    

    static let sharedClient = StripeAPIClient()
    var baseURLString: String? = nil
    var baseURL: URL {
        if let urlString = self.baseURLString, let url = URL(string: urlString) {
            return url
        } else {
            fatalError()
        }
    }
    
    func notPrettyString(from object: Any) -> String? {
        if let objectData = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0)) {
            let objectString = String(data: objectData, encoding: .utf8)
            return objectString
        }
        return nil
    }
    
    func completeCharge(_ token: String,
                     
                        
                        firstName : String ,lastName : String , internalPlanUuid :String ,CouponInternalPlanUuid:String,billingProviderName: String,couponCode :String,couponsCampaignTypeValue:String ,completion:  @escaping STPTokenSubmissionHandler) {
        let url = GlobalVar.StaticVar.BaseUrl + "/api/billings/subscriptions/"
        var internalPlanUuid = internalPlanUuid
        let stripeToken = token

        
        let headers = [
            "Authorization": "Bearer " + GlobalVar.StaticVar.access_token,
            "Content-Type": "application/json"
            
        ]
        
        let opt = [
            "customerBankAccountToken": stripeToken,
            "couponCode":couponCode
            
        ]
        
        var paymentMethod  = [String : Any] ()
        
         paymentMethod["paymentMethodType"] = "card"
        
        
        var billingInfoSub  = [String : Any] ()
        
        
         billingInfoSub["countryCode"] = GlobalVar.StaticVar.CountryCode

        
        if couponsCampaignTypeValue != "" {
            billingInfoSub["paymentMethod"] = couponsCampaignTypeValue
        }
        
       billingInfoSub["paymentMethod"] = paymentMethod
        
        print (billingInfoSub)
        
        if CouponInternalPlanUuid != "" {
            internalPlanUuid = CouponInternalPlanUuid
        }
        
        let parameters = [
            "billingProviderName": billingProviderName ,
            "firstName":firstName,
            "lastName":lastName,
            "internalPlanUuid":internalPlanUuid,
            "subOpts":opt,
            "billingInfo" : billingInfoSub
            
            ] as [String : Any]


        let valid = JSONSerialization.isValidJSONObject(parameters) // true
        print (valid)
        print (parameters)
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseString { response in
                switch response.result {
                case .success:
                    completion(.success, nil)
                case .failure(let error):
                    if error != nil {
                        completion(.failure, error as NSError?)
                    } else {
                        completion(.failure, NSError(domain: StripeDomain, code: 50, userInfo: [NSLocalizedDescriptionKey: "There was an error communicating with your payment backend."]))
                    }
                }
        }
    }
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let url = self.baseURL
        
        let headers = [
            "Authorization": "Bearer " + GlobalVar.StaticVar.access_token,
            "Content-Type": "application/json"
            
        ]
        
        let opt = [
            "apiVersion": apiVersion
            
            
        ]
        
        let parameters = [
            "billingProviderName": "stripe" ,
            "firstName":GlobalVar.StaticVar.user_first_name,
            "lastName":GlobalVar.StaticVar.user_last_name,
            "opts":opt
            
            ] as [String : Any]
        
        
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let json):
                    let dt = json as? [String: AnyObject]
                    let ephemeralKey = dt?["ephemeralKey"] as? [String : AnyObject]
                    completion(ephemeralKey, nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
}
