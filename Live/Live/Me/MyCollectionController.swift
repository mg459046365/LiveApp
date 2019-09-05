//
//  MyCollectionController.swift
//  Live
//
//  Created by Beryter on 2019/8/28.
//  Copyright © 2019 Beryter. All rights reserved.
//

import Foundation
import UIKit
import VerticalCardSwiper

class MyCollectionController: BaseViewController {
    var colors = [LiveColor]()

    enum DisplayStyle {
        case list
        case card
    }

    private var displayStyle = DisplayStyle.list

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.title = "我的收藏"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_icon"), style: .plain, target: self, action: #selector(back))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_card_view"), style: .plain, target: self, action: #selector(changeDisplayStyle))
        view.addSubview(cardSwiper)
        view.addSubview(collectionView)
        loadData()
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

    @objc private func changeDisplayStyle() {
        if #available(iOS 10.0, *) {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        } else {
            // Fallback on earlier versions
        }
        
        switch displayStyle {
        case .list:
            displayStyle = .card
            navigationItem.rightBarButtonItem?.image = UIImage(named: "icon_list_view")
            cardSwiper.reloadData()
            collectionView.isHidden = true
            cardSwiper.isHidden = false
        case .card:
            displayStyle = .list
            navigationItem.rightBarButtonItem?.image = UIImage(named: "icon_card_view")
            collectionView.reloadData()
            cardSwiper.isHidden = true
            collectionView.isHidden = false
        }
    }

    // MARK: - Func

    private func loadData() {
        let path = Bundle.main.path(forResource: "feature_series_list", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
        guard let dt = data else { return }
        let list = try? JSONSerialization.jsonObject(with: dt, options: .allowFragments)
        guard let lt = list as? Array<[String: Any]> else { return }
        for item in lt {
            guard let _ = item["id"] as? Int else { continue }
//            let series_name = (item["series_name"] as? String) ?? ""
            let tmpcolors = (item["colors"] as? [[String: Any]]) ?? []
            for citem in tmpcolors {
                let cid = (citem["id"] as? String) ?? ""
                let r = (citem["r"] as? CGFloat) ?? 0
                let g = (citem["g"] as? CGFloat) ?? 0
                let b = (citem["b"] as? CGFloat) ?? 0
                let name = (citem["name"] as? String) ?? ""
                let seriesName = (citem["series_name"] as? String) ?? ""
                let color = LiveColor(id: cid, r: r, g: g, b: b, name: name, seriesName: seriesName)
                colors.append(color)
            }
            break
        }
        collectionView.reloadData()
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

    lazy var cardSwiper: VerticalCardSwiper = {
        let cs = VerticalCardSwiper(frame: collectionView.frame)
        cs.register(MyCollectionCardCell.self, forCellWithReuseIdentifier: String(describing: MyCollectionCardCell.self))
        cs.isHidden = true
        cs.delegate = self
        cs.datasource = self
        cs.isSideSwipingEnabled = false
        return cs
    }()
}

extension MyCollectionController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ColorDetailController(color: colors[indexPath.item])
        let image = UIImage(color: colors[indexPath.item].color, size: CGSize(width: 1, height: 1))
        let imageView = UIImageView(image: image)
        let v = collectionView.cellForItem(at: indexPath)!.contentView
        imageView.frame = v.convert(v.frame, to: view)
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        vc.transitionView = imageView
        present(vc, animated: true, completion: nil)
    }
}

extension MyCollectionController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cl = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MyCollectionCell.self), for: indexPath) as! MyCollectionCell
        cl.color = colors[indexPath.item]
        return cl
    }
}

extension MyCollectionController: VerticalCardSwiperDelegate {
    
    func willSwipeCardAway(card: CardCell, index: Int, swipeDirection: SwipeDirection) {
        colors.remove(at: index)
    }
    
    func didSwipeCardAway(card: CardCell, index: Int, swipeDirection: SwipeDirection) {
        let alert = UIAlertController(title: "确定取消收藏", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (_) in
            
        }
        let confirm = UIAlertAction(title: "确定", style: .default) { [weak self] (_) in
//            guard let self = self else { return }
//            self.colors.remove(at: index)
        }
        alert.addAction(cancel)
        alert.addAction(confirm)
        present(alert, animated: true, completion: nil)
    }

    func didTapCard(verticalCardSwiperView: VerticalCardSwiperView, index: Int) {
        let vc = ColorDetailController(color: colors[index])
        let image = UIImage(color: colors[index].color, size: CGSize(width: 1, height: 1))
        
        let imageView = UIImageView(image: image)
        let v = verticalCardSwiperView.cellForItem(at: IndexPath(item: index, section: 0))!
        imageView.frame = v.convert(v.frame, to: view)
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        vc.transitionView = imageView
        present(vc, animated: true, completion: nil)
    }

    func sizeForItem(verticalCardSwiperView: VerticalCardSwiperView, index: Int) -> CGSize {
        cardSwiper.bounds.size
    }
}

extension MyCollectionController: VerticalCardSwiperDatasource {
    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
        colors.count
    }

    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        let cell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: String(describing: MyCollectionCardCell.self), for: index) as! MyCollectionCardCell
        cell.color = colors[index]
        return cell
    }
}
