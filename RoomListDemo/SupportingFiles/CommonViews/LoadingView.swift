//
//  LoadingView.swift
//  RoomListDemo
//
//  Created by mac on 16/05/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import Foundation
import UIKit

class LoadingView: UIView {
    fileprivate var timer: Timer?
    fileprivate var animateViews = [UIView]()
    
    
    var animateBarCornerRadius:CGFloat = 2
    fileprivate var animating : Bool = false
    fileprivate var yAnimation : CAKeyframeAnimation?
    fileprivate var xAnimation : CAKeyframeAnimation?
    var hidesWhenStopped : Bool = false
    var animater =  UIDynamicAnimator()
    
    func startAnimation() {
        addAnimation()
    }
    func stopAnimation() {
        removeAnimation()
    }
}

extension LoadingView {
    
    fileprivate func addAnimation() {
        
        // 1: Set LoaderView properties
        DispatchQueue.main.async {
            self.backgroundColor = UIColor.clear
            self.clipsToBounds = true
            self.animating = true
            
            let blurEffectView = UIVisualEffectView(effect: nil)
            blurEffectView.frame = BOUNDS
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.backgroundColor = UIColor.clear

            let logo  = UIImageView.init(frame: CGRect.init(x: SCREEN_WIDTH/2-25, y: SCREEN_HEIGHT/2-25, width: 50, height: 50))
            logo.layer.masksToBounds = true
            logo.layer.cornerRadius = 8
            logo.image = UIImage.init(named: "room")
            blurEffectView.contentView.addSubview(logo)
            
            self.animater = UIDynamicAnimator(referenceView: blurEffectView)
            let gravityBehavior = UIGravityBehavior(items: [logo])
            
            self.animater.addBehavior(gravityBehavior )
            let collisionBehavior = UICollisionBehavior(items: [logo])
            collisionBehavior.setTranslatesReferenceBoundsIntoBoundary(with: UIEdgeInsets.init(top: 0, left: 0, bottom: SCREEN_HEIGHT/2-25, right: 0))
            
            self.animater.addBehavior(collisionBehavior )
            let elasticityBehavior = UIDynamicItemBehavior(items: [logo])
            elasticityBehavior.allowsRotation = true
            elasticityBehavior.elasticity = 0.7
            self.animater.addBehavior(elasticityBehavior )


            let rotations = 1.0
            let duration = 5.0
            // 360 degree
//            var rotationAnimation: CABasicAnimation?
//            rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
//            rotationAnimation?.toValue = .pi * 2.0 * rotations * duration
//            rotationAnimation?.duration = duration
//            rotationAnimation?.isCumulative = true
//            rotationAnimation?.repeatCount = Float(APP_MAX_INT)
//            self.imageView?.layer.add(rotationAnimation!, forKey: "rotationAnimation")

            //Flip
            let rotationAnimation = CABasicAnimation.init(keyPath: "transform.rotation.y")
            rotationAnimation.toValue = NSNumber.init(value: Double.pi * 2.0 * rotations * duration)
            rotationAnimation.duration = duration
            rotationAnimation.isCumulative = true
            rotationAnimation.repeatCount = Float(INT_MAX)
            logo.layer.add(rotationAnimation, forKey: "rotationAnimation")
            APP_KEY_WINDOW?.addSubview(blurEffectView)
  
        }
    }
    
    func isAnimating() -> Bool {
        return self.animating
    }
    
    fileprivate func removeAnimation() {
        
        if !self.isAnimating() {
            return
        }
        
        DispatchQueue.main.async {
            self.animating = false

            _ = APP_KEY_WINDOW?.subviews.map {
                if let blurEffectView = $0 as? UIVisualEffectView{
                    _ = blurEffectView.subviews.map({ $0.removeFromSuperview() })
                    $0.removeFromSuperview()
                }
            }

            for view in (APP_KEY_WINDOW?.subviews)! {
                if view.tag == LOADING_IMAGE_TAG {
                    view.removeFromSuperview()
                } else if view.tag == LOADING_VIEW_TAG {
                    view.removeFromSuperview()
                }
            }
             self.layer.isHidden = self.hidesWhenStopped
            self.layer.removeAllAnimations()
            self.isHidden = true
        }
     }
   
}

