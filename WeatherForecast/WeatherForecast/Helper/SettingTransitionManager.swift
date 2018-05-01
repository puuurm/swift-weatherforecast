//
//  SettingTransitionManager.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 4. 26..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

struct TransitionConfigure {
    var containerView: UIView
    var duration: TimeInterval
    var fromView: UIView
    var toView: UIView
    var didTransitionComplete: Bool
}

class SettingTransitionManager: NSObject {

    private var duration: TimeInterval = 0.7
    private var settingWidth: CGFloat = UIScreen.main.bounds.width * 0.6
    private var snapShotTag: Int = 999
    private var modalStatus: Status = .present
    typealias Handler = (() -> Void)

    private enum Status {
        case present
        case dismiss
    }

    private func presentSetting(_ transitionConfigure: TransitionConfigure, completion: @escaping Handler) {
        let containerView: UIView = transitionConfigure.containerView
        let otherView: UIView = transitionConfigure.fromView
        let settingView: UIView = transitionConfigure.toView
        let duration: TimeInterval = transitionConfigure.duration
        containerView.insertSubview(settingView, belowSubview: otherView)
        if let snapShot = otherView.snapshotView(afterScreenUpdates: false) {
            let coverView = UIView(frame: otherView.bounds)
            coverView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            snapShot.addSubview(coverView)
            snapShot.tag = snapShotTag
            snapShot.isUserInteractionEnabled = false
            containerView.insertSubview(snapShot, aboveSubview: settingView)
            otherView.isHidden = true
            move(snapShot, duration: duration, to: settingWidth) {
                otherView.isHidden = false
                completion()
            }
        }
    }

    private func dismissSetting(_ transitionConfigure: TransitionConfigure, completion: @escaping Handler) {
        let containerView: UIView = transitionConfigure.containerView
        let otherView: UIView = transitionConfigure.toView
        let settingView: UIView = transitionConfigure.fromView
        let duration: TimeInterval = transitionConfigure.duration
        let didTransitionComplete: Bool = transitionConfigure.didTransitionComplete
        let snapshot = containerView.viewWithTag(snapShotTag)
        move(snapshot, duration: duration, to: 0) {
            if didTransitionComplete {
                containerView.insertSubview(otherView, aboveSubview: settingView)
                snapshot?.removeFromSuperview()
            }
            completion()
        }
    }

    private func move(_ view: UIView?, duration: TimeInterval, to xPosition: CGFloat, completion: @escaping Handler) {
        guard let view = view else { return }
        UIView.animate(
            withDuration: duration,
            animations: {
                view.frame.origin.x = xPosition
        },
            completion: { _ in
                completion()
            }
        )
    }

}

// MARK: - UIViewControllerAnimatedTransitioning

extension SettingTransitionManager: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else {
                return
        }
        let containerView = transitionContext.containerView
        let action = modalStatus == .present ? presentSetting : dismissSetting
        let duration = transitionDuration(using: transitionContext)
        let didTransitionComplete = !transitionContext.transitionWasCancelled
        let transitionConfigure = TransitionConfigure(
            containerView: containerView,
            duration: duration,
            fromView: fromVC.view,
            toView: toVC.view,
            didTransitionComplete: didTransitionComplete
        )
        action(transitionConfigure) {
            transitionContext.completeTransition(didTransitionComplete)
        }
    }

}

// MARK: - UIViewControllerTransitioningDelegate

extension SettingTransitionManager: UIViewControllerTransitioningDelegate {

    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
        ) -> UIViewControllerAnimatedTransitioning? {
        modalStatus = .present
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        modalStatus = .dismiss
        return self
    }

}
