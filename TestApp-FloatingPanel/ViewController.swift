//
//  ViewController.swift
//  TestApp-FloatingPanel
//
//  Created by yodaaa on 2019/04/16.
//  Copyright © 2019 yodaaa. All rights reserved.
//

import UIKit
import MapKit
import FloatingPanel

class ViewController: UIViewController, MKMapViewDelegate {
    
    var floatingPanelController: FloatingPanelController!
    var settingsPanelVC: FloatingPanelController!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        floatingPanelController = FloatingPanelController()
        floatingPanelController.delegate = self
        
        let semiModalViewController = SemiModalViewController()
        floatingPanelController.set(contentViewController: semiModalViewController)
        
        floatingPanelController.surfaceView.backgroundColor = .clear
        // セミモーダルビューを角丸にする
        floatingPanelController.surfaceView.cornerRadius = 24.0
        floatingPanelController.surfaceView.shadowHidden = false
        
        setupMapView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        floatingPanelController.addPanel(toParent: self, belowView: nil, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        floatingPanelController.removePanelFromParent(animated: true)

        floatingPanelController.hide(animated: true) {
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
    
    func setupMapView() {
        let center = CLLocationCoordinate2D(latitude: 37.623198015869235,
                                            longitude: -122.43066818432008)
        let span = MKCoordinateSpan(latitudeDelta: 0.4425100023575723,
                                    longitudeDelta: 0.28543697435880233)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.region = region
        mapView.showsCompass = true
        mapView.showsUserLocation = true
        mapView.delegate = self
    }
    
    @IBAction func showSettingView(_ sender: Any) {
        guard settingsPanelVC == nil else { return }
        // Initialize FloatingPanelController
        settingsPanelVC = FloatingPanelController()
        
        // Initialize FloatingPanelController and add the view
        settingsPanelVC.surfaceView.cornerRadius = 6.0
        settingsPanelVC.surfaceView.shadowHidden = false
        settingsPanelVC.isRemovalInteractionEnabled = true
        
        let backdropTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackdrop(tapGesture:)))
        settingsPanelVC.backdropView.addGestureRecognizer(backdropTapGesture)
        
        settingsPanelVC.delegate = self
        
        let contentVC = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController")
        
        // Set a content view controller
        settingsPanelVC.set(contentViewController: contentVC)
        
        //  Add FloatingPanel to self.view
        settingsPanelVC.addPanel(toParent: self, belowView: nil, animated: true)
    }
    
    @objc func handleBackdrop(tapGesture: UITapGestureRecognizer) {
        switch tapGesture.view {
        case floatingPanelController.backdropView:
            floatingPanelController.hide(animated: true, completion: nil)
        case settingsPanelVC.backdropView:
            settingsPanelVC.removePanelFromParent(animated: true)
            settingsPanelVC = nil
        default:
            break
        }
    }

}

extension ViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        if vc == floatingPanelController {
            return CustomFloatingPanelLayout()
        } else if vc == settingsPanelVC {
            return SettingsCustomFloatingPanelLayout()
        }
        return nil
    }
    
    func floatingPanelDidEndRemove(_ vc: FloatingPanelController) {
        switch vc {
        case settingsPanelVC:
            settingsPanelVC = nil
        default:
            break
        }
    }
    
    func floatingPanelDidEndDragging(_ vc: FloatingPanelController, withVelocity velocity: CGPoint, targetPosition: FloatingPanelPosition) {
        
        // セミモーダルビューの各表示パターンの高さに応じて処理を実行する
        switch targetPosition {
        case .tip:
            print("tip")
            floatingPanelController.move(to: .full, animated: true)
        case .half:
            print("half")
        case .full:
            print("full")
            //floatingPanelController.move(to: .tip, animated: true)
        case .hidden:
            break
        }
    }
}

class CustomFloatingPanelLayout: FloatingPanelLayout {
    
    // セミモーダルビューの初期位置
    var initialPosition: FloatingPanelPosition {
        return .tip
    }
    
    // セミモーダルビューで対応するポジション
    var supportedPositions: Set<FloatingPanelPosition> {
        return [.full, .tip]
    }
    
    var topInteractionBuffer: CGFloat { return 0.0 }
    var bottomInteractionBuffer: CGFloat { return 0.0 }

    // セミモーダルビューの各表示パターンの高さを決定するためのInset
    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full: return 100.0
//        case .half: return 262.0
        case .tip: return 100.0
        default: return nil
        }
    }
    
    // セミモーダルビューの背景Viewの透明度
    func backdropAlphaFor(position: FloatingPanelPosition) -> CGFloat {
        return 0.0
    }
}

class SettingsCustomFloatingPanelLayout: FloatingPanelLayout {
    var initialPosition: FloatingPanelPosition {
        return .tip
    }
    
    var supportedPositions: Set<FloatingPanelPosition> {
        return [.tip]
    }
    
    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .tip:
            return 100.0
        default:
            return nil
        }
    }
    
    
}
