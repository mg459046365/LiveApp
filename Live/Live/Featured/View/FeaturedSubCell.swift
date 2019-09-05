//
//  FeaturedSubCell.swift
//  Live
//
//  Created by Beryter on 2019/8/27.
//  Copyright © 2019 Beryter. All rights reserved.
//

import UIKit

class FeaturedSubCell: UICollectionViewCell {
    
    var featureColor: LiveColor? {
        didSet {
            updateView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layer.cornerRadius = 8
        contentView.layer.cornerRadius = 8
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.6
        contentView.addSubview(colorValueLabel)
    }
    
    private func updateView() {
        backgroundColor = featureColor?.color
        colorValueLabel.text = featureColor?.colorHexString
        colorValueLabel.textColor = featureColor?.color.getClearTextColor()
    }
    
    //MARK: - View
    lazy var colorValueLabel: UILabel = {
        let lb = UILabel()
        lb.frame = CGRect(x: 10, y: 10, width: by_width - 20, height: 18)
        lb.textAlignment = .left
        lb.textColor = .black
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
}
