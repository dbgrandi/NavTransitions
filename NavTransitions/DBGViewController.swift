//
//  DBGViewController.swift
//  NavTransitions
//
//  Created by David Grandinetti on 6/14/14.
//  Copyright (c) 2014 David Grandinetti. All rights reserved.
//

import UIKit

class DBGViewController: UIViewController {

    override func viewDidLoad() {
        let contrastingColor = UIColor.randomColor()
        self.view.backgroundColor = contrastingColor
        
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tap:")
        self.view.addGestureRecognizer(tapRecognizer)
        super.viewDidLoad()
    }
    
    func tap(sender: UITapGestureRecognizer) {
        let vc = DBGViewController()
        self.navigationController.pushViewController(vc, animated: true)
    }
}