//
//  Animator.swift
//  NavTransitions
//
//  Created by David Grandinetti on 6/14/14.
//  Copyright (c) 2014 David Grandinetti. All rights reserved.
//

import Foundation
import UIKit

class Animator: NSObject, UIViewControllerAnimatedTransitioning {

    var operation: UINavigationControllerOperation = .None

    /**
     * When the transition is not interactive, set the animation to 0.3 seconds.
     */
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.3
    }

    /**
     * This sets up a non-interactive animation for either a push or a pop.
     * If this is being used in an interactive animation, the calling function
     * will immediately set the CALayer.speed to 0 on both the to and from
     * viewControllers, then controls the animation by manipulating the
     * CALayer.timeOffset. In this example, the timeOffset is controlled via
     * a UIPercentDrivenInteractiveTransition.
     *
     * See http://johansorensen.com/articles/pausing%20and%20controlling%20the%20speed%20of%20Core%20Animation.html
     *
     */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let toViewController =
            transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!

        // Pull our custom navController to fade in/out the navButton
        let dbgNav = toViewController.navigationController as DBGNavigationController
        
        switch operation {
        case .Pop:
            transitionContext.containerView().insertSubview(toViewController.view, belowSubview: fromViewController.view)
            fromViewController.view.transform = CGAffineTransformMakeTranslation(0, 0)

            moveAnchorToTopCenter(toViewController.view)
            toViewController.view.transform = CGAffineTransformMakeScale(0.9, 0.98)
            toViewController.view.alpha = 0.5

            let animations = { () -> Void in
                fromViewController.view.transform = CGAffineTransformMakeTranslation(fromViewController.view.bounds.size.width, 0)
                toViewController.view.transform = CGAffineTransformIdentity
                toViewController.view.alpha = 1

                if dbgNav.viewControllers.count == 1 && !dbgNav.isInteractiveTransition {
                    dbgNav.leftButton.alpha = 0
                }
            }

            let completion = { (finished: Bool) -> Void in
                if finished {
                    self.moveAnchorToCenterFromTopCenter(toViewController.view)
                }
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            }
            UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: animations, completion: completion)
        case .Push:
            println("Push")
            transitionContext.containerView().addSubview(toViewController.view)
            
            moveAnchorToTopCenter(fromViewController.view)
            
            toViewController.view.transform = CGAffineTransformMakeTranslation(toViewController.view.bounds.size.width, 0)
            
            let animations = { () -> Void in
                toViewController.view.transform = CGAffineTransformMakeTranslation(0, 0)
                fromViewController.view.transform = CGAffineTransformMakeScale(0.9, 0.98)
                fromViewController.view.alpha = 0.5
                
                if dbgNav.viewControllers.count == 2 && !dbgNav.isInteractiveTransition{
                    dbgNav.leftButton.alpha = 1
                }
            }
            
            let completion = { (finished: Bool) -> Void in
                if finished {
                    self.moveAnchorToCenterFromTopCenter(fromViewController.view)
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            }
            
            UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: animations, completion: completion)
        case .None:
            println("None")
            return
        }
    }
    
    /*
     * This moves the anchor point to the top center of a view. It also
     * translates the position so that the view doesn't jump when we move
     * the anchor.
     */
    func moveAnchorToTopCenter(view: UIView) {
        view.transform = CGAffineTransformIdentity
        let frame = view.frame
        let topCenter = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMinY(frame))
        view.layer.anchorPoint = CGPointMake(0.5, 0.0);
        view.layer.position = topCenter;
    }
    
    /**
     * This will reset the anchor back to the center to keep things sensible.
     * It REQUIRES that the current anchorPoint is top center (e.g. 0.5, 0.0)
     * otherwise it will not anchor the view to (0.5, 0.5)
     */
    func moveAnchorToCenterFromTopCenter(view: UIView) {
        let anchorPoint = view.layer.anchorPoint
        if anchorPoint.x == 0.5 && anchorPoint.y == 0 {
            view.transform = CGAffineTransformIdentity
            let frame = view.frame
            let bottomCenter = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
            view.layer.anchorPoint = CGPointMake(0.5, 0.5);
            view.layer.position = bottomCenter;
        }
    }

}