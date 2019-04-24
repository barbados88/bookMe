//
//  Session.swift
//  BookMe
//
//  Created by mac on 20.01.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit

enum SessionKey : String {
    
    case loggedIn = "userLoggedIn"
    case deviceToken = "deviceToken"
    case id = "userID"
    case name = "name"
    case surname = "surname"
    case accessToken = "accessToken"
    case mail = "email"
    case password = "password"
    case company = "companyID"
    case admin = "admin"
    
    static var allValues : [SessionKey] = [loggedIn, deviceToken, id, name, surname, accessToken, mail, password, company, admin]
    
}

//TODO: create realm object 

class Session: NSObject {
    
    private static var sessionKey : String {
        get { return (UserDefaults.standard.object(forKey: "key") as? String ?? "") }
        set { UserDefaults.standard.set(newValue, forKey: "key") }
    }
    
    private static var sessionValue : Any? {
        get { return UserDefaults.standard.object(forKey: sessionKey) }
        set { UserDefaults.standard.set(newValue, forKey: sessionKey) }
    }
    
    private static func sessionValue(get key : SessionKey) -> Any? {
        sessionKey = key.rawValue
        return sessionValue
    }
    
    private static func sessionValue(set value : Any?, key : SessionKey) {
        sessionKey = key.rawValue
        sessionValue = value
    }
    
    static var userLoggedIn : Bool {
        get {return sessionValue(get: .loggedIn) as? Bool ?? false}
        set {sessionValue(set: newValue, key: .loggedIn)}
    }
    
    static var deviceToken : String? {
        get {return sessionValue(get: .deviceToken) as? String}
        set {sessionValue(set: newValue, key: .deviceToken)}
    }
    
    static var userID : Int {
        get {return sessionValue(get: .id) as? Int ?? 0}
        set {sessionValue(set: newValue, key: .id)}
    }
    
    static var name : String? {
        get {return sessionValue(get: .name) as? String ?? NSLocalizedString("Не указано", comment: "")}
        set {sessionValue(set: newValue, key: .name)}
    }
    
    static var surname : String? {
        get {return sessionValue(get: .surname) as? String ?? NSLocalizedString("Не указана", comment: "")}
        set {sessionValue(set: newValue, key: .surname)}
    }
    
    static var accessToken : String? {
        get {return sessionValue(get: .accessToken) as? String}
        set {sessionValue(set: newValue, key: .accessToken)}
    }
    
    static var mail : String? {
        get {return sessionValue(get: .mail) as? String ?? NSLocalizedString("Не указана", comment: "")}
        set {sessionValue(set: newValue, key: .mail)}
    }
    
    static var password : String? {
        get {return sessionValue(get: .password) as? String}
        set { sessionValue(set: newValue, key: .password)}
    }
    
    static var companyID : Int {
        get {return sessionValue(get: .company) as? Int ?? 0}
        set {sessionValue(set: newValue, key: .company)}
    }
    
    static var admin : Bool {
        get {return sessionValue(get: .admin) as? Bool ?? false}
        set {sessionValue(set: newValue, key: .admin)}
    }
    
    static var tintColor : UIColor {
        return UIColor(red: 21 / 255.0, green: 149 / 255.0, blue: 136 / 255.0, alpha: 1)
    }

}
