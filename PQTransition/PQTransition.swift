//
//  PQTransition.swift
//  PQTransition
//
//  Created by 盘国权 on 2019/6/10.
//  Copyright © 2019 pgq. All rights reserved.
//

import Foundation

public enum PQTransitionAnimationType: Equatable {
    ///从中间弹出来
    case popverSpring
    ///上 → 下
    case topPush
    ///下 → 上
    case bottomPush
    ///左 → 右
    case leftPush
    ///右 → 左
    case rightPush
    ///从某个位置开始动画
    case fromFrame(beginFrame: CGRect)
    ///从某个位置开始 移动到指定的位置，再放大
    case fromFrame2(beginFrame: CGRect)
    ///从当前位置开始圆形扩展
    case circleOverlay(beginFrame: CGRect)
    ///水平方向合并
    case cutHorizontal
    ///垂直方向合并
    case cutVeritical
    ///高度从0 - 100% 100% - 0
    case transFromH
}

open class PQTransition: NSObject {
    /// closure
    public typealias PQTransitionClosure = () -> ()
    
    /// 动画类型
    open var type: PQTransitionAnimationType
    /// 显示大小位置
    open var presentFrame: CGRect
    /// 动画时长
    open var duration: TimeInterval
    /// 遮罩透明度
    open var overlayAlpha: CGFloat
    /// 遮罩颜色
    open var overlayColor: UIColor
    /// 触摸空白区域dismiss界面
    open var touchOverlayDismiss: Bool
    
    open var isPresent: Bool = false
    
    /// 快速创建动画对象
    ///
    /// - Parameters:
    ///   - type: 动画类型
    ///   - presentFrame: 显示大小
    ///   - duration: 动画时长 默认 0.5s
    ///   - overlayAlpha: 遮罩透明度，默认0.8
    ///   - overlayColor: 遮罩颜色，默认黑色
    ///   - touchOverlayDismiss: 触摸空白区域消失界面，默认true
    public init(type: PQTransitionAnimationType,
         presentFrame: CGRect,
         duration: TimeInterval = 0.5,
         overlayAlpha: CGFloat = 0.3,
         overlayColor: UIColor = UIColor(white: 0, alpha: 0.3),
         touchOverlayDismiss: Bool = true) {
        self.type = type
        self.presentFrame = presentFrame
        self.duration = duration
        self.overlayAlpha = overlayAlpha
        self.overlayColor = overlayColor
        self.touchOverlayDismiss = touchOverlayDismiss
    }
    
    // MARK: - private property
    internal var willShowClosure: PQTransitionClosure?
    internal var didShowClosure: PQTransitionClosure?
    internal var willDismissClosure: PQTransitionClosure?
    internal var didDismissClosure: PQTransitionClosure?
}

public extension PQTransition {
    func willShow(closure: PQTransitionClosure?) {
        willShowClosure = closure
    }
    
    func didShow(closure: PQTransitionClosure?) {
        didShowClosure = closure
    }
    
    func willDismiss(closure: PQTransitionClosure?) {
        willDismissClosure = closure
    }
    
    func didDismiss(closure: PQTransitionClosure?) {
        didDismissClosure = closure
    }
}
