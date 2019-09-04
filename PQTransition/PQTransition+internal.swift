//
//  PQTransition+internal.swift
//  PQTransition
//
//  Created by 盘国权 on 2019/6/10.
//  Copyright © 2019 pgq. All rights reserved.
//

import Foundation

let kScreenW = UIScreen.main.bounds.width
let kScreenH = UIScreen.main.bounds.height

extension PQTransition: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        willShowClosure?()
        isPresent = true
        return self
    }
    
    
 
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        willDismissClosure?()
        isPresent = false
        return self
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let controller = PQPresentationController(presentedViewController: presented, presenting: presenting, presentFrame: presentFrame, duration: duration)
        controller.overlayAlpha = overlayAlpha
        controller.overlayColor = overlayColor
        controller.touchOverlayDismiss = touchOverlayDismiss
        return controller 
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch type {
        case .popverSpring:
            popverSpring(using: transitionContext)
        case .topPush,.bottomPush,
             .leftPush,.rightPush:
            push(using: transitionContext)
        case .fromFrame(let beginFrame):
            fromFrame(using: transitionContext, beginFrame: beginFrame)
        case .fromFrame2(let beginFrame):
            fromFrame2(using: transitionContext, beginFrame: beginFrame)
        case .circleOverlay(let beginFrame):
            cirlceOverlay(using: transitionContext, beginFrame: beginFrame)
        case .cutHorizontal,
             .cutVeritical:
            cut(using: transitionContext)
        case .transFromH:
            transFromH(using: transitionContext)
        }
    }
    
    
}

// MARK: - All animations
private extension PQTransition {
    
    
    func popverSpring(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresent { // show
            let toView = transitionContext.view(forKey: .to)!
            
            transitionContext.containerView.addSubview(toView)
            toView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            show(animations: {
                toView.transform = .identity
            }) { (finished) in
                transitionContext.completeTransition(true)
                self.didShowClosure?()
            }
        } else { // dismiss
            let fromView = transitionContext.viewController(forKey: .from)!.view
            
            let sc = fromView!.snapshotView(afterScreenUpdates: false)!
            sc.center = fromView!.center
            fromView?.removeFromSuperview()
            transitionContext.containerView.addSubview(sc)
            dimsiss(animations: {
                sc.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                sc.alpha = 0.0001
                transitionContext.containerView
                    .subviews.first?.alpha = 0.0001
            }) { (finished) in
                sc.removeFromSuperview()
                transitionContext.completeTransition(true)
                self.didDismissClosure?()
            }
        }
    }
    
    func push(using transitionContext: UIViewControllerContextTransitioning) {
        var transfrom = CGAffineTransform(translationX: 0, y: -kScreenH)
        if type == .bottomPush {
            transfrom = CGAffineTransform(translationX: 0, y: kScreenH)
        }
        if type == .leftPush {
            transfrom = CGAffineTransform(translationX: -kScreenW, y: 0)
        }
        
        if type == .rightPush {
            transfrom = CGAffineTransform(translationX: kScreenW, y: 0)
        }
        
        if isPresent {
            let toView = transitionContext.view(forKey: .to)!
            
            transitionContext.containerView.addSubview(toView)
            toView.transform = transfrom
            show(animations: {
                toView.transform = .identity
            }) { (finished) in
                transitionContext.completeTransition(true)
                self.didShowClosure?()
            }
        } else {
            let fromView = transitionContext.viewController(forKey: .from)!.view
            
            let sc = fromView!.snapshotView(afterScreenUpdates: false)!
            sc.center = fromView!.center
            fromView?.removeFromSuperview()
            transitionContext.containerView.addSubview(sc)
            dimsiss(animations: {
                sc.transform = transfrom
                sc.alpha = 0.0001
                transitionContext.containerView
                    .subviews.first?.alpha = 0.0001
            }) { (finished) in
                sc.removeFromSuperview()
                transitionContext.completeTransition(true)
                self.didDismissClosure?()
            }
        }
    }
    
    func fromFrame(using transitionContext: UIViewControllerContextTransitioning, beginFrame: CGRect) {
        if isPresent {
            let toView = transitionContext.view(forKey: .to)!
            
            transitionContext.containerView.addSubview(toView)
            toView.frame = beginFrame
            show(animations: {
                toView.frame = self.presentFrame
            }) { (finished) in
                transitionContext.completeTransition(true)
                self.didShowClosure?()
            }
        } else {
            let fromView = transitionContext.viewController(forKey: .from)!.view
            
            let sc = fromView!.snapshotView(afterScreenUpdates: false)!
            sc.center = fromView!.center
            fromView?.removeFromSuperview()
            transitionContext.containerView.addSubview(sc)
            dimsiss(animations: {
                sc.frame = beginFrame
                sc.alpha = 0.0001
                transitionContext.containerView
                    .subviews.first?.alpha = 0.0001
            }) { (finished) in
                sc.removeFromSuperview()
                transitionContext.completeTransition(true)
                self.didDismissClosure?()
            }
            
        }
    }
    
