//
//  ViewController.swift
//  CXCycleScrollView
//
//  Created by ymh on 2018/4/17.
//  Copyright © 2018年 cangxue. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
//    var cycleScrollViewe: CXCycleScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let imageurls = ["http://d.hiphotos.baidu.com/image/pic/item/b7fd5266d016092408d4a5d1dd0735fae7cd3402.jpg", "http://h.hiphotos.baidu.com/image/h%3D300/sign=2b3e022b262eb938f36d7cf2e56085fe/d0c8a786c9177f3e18d0fdc779cf3bc79e3d5617.jpg", "http://a.hiphotos.baidu.com/image/pic/item/b7fd5266d01609240bcda2d1dd0735fae7cd340b.jpg", "http://h.hiphotos.baidu.com/image/pic/item/728da9773912b31b57a6e01f8c18367adab4e13a.jpg", "http://h.hiphotos.baidu.com/image/pic/item/0d338744ebf81a4c5e4fed03de2a6059242da6fe.jpg"]
    
        let cycleScrollView = CXCycleScrollView.buildCycleScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 200), imageUrls: imageurls)
        
        self.view.addSubview(cycleScrollView)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

