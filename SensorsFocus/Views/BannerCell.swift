//
//  BannerCell.swift
//  SensorsFocus
//
//  Created by 彭远洋 on 2019/9/24.
//  Copyright © 2019 Sensors Data Inc. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

let isLoginId = "0"
let isActivitiyId = "1"

protocol BannerCellDelgate: NSObjectProtocol {
    func didSelectedBanner(_ itemId: String)
}

class BannerCell: UITableViewCell, UIScrollViewDelegate {

    weak var delegate: BannerCellDelgate?
    var pageControl: UIPageControl!
    var scrollView: UIScrollView!
    var timer: Timer!
    var placeholders = [UIImageView]()
    var currentPage = 0
    var images: [[String: String]] {
        var array = [["image": "banner2", "goodsId": "10010"], ["image": "banner3", "goodsId": "10011"]]
        if !receivedCoupon() {
            let item = ["image": "banner1", "goodsId": isActivitiyId]
            array.insert(item, at: 0)
        }
        if !isLogin() {
            let item = ["image": "banner0", "goodsId": isLoginId]
            array.insert(item, at: 0)
        }
        return array
    }

    let bannerWidth = kScreenWidth - 10 * 2

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.initScrollView()
        self.initBanners()
    }

    func initScrollView() {
        scrollView = UIScrollView.init()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.layer.masksToBounds = true
        scrollView.layer.cornerRadius = kCornerRadius
        let height = (kScreenWidth - 20) / 2.5
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(height)
        }
    }

    func initBanners() {
        var previous: UIImageView?
        for index in 0..<3 {
            let banner = UIImageView.init()
            banner.tag = index
            banner.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(bannerTap))
            banner.addGestureRecognizer(tap)
            scrollView.addSubview(banner)
            banner.snp.makeConstraints { (make) in
                if previous != nil {
                    make.leading.equalTo(previous!.snp_trailing)
                } else {
                    make.leading.equalToSuperview()
                }
                make.top.equalToSuperview()
                make.height.equalToSuperview()
                make.width.equalToSuperview()
                if index == 2 {
                    make.trailing.equalToSuperview()
                }
            }
            previous = banner
            placeholders.append(banner)
        }
        pageControl = SFPageControl.init()
        self.addSubview(pageControl!)
        pageControl.snp.makeConstraints({ (make) in
            make.bottom.equalToSuperview().offset(-5)
            make.centerX.equalToSuperview()
        })
        self.layoutIfNeeded()
        self.startTimer()
    }

    func startTimer() {
        self.updateLoopBanner(current: currentPage)
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(bannerLoop), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer, forMode: .common)
    }

    @objc func bannerTap() {
        let item = images[currentPage]
        delegate?.didSelectedBanner(item["goodsId"]!)
    }

    @objc func bannerLoop() {
        UIView.animate(withDuration: 0.5, animations: {
            self.scrollView.setContentOffset(CGPoint.init(x: self.bannerWidth * 2, y: 0), animated: false)
        })
        self.currentPage += 1
        self.updateLoopBanner(current: self.currentPage)

    }

    func updateLoopBanner(current page: Int) {
        let maxStep = images.count - 1
        currentPage = page < 0 ? maxStep : page
        currentPage = currentPage > maxStep ? 0 : currentPage
        for index in 0..<placeholders.count {
            var selected = index + currentPage - 1
            selected = selected > maxStep ? selected - maxStep - 1 : selected
            selected = selected < 0 ? maxStep : selected
            let banner = placeholders[index]
            banner.image = UIImage.init(named: images[selected]["image"]!)
        }
        pageControl.numberOfPages = images.count
        pageControl.currentPage = currentPage
        scrollView.setContentOffset(CGPoint.init(x: bannerWidth, y: 0), animated: false)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.invalidate()
        timer = nil
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        timer?.invalidate()
        timer = nil

        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(bannerLoop), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let left = scrollView.contentOffset.x == 0
        let right = scrollView.contentOffset.x == bannerWidth * 2
        if left {
            currentPage -= 1
        }
        if right {
            currentPage += 1
        }
        self.updateLoopBanner(current: currentPage)
    }
}
