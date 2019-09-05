//
//  MeController.swift
//  Live
//
//  Created by Beryter on 2019/8/27.
//  Copyright © 2019 Beryter. All rights reserved.
//

import UIKit

class MeController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.title = "我的"
        view.addSubview(tableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.by_height = Constants.screenHeight - (tabBarController?.tabBar.by_height ?? 0)
    }

    // MARK: - view

    private lazy var tableView: UITableView = {
        let tb = UITableView(frame: CGRect(origin: .zero, size: CGSize(width: Constants.screenWidth, height: Constants.screenHeight)), style: .plain)
        tb.backgroundColor = view.backgroundColor
        tb.separatorStyle = .none
        tb.register(MeCell.self, forCellReuseIdentifier: String(describing: MeCell.self))
        tb.delegate = self
        tb.dataSource = self
        tb.tableHeaderView = header
        if #available(iOS 11.0, *) {
            tb.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        let footer = UIView(frame: CGRect(origin: .zero, size: CGSize(width: view.by_width, height: 20)))
        tb.tableFooterView = footer
        return tb
    }()

    lazy var header: MeHeader = {
        let hdh = view.by_width * 9 / 16 + 60
        let hd = MeHeader(frame: CGRect(x: 0, y: 0, width: view.by_width, height: hdh))
        return hd
    }()
}

extension MeController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            let vc = MyCollectionController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        header.updateDisplayOffsetYChanged(offsetY)
    }
}

extension MeController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cl = tableView.dequeueReusableCell(withIdentifier: String(describing: MeCell.self), for: indexPath)
        return cl
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cl = cell as! MeCell
        if indexPath.row == 0 {
            cl.update(title: "收藏")
        } else if indexPath.row == 1 {
            cl.update(title: "关于")
        }
    }
}
