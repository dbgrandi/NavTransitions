//
//  DBGNavigationController.swift
//  NavTransitions
//
//  Created by David Grandinetti on 6/18/14.
//  Copyright (c) 2014 David Grandinetti. All rights reserved.
//

import UIKit

class DBGNavigationController: UINavigationController, UINavigationControllerDelegate {

    /**
     * Boolean for tracking when we are in an interactive transition. This is
     * needed to allow for the alpha of the back button to be animated
     * properly.
     */
    var isInteractiveTransition = false
    
    /**
     * The back button that is in the top left corner of the navigation view.
     * This will be hidden when viewing the root of the nav controller stack.
     */
    let leftButton: UIButton

    /**
     * Animator that handles the basic transition animation. This is also
     * used when it is an interactive transition by setting the speed of the
     * animation to 0 and manipulating time based on the percent driven
     * transition.
     */
    let animator: Animator?
    
    /**
     * Interaction controller that is hooked up to the Pan Gesture
     * recognizer.
     */
    var interactionController: UIPercentDrivenInteractiveTransition?
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    init(nibName: String!, bundle: NSBundle!) {
        leftButton = UIButton.buttonWithType(.Custom) as UIButton
        animator = Animator()

        // use designated initializer on UINavigationController
        super.init(nibName: nibName, bundle: nibBundle)

        // now do our custom init
        delegate = self
        navigationBarHidden = true
        view.backgroundColor = UIColor.blackColor()

        let edgeRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "pan:")
        edgeRecognizer.edges = UIRectEdge.Left
        view.addGestureRecognizer(edgeRecognizer)
        
        configLeftButton()
    }
    
    func configLeftButton() {
        leftButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        leftButton.setBackgroundImage(UIImage(named: "NavButtonBG"), forState: .Normal)
        leftButton.setImage(UIImage(named: "BackArrow-Normal"), forState: .Normal)
        leftButton.setImage(UIImage(named: "BackArrow-Selected"), forState: (.Highlighted | .Selected) )
        
        leftButton.addTarget(self, action: "backButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        leftButton.alpha = 0
        
        view.addSubview(leftButton)

        let views = ["leftButton": leftButton]
        let metrics = ["topMargin":30, "leftMargin":20, "size":40]
        let horizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(leftMargin)-[leftButton(size)]", options:nil, metrics: metrics, views: views)
        let vertical = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(topMargin)-[leftButton(size)]", options:nil, metrics: metrics, views: views)

        view.addConstraints(horizontal)
        view.addConstraints(vertical)
    }
    
    func backButtonPressed(sender: UIButton) {
        popViewControllerAnimated(true)
    }
    
    // MARK: - UINavigationControllerDelegate
    
    func navigationController(navigationController: UINavigationController!, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning!) -> UIViewControllerInteractiveTransitioning! {
        return (interactionController? ? interactionController : nil)
    }
    
    func navigationController(navigationController: UINavigationController!, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController!, toViewController toVC: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        if let a = animator {
            a.operation = operation
            return a
        }
        
        return nil
    }

    // MARK: - Pan Gesture Recognizer

    /**
     * Use the pan gesture to manage popping the navigation stack to the
     * previous UIViewController. 
     */
    func pan(recognizer: UIScreenEdgePanGestureRecognizer) {
        switch recognizer.state {
        case .Began:
            if viewControllers.count > 1 {
                isInteractiveTransition = true
                interactionController = UIPercentDrivenInteractiveTransition()
                popViewControllerAnimated(true)
            }
        case .Changed:
            if let interaction = interactionController {
                let translation = recognizer.translationInView(view)
                let width = CGRectGetWidth(view.bounds)
                let x = translation.x
                let d = fabsf( Float(x) / Float(width) )
                interaction.updateInteractiveTransition(CGFloat(d))
                if viewControllers.count == 1 {
                    leftButton.alpha = CGFloat(1 - d)
                }
            }
        case .Ended:
            if recognizer.velocityInView(view).x > 0 {
                interactionController?.finishInteractiveTransition()
                if viewControllers.count == 1 {
                    UIView.animateWithDuration(0.1, animations: {() -> Void in self.leftButton.alpha = 0 })
                }
            } else {
                interactionController?.cancelInteractiveTransition()
                if viewControllers.count == 1 {
                    UIView.animateWithDuration(0.1, animations: {() -> Void in self.leftButton.alpha = 1 })
                }
            }
            isInteractiveTransition = false
            interactionController = nil
        case _:
            NSLog("ignore in this simple example")
        }
    }
}
