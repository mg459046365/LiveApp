//
//  MeHeader.swift
//  Live
//
//  Created by Beryter on 2019/8/27.
//  Copyright © 2019 Beryter. All rights reserved.
//

import Foundation
import UIKit

class MeHeader: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Func
    
    private func setupView() {
//        backgroundColor = UIColor(0x475C7A)
        addSubview(bgImageView)
        addSubview(bottomView)
    }
    
    private func updateView() {
        
    }
    
    func updateDisplayOffsetYChanged(_ offsetY: CGFloat) {
        if offsetY >= 0 {
            bgImageView.by_top = 0
            bgImageView.by_height = by_height
            return
        }
        bgImageView.by_top = offsetY
        bgImageView.by_height = by_height - offsetY
    }
    
    
    //MARK: - view
    
    lazy var bgImageView: UIImageView = {
        let iv = UIImageView(frame: bounds)
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = UIColor(0x475C7A)
        return iv
    }()
    
    lazy var bottomView: UIView = {
        let bv = UIView(frame: CGRect(x: 0, y: self.by_height - 60, width: by_width, height: 60))
        bv.backgroundColor = .white
        let maskPath = UIBezierPath(roundedRect: bv.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 40, height: 40))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bv.bounds
        maskLayer.path = maskPath.cgPath
        bv.layer.mask = maskLayer
        
        return bv
    }()
    
    
}
