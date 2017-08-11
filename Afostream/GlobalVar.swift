//
//  GlobalVar.swift
//  Afostream
//
//  Created by Bahri on 11/05/2017.
//  Copyright © 2017 Bahri. All rights reserved.
//

import UIKit

import FacebookCore

struct MyProfileRequest: GraphRequestProtocol {
    struct Response: GraphResponseProtocol {
        init(rawResponse: Any?) {
            // Decode JSON from rawResponse into other properties here.
        }
    }
    
    var graphPath = "/me"
    var parameters: [String : Any]? = ["fields": "name"]
    var accessToken = AccessToken.current
    var httpMethod: GraphRequestHTTPMethod = .GET
    var apiVersion: GraphAPIVersion = .defaultVersion
}

extension UIColor {
    
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha:1)
    }
    
}

struct MovieModel {
    var title:String
    var movieID:Int
    var imageUrl:String
    var label:String
    var isFav:Bool = false
    var movieInfo : [String: Any]
}


struct PlanModel {
    
    var internalPlanUuid:String
    var amountInCents:String
    var name:String
    var description:String
    var currency:String
    var periodUnit:String
    var periodLength:String
    var amount:String
    var isCouponCodeCompatible:Bool
    var Showlogo:Bool
    var providerPlanUuid:String
    var providerName:String
    var payMethod:String
}

struct HomeCatMovie {
    var CatTitle : String
    var Movies = [MovieModel]()
}


func topMostController() -> UIViewController {
    var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
    while (topController.presentedViewController != nil) {
        topController = topController.presentedViewController!
    }
    return topController
}

extension UIViewController {
     func dismissMe(animated: Bool, completion: (()->())?) {
        var count = 0
        if let c = self.navigationController?.childViewControllers.count {
            count = c
        }
        if count > 1 {
            //Pop the last view controller off navigation controller list
            self.navigationController!.popViewController(animated: animated)
            if let handler = completion {
                handler()
            }
        } else {
            //Dismiss the last vc or vc without navigation controller
            dismiss(animated: animated, completion: completion)
        }
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as! UIViewController!
            }
        }
        return nil
    }
}




struct SectionData {
    let title: String
    let data : [String]
    
    var numberOfItems: Int {
        return data.count
    }
    
    subscript(index: Int) -> String {
        return data[index]
    }
}

extension SectionData {
    //  Putting a new init method here means we can
    //  keep the original, memberwise initaliser.
    init(title: String, data: String...) {
        self.title = title
        self.data  = data
    }
}
class GlobalVar: NSObject {
    
    
    
    
    struct StaticVar{
        
        static let Violet :UIColor = UIColor(hex: 0x4a2b50)
        static let Yellow :UIColor = UIColor(hex: 0xfec730)
        
         static var FirstLaunch:Bool = true
        static var subscription:Bool = false
        static var DevMode:Bool = true
        static var BaseUrl:String = ""
        static var drmLicenseUrl:String = ""
        static var StripeKey:String = ""
        
        static var  user_id=0
        static var  CountryCode=""
        
        static var  ApiUrlParams=""
        
        static var catNameArr=[String]()
        static var catIDArr=[Int]()
        static var menuImgArr=[UIImage]()
        
        static var  access_token=""
        static var  access_token_api=""
        static var  refresh_token=""
        static var  expires_in=0
        static var  token_type=""
        static var  date_token=""
        
        static var  densityPixel=0
        
        static var user_first_name=""
        static var user_last_name=""
        static var user_email=""
        
        static var user_gender=""
        static var user_birthday=""
        static var user_postalAddressCity=""
        static var user_postalAddressCountry=""
        static var user_phone=""
        static var user_address=""
        static var user_picture_url=""
        
        
        static var  Subscription_subscriptionBillingUuid=""
        static var  Subscription_isCancelable=""
        static var Subscription_subStatus=""
        
        static let clientSecret = "14480982-9487-42ed-8250-cc93d368c208" //prod et dev ios
        static let clientApiID = "989796ec-5d63-4ef2-89b0-7d3923d6484f" //prod et dev ios
        
        
        static let   CouponUUIDGenStaging = "e9d0c006-175a-4564-a736-7cc9edb3e532"
        static let   CouponUUIDGenProd = "d9e879c7-e445-409f-ad44-817e30e62fc0"
        
        static let app_version_code = "2"
        
        
        static var menuSections: [SectionData] = [SectionData]()
        
        
    }
    
}
