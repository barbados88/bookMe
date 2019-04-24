//
//  Bridge.swift
//  BookMe
//
//  Created by mac on 01.04.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit

enum EmptyType {
    
    case favourite
    case books
    case history
    
}

protocol Empty {
    
    var emptyView : EmptyView {set get}
    var screenTitle: String { get }
    var emptyTitle: String { get }
    var emptyDescription: String { get }
    var emptyImage: UIImage { get }
    func shouldHide(_ numberOfBooks : Int) -> Bool

}

protocol EmptyView {
    
    func shouldHide(_ numberOfBooks : Int) -> Bool
    var screenTitle: String { get }
    var emptyTitle: String { get }
    var emptyDescription: String { get }
    var emptyImage: UIImage { get }
    
}

class Bridge: Empty {

    var emptyView : EmptyView
    
    func shouldHide(_ numberOfBooks: Int) -> Bool {
        return emptyView.shouldHide(numberOfBooks)
    }
    
    var screenTitle: String {
        return emptyView.screenTitle
    }
    
    var emptyTitle: String {
        return emptyView.emptyTitle
    }
    
    var emptyDescription: String {
        return emptyView.emptyDescription
    }
    
    var emptyImage: UIImage {
        return emptyView.emptyImage
    }
    
    init(emptyView : EmptyView) {
        self.emptyView = emptyView
    }
    
}

class EmptyFavourites: EmptyView {
    
    func shouldHide(_ numberOfBooks: Int) -> Bool {
        return numberOfBooks > 0
    }
    
    var screenTitle: String {
        return NSLocalizedString("Избранное", comment: "")
    }
    
    var emptyTitle: String {
        return NSLocalizedString("Избранного нет.", comment: "")
    }
    
    var emptyDescription: String {
        return NSLocalizedString("Здесь будут появлятся книги котрые вы добавите в избранное", comment: "")
    }
    
    var emptyImage: UIImage {
        return UIImage()
    }
    
}

class EmptyBooks: EmptyView {
    
    func shouldHide(_ numberOfBooks: Int) -> Bool {
        return numberOfBooks > 0
    }
    
    var screenTitle: String {
        return NSLocalizedString("Мои книги", comment: "")
    }
    
    var emptyTitle: String {
        return NSLocalizedString("Список пуст.", comment: "")
    }
    
    var emptyDescription: String {
        return NSLocalizedString("Здесь будут появлятся книги котрые вы взяли для прочтения, или резервируете для прочтения в будущем", comment: "")
    }
    
    var emptyImage: UIImage {
        return UIImage()
    }
    
}

class EmptyHistory: EmptyView {
    
    func shouldHide(_ numberOfBooks: Int) -> Bool {
        return numberOfBooks > 0
    }
    
    var screenTitle: String {
        return NSLocalizedString("История", comment: "")
    }
    
    var emptyTitle: String {
        return NSLocalizedString("Истории нет.", comment: "")
    }
    
    var emptyDescription: String {
        return NSLocalizedString("Здесь будут появлятся книги после прочтения", comment: "")
    }
    
    var emptyImage: UIImage {
        return UIImage()
    }
    
    
}





















