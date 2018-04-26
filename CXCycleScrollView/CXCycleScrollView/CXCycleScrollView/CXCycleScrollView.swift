//
//  CXCycleScrollView.swift
//  CXCycleScrollView
//
//  Created by ymh on 2018/4/18.
//  Copyright © 2018年 cangxue. All rights reserved.
//

import UIKit
import Kingfisher

// 屏幕宽高
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

class CXCycleScrollView: UIView {
    
    // 图片URL
    var imageData = [String]()
    
    // intervalTime
    var intervalTime = 2.0
    
    
    // scrollView
    var scrollView: UIScrollView!
    
    // imageView
    var leftImageView: UIImageView!
    var centerImageView: UIImageView!
    var rightImageView: UIImageView!
    
    var currentPage: Int = 0
    
    // timer
    var timer: Timer!
    
    class func buildCycleScrollView(frame: CGRect, imageUrls: [String]) -> CXCycleScrollView {
        let cycleView = CXCycleScrollView(frame: frame)
        
        cycleView.imageData = imageUrls
        
        return cycleView
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 创建scrollView
        setupScrollView()
        setupImageView()
        setupTimer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: === Event Response ===
    // 图片点击
    @objc func imageViewTap() {
        print("点击了\(currentPage)")
    }
    
    // 定时器 selector
    @objc func timerTick() {
        currentPage = currentPage + 1
        
        if currentPage == imageData.count {
            currentPage = 0
        }
        
        // 设置动画时间一定要小于滑动时间
        UIView.animate(withDuration: 1, animations: {
            // 动画发生时的滑动
            self.centerImageView.isUserInteractionEnabled = false
            self.scrollView.contentOffset = CGPoint(x: self.scrollView.frame.size.width*2, y: 0)
        }) { (finished) in
            // 滑动完成后，把当前现实的imageview重现移动回中间位置，此处不能使用动画，用户感觉不到
            // 移动前,先把中间imageview的image设置成当前现实的iamge
            self.centerImageView.isUserInteractionEnabled = true
            self.leftImageView.image = self.centerImageView.image
            self.centerImageView.image = self.rightImageView.image
            self.scrollView.contentOffset = CGPoint(x: self.scrollView.frame.size.width*1, y: 0)
            
            let imageUrl = self.getImageUrlAfterIndex(index: self.currentPage)
            
            let url = URL(string: imageUrl)
            self.rightImageView.kf.setImage(with: url)
        }
        
    }

    
    // MARK: === Private Method ===
    // 获取图片URL
    func getImageUrlBeforeIndex(index: Int) -> String {
        if index == 0 {
            return imageData.last!
        } else {
            return imageData[index-1]
        }
    }
    func getImageUrlAfterIndex(index: Int) -> String {
        if index == self.imageData.count - 1 {
            return imageData.first!
        } else {
            return imageData[index+1]
        }
    }
    func getImageUrlAtIndex(index: Int) -> String {
        if index < 0 || index >= imageData.count {
            return ""
        } else {
            return imageData[index]
        }
    }
    
}

// MARK: === ScrollView Delegate ===
extension CXCycleScrollView: UIScrollViewDelegate {
    // 开始拖动
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 手动拖动，则定时器停止
        timer.invalidate()
    }
    //结束拖动
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 用户停止拖动，重启定时器
        setupTimer()
    }
    
    // 滑动结束时减缓
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / scrollView.frame.size.width
        if index == 0 {
            // 向左滑动
            currentPage = currentPage - 1
            if currentPage < 0 {
                currentPage = imageData.count
            }
            
            rightImageView.image = centerImageView.image
            centerImageView.image = leftImageView.image
            
            scrollView.contentOffset = CGPoint(x: scrollView.frame.size.width, y: 0)
            
            let imageUrl = getImageUrlBeforeIndex(index: currentPage)
            
            let url = URL(string: imageUrl)
            leftImageView.kf.setImage(with: url)
            
        } else if index == 2 {
            // 向右滑动
            currentPage = currentPage + 1
            if currentPage == imageData.count {
                currentPage = 0
            }
            
            leftImageView.image = centerImageView.image
            centerImageView.image = rightImageView.image
            
            scrollView.contentOffset = CGPoint(x: scrollView.frame.size.width, y: 0)
            
            let imageUrl = getImageUrlAfterIndex(index: currentPage)
            
            let url = URL(string: imageUrl)
            rightImageView.kf.setImage(with: url)
            
        }
    }
}

// MARK: === Set Method ===
extension CXCycleScrollView  {
    // 设置scrollView
    func setupScrollView() {
        // 创建scrollView
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        
        // 设置滑动范围
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH*3, height: self.frame.size.height)
        
        // 设置指示器
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        // 设置分页效果
        scrollView.isPagingEnabled = true
        
        // 设置delegate
        scrollView.delegate = (self as UIScrollViewDelegate)
        
        // 添加视图
        self.addSubview(scrollView)
    }
    
    // 设置ImageView
    func setupImageView() {
        // leftImageView
        leftImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: self.frame.size.height))
        self.addSubview(leftImageView)
        
        // centerImageView
        centerImageView = UIImageView(frame: CGRect(x: SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH, height: self.frame.size.height))
        self.addSubview(centerImageView)
        
        // rightImageView
        rightImageView = UIImageView(frame: CGRect(x: SCREEN_WIDTH*2, y: 0, width: SCREEN_WIDTH, height: self.frame.size.height))
        self.addSubview(rightImageView)
        
        // 点击手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageViewTap))
        centerImageView.isUserInteractionEnabled = true
        centerImageView.addGestureRecognizer(tap)
    }
    
    // 设置定时器
    func setupTimer() {
        timer = Timer(timeInterval: intervalTime, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .commonModes)
    }
    
}
