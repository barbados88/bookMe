//
//  FishView.swift
//  BookMe
//
//  Created by mac on 01.04.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit

class FishView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    static func configure(inView emptyView : UIView) -> FishView {
        let view = Bundle.main.loadNibNamed("FishView", owner: nil, options: nil)?.first as! FishView
        view.frame = emptyView.frame
        emptyView.addSubview(view)
        return view
    }
    
    func fixFrame() {
        if superview == nil {return}
        frame = superview!.frame
    }
    
    func fillInfo(emptyView : EmptyView) {
        titleLabel.text = emptyView.emptyTitle
        descriptionLabel.text = emptyView.emptyDescription
    }
    
}
