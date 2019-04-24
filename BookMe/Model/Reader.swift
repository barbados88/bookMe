//
//  Reader.swift
//  BookMe
//
//  Created by mac on 28.01.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit
import RealmSwift

class Reader: Object {

    dynamic var id : Int = 0
    dynamic var name : String? = nil
    
    
    override static func primaryKey() -> String {
        return "id"
    }
    
    static func initWith(dictionary : [String : AnyObject]) -> Reader {
        let user = Reader()
        user.id = dictionary["user_id"] as? Int ?? 0
        user.name = dictionary["user_name"] as? String
        return user
    }
    
    
}
