//
//  ScanViewController.swift
//  BookMe
//
//  Created by mac on 21.01.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit
import AVFoundation
import ImageIO

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var lineView: UIImageView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var holeView: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    var captureSession: AVCaptureSession? = nil
    var videoPreviewLayer: AVCaptureVideoPreviewLayer? = nil
    var fastRead : Bool = false
    var timer : Timer? = nil
    var code : String? = nil
    
    let supportedCodeTypes = [AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode]
    
    deinit {
        invalidateTimer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var frame = holeView.frame
        frame.origin.y -= 64
        blurView.addHole(rect: frame)
        navbarSettings()
        startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startCamera()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession?.stopRunning()
    }
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate Methods
    
    @objc private func startAnimateLine() {
        let alpha : CGFloat = lineView.alpha == 0 ? 1 : 0
        UIView.animate(withDuration: 0.5, animations: {
            self.lineView.alpha = alpha
        })
    }
    
    private func startCamera() {
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            cameraView.layer.addSublayer(videoPreviewLayer!)
            captureSession?.startRunning()
        } catch {
            print(error)
            return
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if captureSession?.isRunning == false {return}
        if metadataObjects == nil || metadataObjects.count == 0 {
            noBarCode()
            return
        }
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if !supportedCodeTypes.contains(metadataObj.type) {return}
        if metadataObj.stringValue == nil { return}
        code = metadataObj.stringValue
        fastRead == true ? takeBook() : performSegue(withIdentifier: "addBook", sender: metadataObj.stringValue)
    }
    
    private func noBarCode() {
        ServerError.show(error: 783, nil) { _ in
            self.performSegue(withIdentifier: "addBook", sender: nil)
        }
    }
    
    private func navbarSettings() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationItem.title = fastRead == true ? NSLocalizedString("Взять книгу", comment: "") : NSLocalizedString("Добавить книгу", comment: "")
    }
    
    private func startTimer() {
        if timer != nil {return}
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.startAnimateLine), userInfo: nil, repeats: true)
    }
    
    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    //MARK - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        captureSession?.stopRunning()
        if segue.identifier == "addBook" {
            let vc = segue.destination as? AddBookViewController
            vc?.book.barcode = sender as? String
        }
    }
    

}
