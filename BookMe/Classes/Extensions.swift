//
//  Extensions.swift
//  BookMe
//
//  Created by mac on 20.01.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit
import MobileCoreServices
import AudioToolbox
import MessageUI
import RealmSwift

extension List {
    
    var array : [Object] {
        var array : [Object] = []
        for object in self {
            if object is Object {
                array.append(object as! Object)
            }
        }
        return array
    }
    
}

extension MFMailComposeViewController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isTranslucent = false
        navigationBar.isOpaque = false
        navigationBar.backgroundColor = UIColor(red: 248 / 255.0, green: 248 / 255.0, blue: 248 / 255.0, alpha: 1.0)
        navigationBar.barTintColor = Session.tintColor
        navigationBar.tintColor = Session.tintColor
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : Session.tintColor]
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = UIColor(red: 248 / 255.0, green: 248 / 255.0, blue: 248 / 255.0, alpha: 1.0)
    }
    
}

extension UICollectionView {
    
    func processVisibleItems() {
        let items = indexPathsForVisibleItems
        for path in items {
            let layer = CALayer()
            layer.frame = layer.bounds
            layer.backgroundColor = UIColor.clear.cgColor
            var frame = layer.frame
            frame.origin.x -= layer.frame.size.width / 2
            layer.frame = frame
            layer.anchorPoint = CGPoint(x: 0, y: 0.5)
            self.layer.addSublayer(layer)
            let cell = cellForItem(at: path)
            cell?.frame = layer.convert(cell!.frame, from: cell!.superview?.layer)
            layer.addSublayer(cell!.layer)
            addAnimation(for: layer)
        }
    }
    
    private func addAnimation(for layer : CALayer) {
        let fade = CABasicAnimation(keyPath: "opacity")
        fade.toValue = 0
        let rotate = CABasicAnimation(keyPath: "transform")
        var tfm = CATransform3DMakeRotation(CGFloat((Double(arc4random_uniform(35) + 50) * .pi) / 180.0), 0.0, -1.0, 0.0)
        tfm.m14 = -0.002
        rotate.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        rotate.toValue = NSValue(caTransform3D: tfm)
        let group = CAAnimationGroup()
        group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        group.fillMode = kCAFillModeForwards
        group.isRemovedOnCompletion = false
        group.duration = Double.random(min: 0.35, max: 0.6)
        group.animations = [rotate, fade]
        layer.add(group, forKey: "rotateAndFadeAnimation")
    }
    
    private func disableAnimation(){}
    
}

extension Date {
    
    func period(to date: Date) -> String {
        return longTimeAgo(timeInterval: fabs(self.timeIntervalSince(date)))
    }
    
    fileprivate func longTimeAgo(timeInterval : Double) -> String {
        let interval : Int = Int(floor(fabs(timeInterval / 86400)))
        if interval < 7 {
            if interval < 1 {
                return today(timeInterval : timeInterval)
            }
            return thisWeek(timeInterval : timeInterval)
        }
        if timeInterval < 30 {
            return thisMonth(timeInterval : timeInterval)
        }
        if timeInterval < 365 {
            return thisYear(timeInterval : timeInterval)
        }
        return notThisYear(timeInterval : timeInterval)
    }
    
    fileprivate func today(timeInterval : TimeInterval) -> String {
        let timeInterval : Int = Int(floor(fabs(timeInterval / 60)))
        if timeInterval < 60 {
            return String(format: "%@", Utils.endOfWord(words: [NSLocalizedString("минуту", comment: ""), NSLocalizedString("минуты", comment: ""), NSLocalizedString("минут", comment: "")], number: timeInterval))
        }
        return String(format: "%@", Utils.endOfWord(words: [NSLocalizedString("час", comment: ""), NSLocalizedString("часа", comment: ""), NSLocalizedString("часов", comment: "")], number: timeInterval / 60))
    }
    
    fileprivate func thisWeek(timeInterval : TimeInterval) -> String {
        let timeInterval : Int = Int(floor(fabs(self.timeIntervalSinceNow / 86400)))
        return String(format: "%@", Utils.endOfWord(words: [NSLocalizedString("день", comment: ""), NSLocalizedString("дня", comment: ""), NSLocalizedString("дней", comment: "")], number: timeInterval))
    }
    
    fileprivate func thisMonth(timeInterval : TimeInterval) -> String {
        let timeInterval : Int = Int(floor(fabs(self.timeIntervalSinceNow / 86400) / 7))
        return String(format: "%@", Utils.endOfWord(words: [NSLocalizedString("неделя", comment: ""), NSLocalizedString("недели", comment: ""), NSLocalizedString("недель", comment: "")], number: timeInterval))
    }
    
    fileprivate func thisYear(timeInterval : TimeInterval) -> String {
        let timeInterval : Int = Int(floor(fabs(self.timeIntervalSinceNow / 86400) / 30))
        if timeInterval == 6 {
            return NSLocalizedString("Полгода", comment: "")
        }
        return String(format: "%@", Utils.endOfWord(words: [NSLocalizedString("месяц", comment: ""), NSLocalizedString("месяца", comment: ""), NSLocalizedString("месяцев", comment: "")], number: timeInterval))
    }
    
    fileprivate func notThisYear(timeInterval : TimeInterval) -> String {
        let timeInterval : Int = Int(floor(fabs(self.timeIntervalSinceNow / 86400) / 365))
        return String(format: "%@", Utils.endOfWord(words: [NSLocalizedString("год", comment: ""), NSLocalizedString("года", comment: ""), NSLocalizedString("лет", comment: "")], number: timeInterval))
    }
    
}


extension UIApplication {
    
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController
            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topViewController(base: top)
            } else if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

