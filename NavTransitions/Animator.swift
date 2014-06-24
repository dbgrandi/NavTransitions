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
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning!) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning!) {
        let toViewController =
            transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let dbgNav = toViewController.navigationController as DBGNavigationController
        let leftButton = dbgNav.leftButton
        
        switch operation {
        case .Pop:
            println("Pop")
            println("navController number of views = \(dbgNav.viewControllers.count)")
            transitionContext.containerView().insertSubview(toViewController.view, belowSubview: fromViewController.view)
            fromViewController.view.transform = CGAffineTransformMakeTranslation(0, 0)

            anchorToTop(toViewController.view)
            toViewController.view.transform = CGAffineTransformMakeScale(0.9, 0.98)
            toViewController.view.alpha = 0.5

            let animations = { () -> Void in
                fromViewController.view.transform = CGAffineTransformMakeTranslation(fromViewController.view.bounds.size.width, 0)
                toViewController.view.transform = CGAffineTransformIdentity
                toViewController.view.alpha = 1

                if dbgNav.viewControllers.count == 1 && !dbgNav.isInteractiveTransition {
                    leftButton.alpha = 0
                }
            }

            let completion = { (finished: Bool) -> Void in
                if finished {
                    self.anchorToCenter(toViewController.view)
                }
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            }
            UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: animations, completion: completion)
        case .Push:
            println("Push")
            println("navController number of views = \(dbgNav.viewControllers.count)")
            transitionContext.containerView().addSubview(toViewController.view)
            
            anchorToTop(fromViewController.view)
            
            toViewController.view.transform = CGAffineTransformMakeTranslation(toViewController.view.bounds.size.width, 0)
            
            let animations = { () -> Void in
                toViewController.view.transform = CGAffineTransformMakeTranslation(0, 0)
                fromViewController.view.transform = CGAffineTransformMakeScale(0.9, 0.98)
                fromViewController.view.alpha = 0.5
                
                if dbgNav.viewControllers.count == 2 && !dbgNav.isInteractiveTransition{
                    leftButton.alpha = 1
                }
            }
            
            let completion = { (finished: Bool) -> Void in
                if finished {
                    self.anchorToCenter(fromViewController.view)
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            }
            
            UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: animations, completion: completion)
        case .None:
            println("None")
            return
        }
    }
    
    func anchorToTop(view: UIView) {
        view.transform = CGAffineTransformIdentity
        let frame = view.frame
        let topCenter = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMinY(frame))
        view.layer.anchorPoint = CGPointMake(0.5, 0.0);
        view.layer.position = topCenter;
    }
    
    // This ASSUMES that the current anchorPoint is top center
    func anchorToCenter(view: UIView) {
        if view.layer.anchorPoint.y != 0 {
            return
        }
        
        view.transform = CGAffineTransformIdentity
        let frame = view.frame
        let bottomCenter = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        view.layer.anchorPoint = CGPointMake(0.5, 0.5);
        view.layer.position = bottomCenter;
    }

}