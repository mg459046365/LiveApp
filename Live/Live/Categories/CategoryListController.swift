//
//  CategoryListController.swift
//  Live
//
//  Created by Beryter on 2019/8/22.
//  Copyright © 2019 Beryter. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

class CategoryListController: BaseViewController {
    private let longPress = UILongPressGestureRecognizer()

    private var seriesList = [ColorSeries]()
    private var selectedCell: UICollectionViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "配色笔记"
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
        collectionView.frame = CGRect(x: 0, y: Constants.statusNavHeight, width: Constants.screenWidth, height: Constants.screenHeight - Constants.statusNavHeight - (tabBarController?.tabBar.by_height ?? 0))
    }

    // MARK: - Func

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

    // MARK: - Func

    private func deleteItem(atIndexPath indexPath: IndexPath) {
        let alert = UIAlertController(title: "确定要删除此项目吗", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "删除", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.seriesList.remove(at: indexPath.item)
            self.collectionView.perform(#selector(self.collectionView.deleteItems(at:)), with: [indexPath], afterDelay: 0)
        }
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)
    }

    // MARK: - view

    lazy var collectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .vertical
        let cv = UICollectionView(frame: view.bounds, collectionViewLayout: flowlayout)
        cv.backgroundColor = view.backgroundColor
        cv.register(CategoryListCell.self, forCellWithReuseIdentifier: String(describing: CategoryListCell.self))
        cv.showsVerticalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.alwaysBounceVertical = true

        longPress.addTarget(self, action: #selector(handleLongPressGesture(_:)))
        longPress.delegate = self
        for gesture in cv.gestureRecognizers ?? [] {
            if gesture.isKind(of: UILongPressGestureRecognizer.self) {
                gesture.require(toFail: longPress)
            }
        }
        cv.addGestureRecognizer(longPress)
        return cv
    }()
}

extension CategoryListController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: Constants.screenWidth - 36, height: 72)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 18, left: 0, bottom: 48, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        18
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        18
    }
}

extension CategoryListController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let vc = SeriesDetailController(series: seriesList[indexPath.item])
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CategoryListController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        seriesList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CategoryListCell.self), for: indexPath) as! CategoryListCell
        cell.update(icon: UIImage(named: "badge_music"), title: "\(seriesList[indexPath.row].name)")
        cell.deleteHandler = { [weak self] in
            guard let self = self else { return }
            self.deleteItem(atIndexPath: indexPath)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        true
    }

    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        seriesList.swapAt(sourceIndexPath.item, destinationIndexPath.item)
    }

    func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return true
    }
}

extension CategoryListController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if longPress.isEqual(gestureRecognizer) {
            return true
        }
        return false
    }

    @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            let point = gesture.location(in: collectionView)
            guard let indexPath = collectionView.indexPathForItem(at: point) else { return }
            guard collectionView(collectionView, canMoveItemAt: indexPath) else { return }
            guard let cell = collectionView.cellForItem(at: indexPath) else { return }
            selectedCell = cell
            UIView.animate(withDuration: 0.2) {
                cell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }
            collectionView.beginInteractiveMovementForItem(at: indexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
        case .ended:
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                guard let self = self else { return }
                self.selectedCell?.transform = .identity
            }) { [weak self] _ in
                guard let self = self else { return }
                self.selectedCell = nil
            }
            collectionView.endInteractiveMovement()
        default:
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                guard let self = self else { return }
                self.selectedCell?.transform = .identity
            }) { [weak self] _ in
                guard let self = self else { return }
                self.selectedCell = nil
            }
            collectionView.cancelInteractiveMovement()
        }
    }
}
