//
//  CameraView.swift
//  CoreMLSample
//
//  Created by Bruno Rocha on 6/9/17.
//  Copyright © 2017 Bruno Rocha. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {

    override func loadView() {
        view = CameraView(delegate: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        smartView.startCaptureSession()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        smartView.stopCaptureSession()
    }
}

extension CameraViewController: CameraViewDelegate {
    func cameraViewDidPredictScene(label: String?, confidence: Double?) {
        guard let label = label, let confidence = confidence else {
            smartView.setUnknownPrediction()
            return
        }
        let formattedConfidence = "\(Int(confidence * 100))%"
        smartView.set(label: label, confidence: formattedConfidence)
    }
}

extension CameraViewController: SmartViewController {
    typealias SmartView = CameraView
}
