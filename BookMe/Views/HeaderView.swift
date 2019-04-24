//
//  HeaderView.swift
//  ZZ
//
//  Created by mac on 07.02.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit

class HeaderView: UIView {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var labelTopSpace: NSLayoutConstraint!
    
    var section : Int = 0
    
    static func configure(with height: CGFloat) -> HeaderView {
        let view = Bundle.main.loadNibNamed("HeaderView", owner: nil, options: nil)?.first as! HeaderView
        view.frame = CGRect(origin: CGPoint.zero, size: CGSize(width : UIScreen.main.bounds.size.width, height: height))
        return view
    }

}
