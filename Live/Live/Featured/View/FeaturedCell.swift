//
//  FeaturedCell.swift
//  Live
//
//  Created by Beryter on 2019/8/27.
//  Copyright © 2019 Beryter. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FeaturedCell: UICollectionViewCell {
    
    private let disposeBag = DisposeBag()
    private let subCellWidth = (200 - 36)/(UIScreen.currentHeight()/UIScreen.currentWidth())
    
    
    var downloadHandler: (() -> Void)?
    var series: ColorSeries? {
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
        contentView.backgroundColor = .white
        frame = CGRect(origin: .zero, size: CGSize(width: Constants.screenWidth, height: 248))
        contentView.addSubview(titleLabel)
        contentView.addSubview(downloadButton)
        contentView.addSubview(collectionView)
    }
    
    private func updateView() {
        titleLabel.text = series?.name
        collectionView.reloadData()
    }
    
    //MARK: - view
    
    lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.frame = CGRect(x: 20, y: 0, width: by_width - 20, height: 48)
        lb.textColor = .black
        lb.font = UIFont.systemFont(ofSize: 17)
        lb.textAlignment = .left
        return lb
    }()
    
    lazy var downloadButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "icon_download"), for: .normal)
        btn.tintColor = UIColor(0x8CA5FF)
        btn.setImage(UIImage(named: "icon_download"), for: .highlighted)
        btn.by_size = CGSize(width: 20, height: 20)
        btn.contentMode = .scaleToFill
        btn.by_right = by_width - 20
        btn.by_centerY = titleLabel.by_centerY
        btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            guard let bl = self.downloadHandler else { return }
            bl()
        }).disposed(by: disposeBag)
        return btn
    }()
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect(x: 0, y: titleLabel.by_bottom, width: by_width, height: 200), collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.alwaysBounceVertical = false
        cv.alwaysBounceHorizontal = true
        cv.backgroundColor = .white
        cv.register(FeaturedSubCell.self, forCellWithReuseIdentifier: String(describing: FeaturedSubCell.self))
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
}

extension FeaturedCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension FeaturedCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.series?.colors.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FeaturedSubCell.self), for: indexPath) as! FeaturedSubCell
        cell.featureColor = self.series!.colors[indexPath.item]
        return cell
    }
}

extension FeaturedCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: subCellWidth, height: 200 - 36)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        18
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
    }
}
