//
//  PQPresentationController.swift
//  PQTransition
//
//  Created by 盘国权 on 2019/6/10.
//  Copyright © 2019 pgq. All rights reserved.
//

import UIKit

open class PQPresentationController: UIPresentationController {

    open var presentFrame: CGRect
    open var duration: TimeInterval
    /// 遮罩透明度
    open var overlayAlpha: CGFloat = 0.3 {
        didSet {
            overlay.alpha = overlayAlpha
        }
    }
    /// 遮罩颜色
    open var overlayColor: UIColor = UIColor(white: 0, alpha: 0.3) {
        didSet {
            overlay.backgroundColor = overlayColor
        }
    }
    /// 触摸空白区域dismiss界面
    open var touchOverlayDismiss: Bool = true
    
    public init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, presentFrame: CGRect, duration: TimeInterval) {
        self.presentFrame = presentFrame
        self.duration = duration
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    open override func containerViewWillLayoutSubviews() {
        presentedView?.frame = presentFrame
        containerView?.insertSubview(overlay, at: 0)
        UIView.animate(withDuration: 0.25) {
            self.overlay.alpha = 1
        }
    }
    
    private lazy var overlay: UIView = {
        let v = UIView(frame: UIScreen.main.bounds)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        v.addGestureRecognizer(tap)
        v.alpha = 0
        return v
    }()
}

private extension PQPresentationController {
    @objc func dismissController() {
        if touchOverlayDismiss {        
            presentedViewController.dismiss(animated: true, completion: nil)
        }
    }
}
