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
    
    func completeCharge(_ result: STPPaymentResult,
                        amount: Int,
                        shippingAddress: STPAddress?,
                        shippingMethod: PKShippingMethod?,
                        completion: @escaping STPErrorBlock) {
        let url = self.baseURL.appendingPathComponent("charge")
        var params: [String: Any] = [
            "source": result.source.stripeID,
            "amount": amount
        ]
        params["shipping"] = STPAddress.shippingInfoForCharge(with: shippingAddress, shippingMethod: shippingMethod)
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseString { response in
                switch response.result {
                case .success:
                    completion(nil)
                case .failure(let error):
                    completion(error)
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
            "firstName":"test",
            "lastName":"ben",
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
