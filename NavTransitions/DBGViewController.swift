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
        self.view.backgroundColor = UIColor.randomColor()
        
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tap:")
        self.view.addGestureRecognizer(tapRecognizer)

        super.viewDidLoad()
    }
    
    func tap(sender: UITapGestureRecognizer) {
        let vc = DBGViewController()
        self.navigationController.pushViewController(vc, animated: true)
    }
}