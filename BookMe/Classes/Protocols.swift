//
//  Protocols.swift
//  BookMe
//
//  Created by Woxapp on 07.10.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit

protocol SegueDelegate : class {
    
    func performSegue(with identifier: String, sender: Any?)
    
}

protocol IndexScrollDelegate : class {
    
    func scrollTo(section: Int)
    
}

class Protocols: NSObject {

}
