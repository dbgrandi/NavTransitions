//
//  DBGNavigationController.swift
//  NavTransitions
//
//  Created by David Grandinetti on 6/18/14.
//  Copyright (c) 2014 David Grandinetti. All rights reserved.
//

import UIKit

class DBGNavigationController: UINavigationController, UINavigationControllerDelegate {

    var isInteractiveTransition = false
    
    let leftButton: UIButton
    
    let animator: Animator?
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
        
        // set width height of back button to 40
        // set back button to be 20px from top left
        
        let views = ["leftButton": leftButton]
        let metrics = ["topMargin":30, "leftMargin":20, "size":40]
        
        view.addSubview(leftButton)
        
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
        return (interactionController? ? interactionController! : nil)
    }
    
    func navigationController(navigationController: UINavigationController!, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController!, toViewController toVC: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        if let a = animator {
            a.operation = operation
            return a
        }
        
        return nil
    }

    // MARK: - Pan Gesture Recognizer

    func pan(recognizer: UIScreenEdgePanGestureRecognizer) {
        switch recognizer.state {
        case .Began:
            if viewControllers.count > 1 {
                // set interactive switch here
                isInteractiveTransition = true
                interactionController = UIPercentDrivenInteractiveTransition()
                popViewControllerAnimated(true)
            }
        case .Changed:
            if let interaction = interactionController {
                let translation = recognizer.translationInView(view)
                let d = fabsf(translation.x / CGRectGetWidth(view.bounds))
                interaction.updateInteractiveTransition(d)
                if viewControllers.count == 1 {
                    leftButton.alpha = (1 - d)
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
            // unset interactive switch here
            isInteractiveTransition = false

            interactionController = nil
        case _:
            NSLog("ignore")
        }
    }
}
