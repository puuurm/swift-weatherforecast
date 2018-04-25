//
//  SettingTransitionManager.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 4. 26..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class SettingTransitionManager: UIViewController {

    private var duration: TimeInterval = 0.7
    private var settingWidth: CGFloat = UIScreen.main.bounds.width * 0.6
    private var snapShotTag: Int = 999
    private var modalStatus: Status = .present

    private enum Status {
        case present
        case dismiss
    }

    func presentSetting(
        settingView: UIView,
        otherView: UIView,
        containerView: UIView,
        duration: TimeInterval,
        didTransitionComplete: Bool,
        completion: @escaping () -> Void) {
        containerView.insertSubview(settingView, belowSubview: otherView)
        if let snapShot = otherView.snapshotView(afterScreenUpdates: false) {
            snapShot.tag = snapShotTag
            snapShot.isUserInteractionEnabled = false
            containerView.insertSubview(snapShot, aboveSubview: settingView)
            otherView.isHidden = true
            UIView.animate(
                withDuration: duration,
                animations: { [weak self] in
                    guard let `self` = self else { return }
                    snapShot.frame.origin.x = self.settingWidth
                }
            ) { _ in
                otherView.isHidden = false
                completion()
            }
        }
    }

    func dismissSetting(
        settingView: UIView,
        otherView: UIView,
        containerView: UIView,
        duration: TimeInterval,
        didTransitionComplete: Bool,
        completion: @escaping () -> Void) {
        let snapshot = containerView.viewWithTag(snapShotTag)
        UIView.animate(
            withDuration: duration,
            animations: {
                snapshot?.frame.origin.x = 0
        }
        ) { _ in
            if didTransitionComplete {
                containerView.insertSubview(otherView, aboveSubview: settingView)
                snapshot?.removeFromSuperview()
            }
            completion()
        }
    }

}


extension SettingTransitionManager: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else {
                return
        }
        let view = UIView()
        let containerView = transitionContext.containerView
        let settingView = modalStatus == .present ? toVC.view : fromVC.view
        let otherView = modalStatus == .present ? fromVC.view : toVC.view
        let action = modalStatus == .present ? presentSetting : dismissSetting
        let duration = transitionDuration(using: transitionContext)
        let didTransitionComplete = !transitionContext.transitionWasCancelled
        action(settingView ?? view, otherView ?? view, containerView, duration, didTransitionComplete) {
            transitionContext.completeTransition(didTransitionComplete)
        }
    }

}

extension SettingTransitionManager: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        modalStatus = .present
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        modalStatus = .dismiss
        return self
    }

}
