//
//  ActivityView.swift
//  tamak
//
//  Created by mac on 04.01.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit

class ActivityView: UIView {

    static func configure(with size: CGSize) -> ActivityView {
        let view = Bundle.main.loadNibNamed("ActivityView", owner: nil, options: nil)?.first as! ActivityView
        view.frame = CGRect(origin: CGPoint.zero, size: size)
        return view
    }

}
