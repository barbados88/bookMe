//
//  IndexView.swift
//  BookMe
//
//  Created by Woxapp on 07.10.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit

class IndexView: UIView {

    var indexes : [String] = []
    var scrollDelegate : IndexScrollDelegate? = nil
    
    static func configure(with array : [String]) -> IndexView {
        let view = Bundle.main.loadNibNamed("IndexView", owner: nil, options: nil)?.first as! IndexView
        view.indexes = array
        view.frame.size = CGSize(width: 20, height: (UIScreen.main.bounds.size.width - 214))
        view.addIndexes()
        return view
    }

    private func addIndexes() {
        var y : CGFloat = 0
        let height : CGFloat = frame.size.height / CGFloat(indexes.count)
        indexes.forEach { letter in
            let button = UIButton(frame: CGRect(x: 0, y: y, width: frame.size.width, height: height))
            y += height
            button.addTarget(self, action: #selector(self.scrollTo(_:)), for: .touchUpInside)
            button.setTitle(letter, for: .normal)
            addSubview(button)
        }
    }
    
    @objc private func scrollTo(_ sender : UIButton) {
        scrollDelegate?.scrollTo(section: indexes.index(of: sender.title(for: .normal) ?? "") ?? 0)
    }
    
}
