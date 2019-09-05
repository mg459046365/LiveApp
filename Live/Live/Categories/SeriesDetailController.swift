//
//  SeriesDetailController.swift
//  Live
//
//  Created by Beryter on 2019/9/4.
//  Copyright © 2019 Beryter. All rights reserved.
//

import Foundation
import UIKit

class SeriesDetailController: BaseViewController {
    private var series: ColorSeries

    init(series: ColorSeries) {
        self.series = series
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.title = series.name
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_icon"), style: .plain, target: self, action: #selector(back))
        view.addSubview(collectionView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 18
        layout.minimumInteritemSpacing = 18
        layout.itemSize = CGSize(width: Constants.screenWidth - 36, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 18, left: 0, bottom: 48, right: 0)
        let cv = UICollectionView(frame: CGRect(x: 0, y: Constants.statusNavHeight, width: view.by_width, height: Constants.screenHeight - Constants.statusNavHeight), collectionViewLayout: layout)
        cv.register(MyCollectionCell.self, forCellWithReuseIdentifier: String(describing: MyCollectionCell.self))
        cv.backgroundColor = view.backgroundColor
        cv.showsVerticalScrollIndicator = false
        cv.alwaysBounceVertical = true
        cv.delegate = self
        cv.dataSource = self
        if #available(iOS 11.0, *) {
            cv.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        return cv
    }()
}

extension SeriesDetailController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ColorDetailController(color: series.colors[indexPath.item])
        let image = UIImage(color: series.colors[indexPath.item].color, size: CGSize(width: 1, height: 1))
        let imageView = UIImageView(image: image)
        let v = collectionView.cellForItem(at: indexPath)!.contentView
        imageView.frame = v.convert(v.frame, to: view)
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        vc.transitionView = imageView
        present(vc, animated: true, completion: nil)
    }
}

extension SeriesDetailController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return series.colors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cl = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MyCollectionCell.self), for: indexPath) as! MyCollectionCell
        cl.color = series.colors[indexPath.item]
        return cl
    }
}