    func fromFrame2(using transitionContext: UIViewControllerContextTransitioning, beginFrame: CGRect) {
        if isPresent {
            let toView = transitionContext.view(forKey: .to)!
            
            transitionContext.containerView.addSubview(toView)
            toView.frame = beginFrame
            show(animations: {
                var frame = toView.frame
                frame.origin.x = self.presentFrame.origin.x
                frame.origin.y = self.presentFrame.origin.y
                toView.frame = frame
            }) { (finished) in
                
            }
            show(delay: duration, animations: {
                toView.frame = self.presentFrame;
            }) { (finished) in
                transitionContext.completeTransition(true)
                self.didShowClosure?()
            }
        } else {
            let fromView = transitionContext.viewController(forKey: .from)!.view
            
            let sc = fromView!.snapshotView(afterScreenUpdates: false)!
            sc.center = fromView!.center
            fromView?.removeFromSuperview()
            transitionContext.containerView.addSubview(sc)
            dimsiss(animations: {
                var frame = self.presentFrame
                frame.size.width = beginFrame.width
                frame.size.height = beginFrame.height
                sc.frame = frame
                sc.alpha = 0.0001
                sc.layer.cornerRadius = fromView!.layer.cornerRadius
                sc.clipsToBounds = fromView!.clipsToBounds
                
            }) { (_) in
            }
            
            dimsiss(delay: duration * 0.8, animations: {
                sc.frame = beginFrame
                sc.alpha = 0.0001
                transitionContext.containerView
                    .subviews.first?.alpha = 0.0001
            }) { (finished) in
                sc.removeFromSuperview()
                transitionContext.completeTransition(true)
                self.didDismissClosure?()
            }
            
        }
    }
    
    func cirlceOverlay(using transitionContext: UIViewControllerContextTransitioning, beginFrame: CGRect) {
        var animationView = UIView()
        
        if isPresent {
            let toView = transitionContext.view(forKey: .to)!
            
            transitionContext.containerView.addSubview(toView)
            animationView = toView
        } else {
            let fromView = transitionContext.viewController(forKey: .from)!.view
            
            let sc = fromView!.snapshotView(afterScreenUpdates: false)!
            sc.center = fromView!.center
            fromView?.removeFromSuperview()
            transitionContext.containerView.addSubview(sc)
            animationView = fromView!
        }
        
        /// 创建动画
        let shapeLayer = CAShapeLayer()
        animationView.layer.mask = shapeLayer
        
        let path1 = UIBezierPath(ovalIn: beginFrame)
        let path2 = UIBezierPath(arcCenter: beginFrame.origin, radius: kScreenH * 1.2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        
        shapeLayer.path = path2.cgPath
        var animation = addAnimationFrom(fromValue: path1.cgPath, toValue: path2.cgPath, transitionContext: transitionContext)
        if !isPresent {
            animation = addAnimationFrom(fromValue: path2.cgPath, toValue: path1.cgPath, transitionContext: transitionContext)
            show(animations: {
                animationView.alpha = 0.0001
                transitionContext .containerView.subviews.first?.alpha = 0.001
            }) { (finished) in
                animationView.removeFromSuperview()
            }
        }
        
        shapeLayer.add(animation, forKey: "presentAnimation")
        
    }
    func addAnimationFrom(fromValue: Any?, toValue: Any?, transitionContext: UIViewControllerContextTransitioning) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = duration
        animation.timingFunction = .init(name: .easeInEaseOut)
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.setValue(transitionContext, forKey: "transitionContext")
        return animation
    }
    