extension UISearchBar {
    
    func addActivity() {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.startAnimating()
        for view in subviews {
            for subview in view.subviews {
                if subview is UITextField {
                    let textField = subview as! UITextField
                    textField.rightView = UIView(frame : CGRect(x: 0, y: 0, width: 27, height: textField.frame.size.height))
                    textField.rightViewMode = .always
                    textField.rightView = activityIndicator
                    break
                }
            }
        }
    }
    
    func removeActivity() {
        for view in subviews {
            for subview in view.subviews {
                if subview is UITextField {
                    let textField = subview as! UITextField
                    textField.rightView = nil
                    break
                }
            }
        }
    }
    
}

extension UILabel {
    
    func textWithSearchBarText(searchText: String) {
        if let text = self.text {
            self.attributedText = stringWithSearchBarString(string: text, other: searchText)
        } else {
            self.attributedText = NSAttributedString()
        }
    }
    
    fileprivate func stringWithSearchBarString(string : String, other : String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        if other.count == 0 {
            return attributedString
        }
        let dotRanges : [NSRange]
        do {
            let regex = try NSRegularExpression(pattern: other.lowercased(), options: [])
            dotRanges = regex.matches(in: string.lowercased(), options: [], range: NSMakeRange(0, string.count)).map {$0.range}
        } catch {
            dotRanges = []
        }
        let rangeColor = Session.tintColor
        for dotRange in dotRanges {
            attributedString.addAttribute(NSForegroundColorAttributeName, value: rangeColor, range: dotRange)
        }
        return attributedString
    }
    
}

extension String {
    
    func md5() -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        if let data = self.data(using: String.Encoding.utf8) {
            CC_MD5((data as NSData).bytes, CC_LONG(data.count), &digest)
        }
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        return digestHex
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSFontAttributeName: font]
        let size = self.size(attributes: fontAttributes)
        return size.width
    }
    
}

extension UITextField {
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }
    
}

extension UIViewController {
    
    func addActivity() {
        if isActivityOn == true {return}
        let activity = ActivityView.configure(with: self.view.frame.size)
        UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.view.addSubview(activity)
            self.view.bringSubview(toFront: activity)
        }, completion: nil)
    }
    
    private var isActivityOn : Bool {
        for subview in view.subviews {
            if subview is ActivityView {
                return true
            }
        }
        return false
    }
    
    func removeActivity(animated : Bool) {
        for subview in view.subviews {
            if subview is ActivityView {
                UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    subview.removeFromSuperview()
                }, completion: nil)
            }
        }
    }
    
    func snapShot() -> UIImage {
        let layer = UIApplication.shared.keyWindow!.layer
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, UIScreen.main.scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenshot ?? UIImage()
    }
    
    func addOldBook() {
        view.backgroundColor = UIColor(patternImage: UIImage(named: "back") ?? UIImage())
    }
    
}

extension Bool {
    
    var int : Int {
        return self == true ? 1 : 0
    }
    
}

extension UIView {
    
    func addHole(rect: CGRect) {
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        let path = UIBezierPath(rect: bounds)
        maskLayer.fillRule = kCAFillRuleEvenOdd
        path.append(UIBezierPath(rect: rect))
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
    
    func snapShot() -> UIImage {
        let layer = self.layer
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, UIScreen.main.scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenshot ?? UIImage()
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue  }
        get { return layer.cornerRadius }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set { layer.borderWidth = newValue }
        get { return layer.borderWidth }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set { layer.borderColor = newValue?.cgColor  }
        get { return UIColor(cgColor: layer.borderColor!) }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        set { layer.shadowOffset = newValue  }
        get { return layer.shadowOffset }
    }
    
    @IBInspectable var shadowOpacity: Float {
        set { layer.shadowOpacity = newValue }
        get { return layer.shadowOpacity }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        set {  layer.shadowRadius = newValue }
        get { return layer.shadowRadius }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        set { layer.shadowColor = newValue?.cgColor }
        get { return UIColor(cgColor: layer.shadowColor!) }
    }
    
}

extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    public class func once(token: String, block:() -> Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        if _onceTracker.contains(token) {
            return
        }
        _onceTracker.append(token)
        block()
    }
    
    public class func clearTokens() {
        _onceTracker.removeAll()
    }
    
}

extension Double {
    
    var degrees: Double {
        return self * 180.0 / .pi
    }
    
    var radians : CGFloat {
        return CGFloat(.pi * self / 180.0)
    }
    
    public static var random: Double {
        get {
            return Double(arc4random()) / 0xFFFFFFFF
        }
    }
    
    public static func random(min: Double, max: Double) -> Double {
        return Double.random * (max - min) + min
    }
    
}

extension Notification.Name {
    
    static let rootController = Notification.Name(rawValue: "root")
    static let firstTab = Notification.Name(rawValue: "firstTab")
    static let secondTab = Notification.Name(rawValue: "secondTab")
    static let thirdTab = Notification.Name(rawValue: "thirdTab")
    static let fourthTab = Notification.Name(rawValue: "fourthTab")
    static let fifthTab = Notification.Name(rawValue: "fifthTab")
    
}

extension UITableViewCell {
    
    func leftSeparatorInset(_ left : CGFloat) {
        if responds(to: #selector(getter: UIView.preservesSuperviewLayoutMargins)) {
            layoutMargins = UIEdgeInsetsMake(0, left, 0, 0)
        }
        if responds(to: #selector(getter: UITableViewCell.separatorInset)) {
            separatorInset = UIEdgeInsetsMake(0, left, 0, 0)
        }
    }
    
}

class Extensions: NSObject {
    
}
