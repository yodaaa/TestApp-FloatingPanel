//
//  ViewController.swift
//  TestApp-FloatingPanel
//
//  Created by yodaaa on 2019/04/16.
//  Copyright © 2019 yodaaa. All rights reserved.
//

import UIKit
import FloatingPanel

class ViewController: UIViewController {
    
    var floatingPanelController: FloatingPanelController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        floatingPanelController = FloatingPanelController()
        
        let semiModalViewController = SemiModalViewController()
        floatingPanelController.set(contentViewController: semiModalViewController)
        
        floatingPanelController.addPanel(toParent: self, belowView: nil, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        floatingPanelController.removePanelFromParent(animated: true)
    }


}

