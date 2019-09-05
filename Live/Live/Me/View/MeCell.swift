//
//  MeCell.swift
//  Live
//
//  Created by Beryter on 2019/8/28.
//  Copyright © 2019 Beryter. All rights reserved.
//

import UIKit

class MeCell: UITableViewCell {

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        bounds = CGRect(origin: .zero, size: CGSize(width: Constants.screenWidth, height: 44))
        backgroundColor = .white
        selectionStyle = .none
        contentView.addSubview(rightIndicator)
        contentView.addSubview(titleLabel)
    }
    
    func update(title: String) {
        titleLabel.text = title
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - VIEW
    lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.frame = CGRect(x: 15, y: 0, width: rightIndicator.by_left - 35, height: by_height)
        lb.textColor = UIColor(0x51526F)
        lb.font = UIFont.systemFont(ofSize: 17)
        lb.textAlignment = .left
        return lb
    }()
    
    private lazy var rightIndicator: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "accessory_indicator"))
        iv.sizeToFit()
        iv.by_right = self.by_width - 15
        iv.by_centerY = self.by_height/2
        return iv
    }()
    
}
