//
//  GlobalVar.swift
//  Afostream
//
//  Created by Bahri on 11/05/2017.
//  Copyright © 2017 Bahri. All rights reserved.
//

import UIKit
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
    var imageUrl:String
    var label:String
    var movieInfo : [String: Any]
}

struct HomeCatMovie {
var CatTitle : String
var Movies = [MovieModel]()
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
        
        static var DevMode:Bool = false
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
        
        static let clientSecret = "0426914d-96bc-46f6-849e-bca34ef7300a" //prod et dev
        static let clientApiID = "85f700d9-4a80-4913-8223-e0d49fef3a05" //prod et dev
        
        
        static let   CouponUUIDGenStaging = "e9d0c006-175a-4564-a736-7cc9edb3e532"
        static let   CouponUUIDGenProd = "d9e879c7-e445-409f-ad44-817e30e62fc0"
        
        
        static var menuSections: [SectionData] = [SectionData]()
 

    }

}
