//
//  Constants.swift
//  BookMe
//
//  Created by Woxapp on 30.11.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import Foundation

struct Constants {
    #if os(OSX)
    static let syncHost = "127.0.0.1"
    #else
    static let syncHost = localIPAddress
    #endif
    
    static let syncRealmPath = "BookMe"
    static let defaultListName = "My Tasks"
    static let defaultListID = "80EB1620-165B-4600-A1B1-D97032FDD9A0"
    
    static let syncServerURL = URL(string: "realm://\(syncHost):9080/~/\(syncRealmPath)")
    static let syncAuthURL = URL(string: "http://\(syncHost):9080")!
    
    static let appID = Bundle.main.bundleIdentifier!
}
