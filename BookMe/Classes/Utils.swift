//
//  Utils.swift
//  BookMe
//
//  Created by mac on 20.01.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit
import RealmSwift

class Utils: NSObject {
    
    static var IDLength : Int {
        return 10
    }
    
    static func realm (_ block: (Realm) -> Void) {
        let realm = try! Realm()
        if realm.isInWriteTransaction == true {
            block(realm)
        } else {
            try? realm.write() {
                block(realm)
            }
        }
    }
    
    static func isValidMail(_ mail : String?) -> Bool {
        if mail == nil {return false}
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: mail!)
    }
    
    static func validatePassword(_ password : String?) -> Bool {
        if password == nil {return false}
        return password!.characters.count > 4
    }
    
    static func generateID() -> String {
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.characters.count)
        var randomString = ""
        for _ in (0..<IDLength) {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let newCharacter = allowedChars[allowedChars.characters.index(allowedChars.startIndex, offsetBy: randomNum)]
            randomString += String(newCharacter)
        }
        return randomString
    }
    
    static func endOfWord(words : [String], number : Int) -> String {
        let str = String(format: "%@", number % 10 == 1 && number % 100 != 11 ? words[0] : (number % 10 >= 2 && number % 10 <= 4 && (number % 100 < 10 || number % 100 >= 20) ? words[1] : words[2]))
        return "\(number) \(str)"
    }
    
}