    func cut(using transitionContext: UIViewControllerContextTransitioning) {
        var view1 = UIView()
        var view2 = UIView()
        
        var transfrom1 = CGAffineTransform.identity
        var transfrom2 = CGAffineTransform.identity
        
        let toView = transitionContext.view(forKey: .to)
        let fromView = transitionContext.viewController(forKey: .from)?.view
        
        if isPresent {
            transitionContext.containerView.addSubview(toView!)
        }
        
        let cutView = transitionContext.containerView
        
        if type == .cutVeritical {
            view1 = UIImageView(image: cutView.cut(size: CGSize(width: kScreenW, height: kScreenH), cutFrame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH * 0.5)))
            view2 = UIImageView(image: cutView.cut(size: CGSize(width: kScreenW, height: kScreenH), cutFrame: CGRect(x: 0, y: kScreenH * 0.5, width: kScreenW, height: kScreenH * 0.5)))
            var frame = view2.frame
            frame.origin.y = kScreenH * 0.5
            view2.frame = frame
        } else {
            view1 = UIImageView(image: cutView.cut(size: CGSize(width: kScreenW, height: kScreenH), cutFrame: CGRect(x: 0, y: 0, width: kScreenW * 0.5, height: kScreenH)))
            view2 = UIImageView(image: cutView.cut(size: CGSize(width: kScreenW, height: kScreenH), cutFrame: CGRect(x: kScreenW * 0.5, y: 0, width: kScreenW * 0.5, height: kScreenH)))
            var frame = view2.frame
            frame.origin.x = kScreenW * 0.5
            view2.frame = frame
        }
        
        cutView.addSubview(view1)
        cutView.addSubview(view2)
        
        if isPresent {
            if type == .cutVeritical {
                transfrom1 = CGAffineTransform(translationX: 0, y: -kScreenH)
                transfrom2 = CGAffineTransform(translationX: 0, y: kScreenH * 1.5)
            } else {
                transfrom1 = CGAffineTransform(translationX: -kScreenW, y: 0)
                transfrom2 = CGAffineTransform(translationX: kScreenW * 1.5, y: 0)
            }
            
            view1.transform = transfrom1
            view2.transform = transfrom2
            
        }
        
        transitionContext.containerView.subviews.first?.alpha = 0
        toView?.alpha = 0
        
        if !isPresent {
            fromView?.alpha = 0
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: {
            if self.isPresent {
                view1.transform = .identity
                view2.transform = .identity
            } else {
                if self.type == .cutVeritical {
                    view1.transform = CGAffineTransform(translationX: 0, y: -kScreenH)
                    view2.transform = CGAffineTransform(translationX: 0, y: kScreenH)
                } else {
                    view1.transform = CGAffineTransform(translationX: -kScreenW, y: 0)
                    view2.transform = CGAffineTransform(translationX: kScreenW, y: 0)
                }
                transitionContext.containerView.subviews.first?.alpha = 0
            }
        }) { (_) in
            self.didShowClosure?()
        }
        
        
        UIView.animate(withDuration: 0.001, delay: self.duration, options: .curveLinear, animations: {
            view1.alpha = 0.0001
            view2.alpha = 0.0001
            if self.isPresent {
                transitionContext.containerView.subviews.first?.alpha = 1
                toView?.alpha = 1
            }
        }) { (finished) in
            transitionContext.completeTransition(true)
            if !self.isPresent {
                view1.removeFromSuperview()
                view2.removeFromSuperview()
            }
        }
    }
    
    func transFromH(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresent {
            let toView = transitionContext.view(forKey: .to)!
            transitionContext.containerView.addSubview(toView)
            toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            toView.transform = CGAffineTransform(scaleX: 1, y: 0)
            show(animations: {
                toView.transform = .identity
            }) { (_) in
                transitionContext.completeTransition(true)
                self.didShowClosure?()
            }
        } else {
            let fromView = transitionContext.viewController(forKey: .from)!.view
            dimsiss(animations: {
                fromView?.transform = CGAffineTransform(scaleX: 1, y: 0.00001)
            }) { (finished) in
                transitionContext.completeTransition(true)
                self.didDismissClosure?()
            }
        }
    }
    
    func show(delay: TimeInterval = 0, animations: @escaping () -> (), completion: @escaping (Bool) -> ()) {
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveLinear, animations: animations, completion: completion)
    }
    
    func dimsiss(delay: TimeInterval = 0, animations: @escaping () -> (), completion: @escaping (Bool) -> ()) {
        UIView.animate(withDuration: duration * 0.8, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveLinear, animations: animations, completion: completion)
    }
}

extension PQTransition: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let transitionContext = anim.value(forKey: "transitionContext") as? UIViewControllerContextTransitioning else {
            return
        }
        transitionContext.completeTransition(true)
        transitionContext.viewController(forKey: .to)?.view.layer.mask = nil
        if isPresent {
            didShowClosure?()
        }else{
            didDismissClosure?()
        }
    }
}
