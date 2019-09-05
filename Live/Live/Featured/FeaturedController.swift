//
//  FeaturedController.swift
//  Live
//
//  Created by Beryter on 2019/8/26.
//  Copyright © 2019 Beryter. All rights reserved.
//

import Foundation
import UIKit

class FeaturedController: BaseViewController {
    
    /// 系列列表
    private var seriesList = [ColorSeries]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "精选"
        view.addSubview(collectionView)
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.loadData()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.by_height = Constants.screenHeight - Constants.statusNavHeight - (tabBarController?.tabBar.by_height ?? 0)
    }
    
    //MARK: - Func
    private func loadData() {
        let path = Bundle.main.path(forResource: "feature_series_list", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
        guard let dt = data else { return }
        let list = try? JSONSerialization.jsonObject(with: dt, options: .allowFragments)
        guard let lt = list as? Array<[String: Any]> else { return }
        for item in lt {
            guard let id = item["id"] as? Int else { continue }
            let series_name = (item["series_name"] as? String) ?? ""
            let colors = (item["colors"] as? [[String: Any]]) ?? []
            var colorList = [LiveColor]()
            for citem in colors {
                let cid = (citem["id"] as? String) ?? ""
                let r = (citem["r"] as? CGFloat) ?? 0
                let g = (citem["g"] as? CGFloat) ?? 0
                let b = (citem["b"] as? CGFloat) ?? 0
                let name = (citem["name"] as? String) ?? ""
                let seriesName = (citem["series_name"] as? String) ?? ""
                let color = LiveColor(id: cid, r: r, g: g, b: b, name: name, seriesName: seriesName)
                colorList.append(color)
            }
            let series = ColorSeries(id: id, name: series_name, colors: colorList)
            seriesList.append(series)
        }
    }
    
    //MARK: - view

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect(x: 0, y: Constants.statusNavHeight, width: view.by_width, height: Constants.screenHeight - Constants.statusNavHeight), collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.alwaysBounceVertical = true
        cv.alwaysBounceHorizontal = false
        cv.backgroundColor = view.backgroundColor
        cv.register(FeaturedCell.self, forCellWithReuseIdentifier: String(describing: FeaturedCell.self))
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
}

extension FeaturedController: UICollectionViewDelegate {
    
}

extension FeaturedController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return seriesList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FeaturedCell.self), for: indexPath) as! FeaturedCell
        cell.series = seriesList[indexPath.item]
        return cell
    }
}

extension FeaturedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width:view.by_width, height: 248)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        15
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
}
