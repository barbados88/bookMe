//
//  Company.swift
//  BookMe
//
//  Created by mac on 28.01.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit
import RealmSwift

class Company: Object {

    dynamic var id : String? = nil
    dynamic var companyName : String? = nil
    dynamic var companyDescription : String? = nil
    
    override static func primaryKey() -> String {
        return "id"
    }
    
}
