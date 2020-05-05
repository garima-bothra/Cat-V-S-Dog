//
//  Camera\ViewController.swift
//  Cat VS Dog
//
//  Created by Garima Bothra on 05/05/20.
//  Copyright © 2020 Garima Bothra. All rights reserved.
//

import UIKit
import AVKit

class CameraViewController: UIViewController {

    //Create variables
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    // Create outlets
    @IBOutlet weak var cameraButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.layer.cornerRadius = cameraButton.frame.height/2
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
        addBlur()


        // Do any additional setup after loading the view.
    }

    @IBAction func cameraButtonPressed(_ sender: Any) {
        let photoSettings: AVCapturePhotoSettings
        if ((self.photoOutput?.availablePhotoCodecTypes.contains(.hevc)) != nil) {
            photoSettings = AVCapturePhotoSettings(format:
                [AVVideoCodecKey: AVVideoCodecType.hevc])
        } else {
            photoSettings = AVCapturePhotoSettings()
        }
        photoSettings.flashMode = .auto
        photoSettings.isAutoStillImageStabilizationEnabled =
            ((self.photoOutput?.isStillImageStabilizationSupported) != nil)
      //  let captureProcessor = PhotoCaptureProcessor()
      //  self.photoOutput.capturePhoto(with: photoSettings, delegate: captureProcessor)

    }

}

extension CameraViewController {
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }

    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
                currentCamera = device
                print(device)
            }
            else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }

    }

    func setupInputOutput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
        } catch {
            print(error)
        }
    }

    func setupPreviewLayer() {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer! , at: 0)
    }

    func startRunningCaptureSession() {
        captureSession.startRunning()

    }

    //Function to add Blur with custom mask
       func addBlur(){
           //MARK: Add Blur view
        let blur = UIBlurEffect(style: .dark)
           let blurView = UIVisualEffectView(effect: blur)
        blurView.alpha = 0.7
           blurView.frame = self.view.bounds
           blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

           let scanLayer = CAShapeLayer()
           let maskSize = getMaskSize()
           let outerPath = UIBezierPath(roundedRect: maskSize, cornerRadius: 20)

           // Add a mask
           let superlayerPath = UIBezierPath(rect: blurView.frame)
           outerPath.append(superlayerPath)
           scanLayer.path = outerPath.cgPath
           scanLayer.fillRule = .evenOdd

           view.addSubview(blurView)
           blurView.layer.mask = scanLayer
       }

    // Get mask size respect to screen size
       private func getMaskSize() -> CGRect {
           let x = view.center.x
           let y = view.center.y 
           return CGRect(x: x, y: y, width: 64, height: 64)
       }

}
