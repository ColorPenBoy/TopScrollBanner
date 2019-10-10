//
//  BZLoopView.swift
//  BannerLoopAnimationSwift
//
//  Created by colorPen on 15/10/13.
//  Copyright © 2015年 Bobi. All rights reserved.
//

import UIKit



class BZLoopView: UIView {
    
    private var imageView : UIImageView?
    
    private var currentIndex : Int! = 0
    
    private var imgArray : Array<UIImageView>?
    
    private var imgCount : Int?
    
    private var timer : Timer?
    
    private var oneClick : ((_ currentIndex:Int)->Void)!
    
    func loadImageArray(imageArray: Array<UIImageView>, oneClick:@escaping (_ currentIndex:Int) -> Void){
        
        self.oneClick = oneClick
        
        self.imgArray = NSArray(array:imageArray) as? Array<UIImageView>
        
        self.imgCount = imageArray.count
        
        //定义图片控件
        let imageUU:UIImageView = imageArray[0]
        
        self.imageView = UIImageView.init(frame: self.bounds)
        
        self.imageView!.image = imageUU.image!
        
        self.addSubview(self.imageView!)
        
        self.loadLoopImageGestureRecognizer()

        self.loadLoopImageTimer()
    }

    private func loadLoopImageTimer(){
        
        self.timer = Timer.scheduledTimer(timeInterval: 3.0,
                                          target: self, selector:#selector(BZLoopView.leftSwipe(gesture:)) ,
                                          userInfo: nil,
                                          repeats: true)
        
        RunLoop.current.add(self.timer!, forMode: RunLoop.Mode.tracking)
    }
    
    
    private func loadLoopImageGestureRecognizer(){
        
        //添加左滑手势
        let leftSwipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(BZLoopView.leftSwipe(gesture:)))
        
        leftSwipeGesture.direction = UISwipeGestureRecognizer.Direction.left
        
        self.addGestureRecognizer(leftSwipeGesture)

        //添加右滑手势
        let rightSwipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(BZLoopView.rightSwipe(gesture:)))
        
        rightSwipeGesture.direction = UISwipeGestureRecognizer.Direction.right
        
        self.addGestureRecognizer(rightSwipeGesture)
        
        //添加单击手势
        let titleImgTapRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(BZLoopView.BannerImageClick(gesture:)))
        
        self.addGestureRecognizer(titleImgTapRecognizer)
    }
    
    @objc func leftSwipe(gesture : UISwipeGestureRecognizer){
        self.transitionAnimation(isNext: true)
    }

    @objc func rightSwipe(gesture : UISwipeGestureRecognizer){
        self.transitionAnimation(isNext: false)
    }
    
    @objc func BannerImageClick(gesture : UITapGestureRecognizer){
        self.oneClick(self.currentIndex)
    }
    
    private func transitionAnimation(isNext : Bool){
        
        //1.创建转场动画对象
        let transition:CATransition = CATransition.init()
        
        transition.type = CATransitionType.init(rawValue: "cube")
        
        transition.subtype = isNext ? CATransitionSubtype(rawValue: "fromRight") : CATransitionSubtype(rawValue: "fromLeft")
        
        transition.duration = 0.5
        
        transition.delegate = self as CAAnimationDelegate
        
        //2.设置转场后的新视图添加转场动画
        self.imageView!.image = self.getImage(isNext: isNext);
        
        self.imageView!.layer.add(transition, forKey:"KCTransitionAnimation")
    }
    
    private func getImage(isNext : Bool) -> UIImage{
        
        if isNext {
            self.currentIndex = (self.currentIndex + 1) % self.imgCount!
        } else {
            self.currentIndex = (self.currentIndex - 1 + self.imgCount!) % self.imgCount!
        }
        
        let imageUU: UIImageView =  self.imgArray![self.currentIndex!]
        
        return imageUU.image!
    }
    
}

extension BZLoopView : CAAnimationDelegate {
    
    func animationDidStart(_ anim: CAAnimation) {
        self.isUserInteractionEnabled = false
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.isUserInteractionEnabled = true
    }
}
