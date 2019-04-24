//
//  Formatter.swift
//  BookMe
//
//  Created by mac on 01.04.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit

enum Format : String {
    case server = "yyyy-MM-dd HH:mm:ss"
    case activity = "yyyy-MM-dd HH:mm"
    case dateWithTime = "dd.MM.yyyy (HH:mm)"
    case anchor = "yyyy-MM-dd"
    case dateYearLong = "dd.MM.yyyy"
    case dateYearShort = "dd.MM.yy"
    case timeWithSeconds = "HH:mm:ss"
    case time = "HH:mm"
    case zz = "d MMMM, EEEE."
    case record = "EE, dd.MM.yy"
    case day = "dd.MM"
    case weekDay = "EEEE"
    case month = "MMM"
    case year = "yyyy"
    case cart = "HH:mm, dd.MM.yyyy"
}

class Formatter: NSObject {
    
    static func formatter(using format : Format) -> DateFormatter {
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter
    }
    
    private static var dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    } ()
    
    static var numberFormatter : NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        return formatter
    } ()
    
}
