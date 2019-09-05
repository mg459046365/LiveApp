//
//  MyCollectionCell.swift
//  Live
//
//  Created by Beryter on 2019/8/28.
//  Copyright © 2019 Beryter. All rights reserved.
//

import UIKit

class MyCollectionCell: UICollectionViewCell {
    
    var color: LiveColor? {
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
        frame = CGRect(origin: .zero, size: CGSize(width: Constants.screenWidth - 36, height: 100))
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.6
        contentView.layer.cornerRadius = 12
        contentView.addSubview(titleLabel)
        contentView.addSubview(colorValueLabel)
    }

    private func updateView() {
        contentView.backgroundColor = color!.color
        titleLabel.text = color!.name
        titleLabel.sizeToFit()
        titleLabel.by_right = by_width - 18
        titleLabel.by_centerY = by_height/2
        colorValueLabel.text = color!.colorHexString
        colorValueLabel.sizeToFit()
        colorValueLabel.by_right = by_width - 18
        colorValueLabel.by_top = titleLabel.by_bottom + 8
        let textColor = color!.color.getClearTextColor()
        titleLabel.textColor = textColor
        colorValueLabel.textColor = textColor
    }
    
    // MARK: - view
    lazy var colorValueLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.textColor = .black
        lb.font = UIFont.systemFont(ofSize: 17)
        return lb
    }()
    
    lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.textColor = .black
        lb.font = UIFont(name:"HiraMinProN-W6",size: 20)
        return lb
    }()
    
}
