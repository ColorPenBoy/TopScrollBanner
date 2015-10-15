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
    
    private var timer : NSTimer?
    
    private var oneClick : ((currentIndex:Int)->Void)!
    
    func loadImageArray(imageArray: Array<UIImageView>, oneClick:(currentIndex:Int) -> Void){
        
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
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "leftSwipe:" , userInfo: nil, repeats: true)
        
        NSRunLoop.currentRunLoop().addTimer(self.timer!, forMode: UITrackingRunLoopMode)
    }
    
    
    private func loadLoopImageGestureRecognizer(){
        
        //添加左滑手势
        let leftSwipeGesture = UISwipeGestureRecognizer.init(target: self, action: "leftSwipe:")
        
        leftSwipeGesture.direction = UISwipeGestureRecognizerDirection.Left
        
        self.addGestureRecognizer(leftSwipeGesture)

        //添加右滑手势
        let rightSwipeGesture = UISwipeGestureRecognizer.init(target: self, action: "rightSwipe:")
        
        rightSwipeGesture.direction = UISwipeGestureRecognizerDirection.Right
        
        self.addGestureRecognizer(rightSwipeGesture)
        
        //添加单击手势
        let titleImgTapRecognizer = UITapGestureRecognizer.init(target: self, action: "BannerImageClick:")
        
        self.addGestureRecognizer(titleImgTapRecognizer)
    }
    
    func leftSwipe(gesture : UISwipeGestureRecognizer){
        self.transitionAnimation(true)
    }

    func rightSwipe(gesture : UISwipeGestureRecognizer){
        self.transitionAnimation(false)
    }
    
    func BannerImageClick(gesture : UITapGestureRecognizer){
        self.oneClick(currentIndex: self.currentIndex)
    }
    
    private func transitionAnimation(isNext : Bool){
        
        //1.创建转场动画对象
        let transition:CATransition = CATransition.init()
        
        transition.type = "cube"
        
        transition.subtype = isNext ? kCATransitionFromRight : kCATransitionFromLeft
        
        transition.duration = 0.5
        
        transition.delegate = self
        
        //2.设置转场后的新视图添加转场动画
        self.imageView!.image = self.getImage(isNext);
        
        self.imageView!.layer.addAnimation(transition, forKey:"KCTransitionAnimation")
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
    
    override  func animationDidStart(anim: CAAnimation) {
        self.userInteractionEnabled = false
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        self.userInteractionEnabled = true
    }
}
