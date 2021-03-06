//
//  CameraView.swift
//  CoreMLSample
//
//  Created by Bruno Rocha on 6/9/17.
//  Copyright © 2017 Bruno Rocha. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

final class CameraView: UIView {

    weak var delegate: CameraViewDelegate?
    private let captureSession: AVCaptureSession

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.textColor = .white
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()

    private let confidenceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .white
        return label
    }()

    init(delegate: CameraViewDelegate) {
        self.delegate = delegate
        captureSession = AVCaptureSession()
        super.init(frame: UIScreen.main.bounds)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    private func setup() {
        setupCaptureSession()
        setupVideoLayer()
        setupLabels()
        constrainLabels()
    }

    private func setupCaptureSession() {
        let captureDevice = AVCaptureDevice.default(for: .video)
        let input = try! AVCaptureDeviceInput(device: captureDevice!)
        captureSession.addInput(input as AVCaptureInput)
        let captureMetadataOutput = AVCaptureVideoDataOutput()
        captureMetadataOutput.alwaysDiscardsLateVideoFrames = true
        captureMetadataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String:kCVPixelFormatType_32BGRA]
        captureSession.addOutput(captureMetadataOutput)
        let outputQueue = DispatchQueue(label: "outputQueue")
        captureMetadataOutput.setSampleBufferDelegate(self, queue: outputQueue)
    }

    private func setupVideoLayer() {
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.frame = layer.bounds
        layer.addSublayer(videoPreviewLayer)
    }

    private func setupLabels() {
        addSubview(nameLabel)
        addSubview(confidenceLabel)
        setUnknownPrediction()
    }

    private func constrainLabels() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        confidenceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -48),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            confidenceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            confidenceLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    func startCaptureSession() {
        let queue = DispatchQueue(label: "cameraBG")
        queue.async {
            self.captureSession.startRunning()
        }
    }

    func stopCaptureSession() {
        captureSession.stopRunning()
    }

    func set(label: String, confidence: String) {
        DispatchQueue.main.async { [weak self] in
            self?.nameLabel.text = label
            self?.confidenceLabel.text = confidence
        }
    }

    func setUnknownPrediction() {
        set(label: "????", confidence: "????")
    }
}

extension CameraView: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        let model = try! VNCoreMLModel(for: Inceptionv3().model)
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError()
            }
            let prediction = results[0]
            self?.delegate?.cameraViewDidPredictScene(label: prediction.identifier, confidence: Double(prediction.confidence))
        }
        request.imageCropAndScaleOption = VNImageCropAndScaleOptionCenterCrop
        let handler = VNImageRequestHandler(cvPixelBuffer: imageBuffer, options: [:])
        try? handler.perform([request])
    }
}

protocol CameraViewDelegate: class {
    func cameraViewDidPredictScene(label: String?, confidence: Double?)
}
