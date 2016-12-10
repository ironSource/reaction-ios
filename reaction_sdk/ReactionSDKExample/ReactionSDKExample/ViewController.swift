//
//  ViewController.swift
//  ReactionSDKExample
//
//  Created by Valentine.Pavchuk on 9/21/16.
//  Copyright © 2016 ReAction. All rights reserved.
//

import UIKit
import ReActionSDK

import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet var logo: UIImageView!
    @IBOutlet var appKey: UILabel!
    @IBOutlet var iosID: UILabel!
    
    @IBOutlet var flipView: UIScrollView!
    
    
    @IBOutlet var stringEventName: UITextField!
    @IBOutlet var stringEventValue: UITextField!
    
    @IBOutlet var numberEventName: UITextField!
    @IBOutlet var numberEventValue: UITextField!
    
    @IBOutlet var revenueEventValue: UITextField!
    
    @IBOutlet var purchaseEventValue: UITextField!
    
    let appKeyStr_ = "IgbM_92Buth84Akobv9Ate20Dk"
    let senderId_ = "139121052578"
    
    var reactionSDK_: ISReaction2?
    
    var captureSession_: AVCaptureSession?
    var videoPreviewLayer_: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView_: UIView?
    var qrButtonClose_: UIButton?
    
    var qrCodeScannerClosed_: Bool = false;
    
    var qrCodeData_: String?
    
    // Added to support different barcodes
    let supportedBarCodes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reactionSDK_ = ISReaction2(senderID: senderId_,
                         applicationKey: appKeyStr_,
                         isDebug: true)
        
        self.initQRScanner()
    }
    
    func initQRScanner() {
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession_ = AVCaptureSession()
            // Set the input device on the capture session.
            captureSession_?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession_?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            
            // Detect all the supported bar code
            captureMetadataOutput.metadataObjectTypes = supportedBarCodes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer_ = AVCaptureVideoPreviewLayer(session: captureSession_)
            videoPreviewLayer_?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer_?.frame = view.layer.bounds
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }
    
    func startQRScanner() {
        view.layer.addSublayer(videoPreviewLayer_!)
        
        // Start video capture
        captureSession_?.startRunning()
        
        // Move the message label to the top view
        // view.bringSubviewToFront(messageLabel)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView_ = UIView()
        
        self.qrCodeScannerClosed_ = false;
        
        if let qrCodeFrameView = qrCodeFrameView_ {
            qrCodeFrameView.layer.borderColor = UIColor.greenColor().CGColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
        }
        
        self.qrButtonClose_ = UIButton()
        self.qrButtonClose_!.setTitle("Close", forState: .Normal)
        self.qrButtonClose_!.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.qrButtonClose_!.addTarget(self, action:
            #selector(ViewController.buttonQRScannerCloseClicked(_:)),
                                       forControlEvents: .TouchUpInside)
        
        self.qrButtonClose_!.backgroundColor = UIColor(red: 1.0, green: 1.0,
                                                       blue: 1.0, alpha: 0.5)
        
        self.qrButtonClose_!.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.qrButtonClose_!)
        self.view.bringSubviewToFront(self.qrButtonClose_!)
        
        let widthConstraint = NSLayoutConstraint(item: self.qrButtonClose_!,
                                                 attribute: NSLayoutAttribute.Width,
                                                 relatedBy: NSLayoutRelation.Equal,
                                                 toItem: self.view,
                                                 attribute: NSLayoutAttribute.Width,
                                                 multiplier: 1.0, constant: 0)
        
        let heightConstraint = NSLayoutConstraint(item: self.qrButtonClose_!,
                                                 attribute: NSLayoutAttribute.Height,
                                                 relatedBy: NSLayoutRelation.Equal,
                                                 toItem: nil,
                                                 attribute: NSLayoutAttribute.NotAnAttribute,
                                                 multiplier: 1.0, constant: 60)
        
        let centerXConstraint = NSLayoutConstraint(item: self.qrButtonClose_!,
                                                 attribute: NSLayoutAttribute.CenterX,
                                                 relatedBy: NSLayoutRelation.Equal,
                                                 toItem: self.view,
                                                 attribute: NSLayoutAttribute.CenterX,
                                                 multiplier: 1.0, constant: 0)
        
        let centerYConstraint = NSLayoutConstraint(item: self.qrButtonClose_!,
                                                  attribute: NSLayoutAttribute.Bottom,
                                                  relatedBy: NSLayoutRelation.Equal,
                                                  toItem: self.view,
                                                  attribute: NSLayoutAttribute.Bottom,
                                                  multiplier: 1.0, constant: 0)

        
       self.view.addConstraints([widthConstraint, heightConstraint, centerXConstraint, centerYConstraint])
    }
    
    func buttonQRScannerCloseClicked(sender: UIButton!) {
        self.stopQRScanner()
    }
    
    func stopQRScanner() {
        self.captureSession_?.stopRunning()
        self.videoPreviewLayer_!.removeFromSuperlayer()
        self.qrCodeFrameView_!.removeFromSuperview()
        self.qrButtonClose_!.removeFromSuperview()
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects
        metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView_?.frame = CGRectZero
            NSLog("No Bar code!");
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        // Here we use filter method to check if the type of metadataObj is supported
        // Instead of hardcoding the AVMetadataObjectTypeQRCode, we check if the type
        // can be found in the array of supported bar codes.
        if supportedBarCodes.contains(metadataObj.type) {
            //        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer_?.transformedMetadataObjectForMetadataObject(metadataObj)
            qrCodeFrameView_?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                NSLog("Bar code: %@", metadataObj.stringValue);
                
                self.qrCodeData_ = metadataObj.stringValue;
                
                if (!self.qrCodeScannerClosed_) {
                    self.qrCodeScannerClosed_ = true;
                    
                    let seconds = 1.0
                    let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
                    let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    
                    dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                        
                        // here code perfomed with delay
                        self.stopQRScanner();
                        
                        if ((self.qrCodeData_) != nil) {
                            let qrCodeDataArray: [String] = self.qrCodeData_!
                                .componentsSeparatedByString("::");
                            
                            let appKey: String = qrCodeDataArray[0];
                            //register demo device
                            self.reactionSDK_!.registerDemoDeviceWithAppKey(appKey);
                        }
                    })
                }
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onRefreshPress(sender: AnyObject) {
        self.iosID.text = self.reactionSDK_?.getDeviceID()
        self.appKey.text = self.appKeyStr_
    }
    
    @IBAction func onRegisterDemoPress(sender: AnyObject) {
        self.startQRScanner()
    }
    
    @IBAction func onReportStringPress(sender: AnyObject) {
        if (self.stringEventName.text?.characters.count > 0) &&
            (self.stringEventValue.text?.characters.count > 0) {
            self.reactionSDK_!.reportStringWithName(stringEventName.text!,
                                            value: stringEventValue.text!)
        }
    }

    @IBAction func onReportNumberPress(sender: AnyObject) {
        if (self.numberEventName.text?.characters.count > 0) &&
            (self.numberEventValue.text?.characters.count > 0) {
            if let floatValue = Float(numberEventValue.text!) {
                self.reactionSDK_!.reportNumberWithName(numberEventName.text!,
                                                value: floatValue)
            }
        }
    }
    
    @IBAction func onReportRevenuePress(sender: AnyObject) {
        if self.revenueEventValue.text?.characters.count > 0 {
            if let floatValue = Float(revenueEventValue.text!) {
                self.reactionSDK_!.reportRevenue(floatValue)
            }
        }
    }
    
    @IBAction func onReportPurchasePress(sender: AnyObject) {
        if self.purchaseEventValue.text?.characters.count > 0 {
            if let floatValue = Float(purchaseEventValue.text!) {
                self.reactionSDK_!.reportPurchase(floatValue)
            }
        }
    }

}

