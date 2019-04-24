//
//  ServerError.swift
//  BookMe
//
//  Created by mac on 20.01.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit

class ServerError: NSObject {

    private static var APPLICATION_NAME : String? {
        return Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String
    }
    
    private static var dictionary : [Int : String] {
        var dict : [Int : String] = [:]
        dict[777] = NSLocalizedString("Пожалуйста, проверьте подключение к сети.", comment:"")
        dict[778] = NSLocalizedString("Книга уже занесена в библиотеку.", comment:"")
        dict[779] = NSLocalizedString("Книга не занесена в базу данных библиотеки, пожалуйста, обратитесь к администартору.", comment:"")
        dict[780] = NSLocalizedString("Вы взяли книгу для прочтения. Увидеть книгу можно во вкладке \"Мои книги\".", comment:"")
        dict[781] = NSLocalizedString("Ссылка повреждена, пожалуйста, обратитесь к администратору.", comment:"")
        dict[782] = NSLocalizedString("Введите новый, сгенерированый пароль, который был отправлен вам на почту.", comment: "")
        dict[783] = NSLocalizedString("Не удалось определить код, пожалуйста введите код вручную.", comment: "")
        return dict
    }
    
    static func stringError(code : Int) {
        show(error: code, nil, nil)
    }
    
    static func show(error code: Int, _ button : String? = nil, _ handler: ((UIAlertAction) -> Void)? = nil) {
        if let message = dictionary[code] {
            show(alert: message, button, handler)
        }
    }
    
    static func show(alert message : String, _ button : String? = nil, _ handler: ((UIAlertAction) -> Void)? = nil) {
        if isShowing == true {return}
        let alert = UIAlertController(title: APPLICATION_NAME, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: button ?? "OK", style: .default, handler: handler))
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    private static var isShowing : Bool {
        return UIApplication.topViewController() is UIAlertController
    }
    
}
