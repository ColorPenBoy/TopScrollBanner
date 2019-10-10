//
//  ViewController.swift
//  BannerLoopAnimationSwift
//
//  Created by colorPen on 15/10/13.
//  Copyright © 2015年 Bobi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var dataArray:[UIImageView] = []
        
        for i in 0..<5 {
            
            let imageName:String = "\(i)" + ".jpg"

            let imageUU : UIImageView = UIImageView.init(image: UIImage.init(named: imageName))
        
            dataArray.append(imageUU)
        }
        
        let bzloop : BZLoopView = BZLoopView()
        
        bzloop.frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: 200)
        
        bzloop.loadImageArray(imageArray: dataArray) { (currentIndex) -> Void in
            print("第\(currentIndex)张图")
        }
        self.view.addSubview(bzloop)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

