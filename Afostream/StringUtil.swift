//
//  StringUtil.swift
//  Afostream
//
//  Created by Bahri on 12/07/2017.
//  Copyright © 2017 Bahri. All rights reserved.
//

import UIKit


public func convertToDictionary(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}

extension String
{
    var length:Int {
        return self.characters.count
    }
    
    func trim() -> String
    {
        return self.trimmingCharacters(in: .whitespaces)
    }
    func indexOf(_ input: String,
                 options: String.CompareOptions = .literal) -> String.Index? {
        return self.range(of: input, options: options)?.lowerBound
    }
    
    func lastIndexOf(_ input: String) -> String.Index? {
        return indexOf(input, options: .backwards)
    }

    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    //: ### Base64 decoding a string
    func base64Decoded() -> String? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    

    func contains(s: String) -> Bool {
        return (self.range(of: s) != nil) ? true : false
    }
}
