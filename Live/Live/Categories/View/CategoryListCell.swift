//
//  CategoryListCell.swift
//  Live
//
//  Created by Beryter on 2019/8/26.
//  Copyright © 2019 Beryter. All rights reserved.
//

import UIKit

class CategoryListCell: UICollectionViewCell {
    
    var deleteHandler: (() -> Void)?
    
    private let panGesture = UIPanGestureRecognizer()
    private let tapGesture = UITapGestureRecognizer()
    private var isEditing = false
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        frame = CGRect(origin: .zero, size: CGSize(width: Constants.screenWidth - 36, height: 72))
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.2
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(deleteButton)

        panGesture.addTarget(self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self
        addGestureRecognizer(panGesture)

        tapGesture.addTarget(self, action: #selector(handleTapGesture(_:)))
        tapGesture.delegate = self
        addGestureRecognizer(tapGesture)
    }

    func update(icon: UIImage?, title: String) {
        iconView.image = icon
        titleLabel.text = title
    }

    @objc private func didClickedDeleteButton(_ sender: UIButton) {
        handleTapGesture(tapGesture)
        if let bk = deleteHandler { bk() }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let v = deleteButton.hitTest(deleteButton.convert(point, from: self), with: event)
        if v == nil  {
            return super.hitTest(point, with: event)
        }
        return v
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if super.point(inside: point, with: event) { return true }
        return !deleteButton.isHidden && deleteButton.point(inside: deleteButton.convert(point, from: self), with: event)
    }
    
    // MARK: - view

    lazy var iconView: UIImageView = {
        let iv = UIImageView()
        iv.bounds = CGRect(origin: .zero, size: CGSize(width: 30, height: 30))
        iv.by_left = 20
        iv.by_centerY = self.by_height / 2
        iv.contentMode = .center
        return iv
    }()

    lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.frame = CGRect(x: iconView.by_right, y: 0, width: self.by_width - iconView.by_right, height: self.by_height)
        lb.textAlignment = .center
        lb.textColor = .black
        lb.font = UIFont.systemFont(ofSize: 17)
        return lb
    }()

    lazy var deleteButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "icon_delete"), for: .normal)
        btn.contentMode = .scaleToFill
        btn.by_size = CGSize(width: 30, height: 30)
        btn.by_left = self.by_width + 18
        btn.by_centerY = self.by_height / 2
        btn.addTarget(self, action: #selector(didClickedDeleteButton(_:)), for: .touchUpInside)
        return btn
    }()
}

extension CategoryListCell: UIGestureRecognizerDelegate {
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        guard isEditing else { return }
        isEditing = false
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.transform = .identity
        }
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            let vx = gesture.velocity(in: gesture.view).x
            let vy = gesture.velocity(in: gesture.view).y
            let directVectory = -vx / sqrt(pow(vx, 2) + pow(vy, 2))
            if directVectory >= 0.8 {
                beginEdit()
            } else if directVectory <= -0.8 {
                handleTapGesture(tapGesture)
            }
        default:
            break
        }
    }

    private func beginEdit() {
        if isEditing { return }
        isEditing = true
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.transform = CGAffineTransform(translationX: -48, y: 0)
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if panGesture.isEqual(gestureRecognizer) {
            let vx = panGesture.velocity(in: panGesture.view).x
            let vy = panGesture.velocity(in: panGesture.view).y
            return abs((-vx) / sqrt(pow(vx, 2) + pow(vy, 2))) < 0.8
        }
        if tapGesture.isEqual(gestureRecognizer) {
            return !isEditing
        }
        return false
    }

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if panGesture.isEqual(gestureRecognizer) {
            let vx = panGesture.velocity(in: panGesture.view).x
            let vy = panGesture.velocity(in: panGesture.view).y
            return abs((-vx) / sqrt(pow(vx, 2) + pow(vy, 2))) >= 0.8
        }

        if tapGesture.isEqual(gestureRecognizer) {
            return isEditing
        }
        return true
    }
}
