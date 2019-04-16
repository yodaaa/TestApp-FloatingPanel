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
        floatingPanelController.delegate = self
        
        let semiModalViewController = SemiModalViewController()
        floatingPanelController.set(contentViewController: semiModalViewController)
        
        // セミモーダルビューをっ角丸にする
        floatingPanelController.surfaceView.cornerRadius = 24.0
        
        floatingPanelController.addPanel(toParent: self, belowView: nil, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        floatingPanelController.removePanelFromParent(animated: true)
    }


}

extension ViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return CustomFloatingPanelLayout()
    }
    
    func floatingPanelDidEndDragging(_ vc: FloatingPanelController, withVelocity velocity: CGPoint, targetPosition: FloatingPanelPosition) {
        
        // セミモーダルビューの各表示パターンの高さに応じて処理を実行する
        switch targetPosition {
        case .tip:
            print("tip")
            floatingPanelController.move(to: .hidden, animated: false)
        case .half:
            print("half")
        case .full:
            print("full")
        case .hidden:
            break
        }
    }
}

class CustomFloatingPanelLayout: FloatingPanelLayout {
    
    // セミモーダルビューの初期位置
    var initialPosition: FloatingPanelPosition {
        return .half
    }
    
    // セミモーダルビューで対応するポジション
    var supportedPositions: Set<FloatingPanelPosition> {
        return [.full, .half]
    }
    
    var topInteractionBuffer: CGFloat { return 0.0 }
    var bottomInteractionBuffer: CGFloat { return 0.0 }

    // セミモーダルビューの各表示パターンの高さを決定するためのInset
    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full: return 100.0
        case .half: return 262.0
        case .tip: return 100.0
        case .hidden: return 1.0
        }
    }
    
    // セミモーダルビューの背景Viewの透明度
    func backdropAlphaFor(position: FloatingPanelPosition) -> CGFloat {
        return 0.0
    }
}


