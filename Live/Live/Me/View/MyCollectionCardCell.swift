//
//  MyCollectionCardCell.swift
//  Live
//
//  Created by Beryter on 2019/8/29.
//  Copyright © 2019 Beryter. All rights reserved.
//

import Foundation
import UIKit
import VerticalCardSwiper
import RxSwift
import RxCocoa

class MyCollectionCardCell: CardCell {
    
    private let disposeBag = DisposeBag()
    var cancelCollectionHandler: ((LiveColor) -> Void)?
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
        layer.cornerRadius = 12
        clipsToBounds = true
        contentView.backgroundColor = .white
        contentView.addSubview(nameLabel)
        contentView.addSubview(colorValueLabel)
        contentView.addSubview(collectionIconButton)
    }
    
    private func updateView() {
        let textColor = color?.color.getClearTextColor()
        contentView.backgroundColor = color?.color
        nameLabel.text = color?.name
        nameLabel.by_size = nameLabel.sizeThatFits(CGSize(width: by_width - 60 - collectionIconButton.by_width, height: CGFloat.greatestFiniteMagnitude))
        nameLabel.textColor = textColor
        
        colorValueLabel.text = color?.colorHexString
        colorValueLabel.sizeToFit()
        colorValueLabel.textColor = textColor
        colorValueLabel.by_top = nameLabel.by_bottom + 20
        colorValueLabel.by_left = nameLabel.by_left
        
        collectionIconButton.by_centerY = nameLabel.by_centerY
    }
    
    //MARK: - view
    
    private lazy var nameLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        lb.textAlignment = .center
        lb.textColor = .black
        lb.by_top = 30
        lb.by_left = 30
        lb.font = UIFont(name:"HiraMinProN-W6",size: 24)
        return lb
    }()
    
    private lazy var colorValueLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.textColor = .black
        lb.font = UIFont.systemFont(ofSize: 17)
        return lb
    }()
    
    lazy var collectionIconButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "icon_collect_save"), for: .normal)
        btn.setImage(UIImage(named: "icon_collect_save"), for: .highlighted)
        btn.sizeToFit()
        btn.by_right = by_width - 30
        btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            guard let bl = self.cancelCollectionHandler else { return }
            bl(self.color!)
        }).disposed(by: disposeBag)
        return btn
    }()
    
    
}
