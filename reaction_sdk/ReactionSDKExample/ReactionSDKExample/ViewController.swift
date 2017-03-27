//
//  ViewController.swift
//  ReactionSDKExample
//
//  Created by Valentine.Pavchuk on 9/21/16.
//  Copyright © 2016 ReAction. All rights reserved.
//

import UIKit
import Reaction
import UserNotifications

import AVFoundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



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
    
    var reactionSDK_: Reaction?
    
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
        
        // 1. Request permitions
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound],
                                                                completionHandler: { (granted, error) in
            if granted {
                print("Notification access granted!")
            } else {
                print(error?.localizedDescription)
            }
        })
        
        reactionSDK_ = Reaction.create(withSenderID: senderId_, applicationKey: appKeyStr_,
                         isDebug: true) 
        
        //var currentClass: AnyClass? = Reaction.getClassByName("ISRWebInterface");
        
        self.initQRScanner()
        
        
    }
    
    /*
    func scheduleNotification(timeout: TimeInterval, completion: @escaping (_ Success: Bool) -> ()) {
        let notification = UNMutableNotificationContent()
        
        notification.title = "Test title"
        notification.subtitle = "Test subtitle"
        notification.body = "Test body"
        
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: timeout,
                                                                    repeats: false)
        
        let request = UNNotificationRequest(identifier: "ReactionNotification",
                                            content: notification,
                                            trigger: notificationTrigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                print(error?.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        })
    }*/
    
    func initQRScanner() {
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
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
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
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
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
        
        self.qrButtonClose_ = UIButton()
        self.qrButtonClose_!.setTitle("Close", for: UIControlState())
        self.qrButtonClose_!.setTitleColor(UIColor.black, for: UIControlState())
        self.qrButtonClose_!.addTarget(self, action:
            #selector(ViewController.buttonQRScannerCloseClicked(_:)),
                                       for: .touchUpInside)
        
        self.qrButtonClose_!.backgroundColor = UIColor(red: 1.0, green: 1.0,
                                                       blue: 1.0, alpha: 0.5)
        
        self.qrButtonClose_!.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.qrButtonClose_!)
        self.view.bringSubview(toFront: self.qrButtonClose_!)
        
        let widthConstraint = NSLayoutConstraint(item: self.qrButtonClose_!,
                                                 attribute: NSLayoutAttribute.width,
                                                 relatedBy: NSLayoutRelation.equal,
                                                 toItem: self.view,
                                                 attribute: NSLayoutAttribute.width,
                                                 multiplier: 1.0, constant: 0)
        
        let heightConstraint = NSLayoutConstraint(item: self.qrButtonClose_!,
                                                 attribute: NSLayoutAttribute.height,
                                                 relatedBy: NSLayoutRelation.equal,
                                                 toItem: nil,
                                                 attribute: NSLayoutAttribute.notAnAttribute,
                                                 multiplier: 1.0, constant: 60)
        
        let centerXConstraint = NSLayoutConstraint(item: self.qrButtonClose_!,
                                                 attribute: NSLayoutAttribute.centerX,
                                                 relatedBy: NSLayoutRelation.equal,
                                                 toItem: self.view,
                                                 attribute: NSLayoutAttribute.centerX,
                                                 multiplier: 1.0, constant: 0)
        
        let centerYConstraint = NSLayoutConstraint(item: self.qrButtonClose_!,
                                                  attribute: NSLayoutAttribute.bottom,
                                                  relatedBy: NSLayoutRelation.equal,
                                                  toItem: self.view,
                                                  attribute: NSLayoutAttribute.bottom,
                                                  multiplier: 1.0, constant: 0)

        
       self.view.addConstraints([widthConstraint, heightConstraint, centerXConstraint, centerYConstraint])
    }
    
    func buttonQRScannerCloseClicked(_ sender: UIButton!) {
        self.stopQRScanner()
    }
    
    func stopQRScanner() {
        self.captureSession_?.stopRunning()
        self.videoPreviewLayer_!.removeFromSuperlayer()
        self.qrCodeFrameView_!.removeFromSuperview()
        self.qrButtonClose_!.removeFromSuperview()
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects
        metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView_?.frame = CGRect.zero
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
            let barCodeObject = videoPreviewLayer_?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView_?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                NSLog("Bar code: %@", metadataObj.stringValue);
                
                self.qrCodeData_ = metadataObj.stringValue;
                
                if (!self.qrCodeScannerClosed_) {
                    self.qrCodeScannerClosed_ = true;
                    
                    let seconds = 1.0
                    let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
                    let dispatchTime = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                    
                    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                        
                        // here code perfomed with delay
                        self.stopQRScanner();
                        
                        if ((self.qrCodeData_) != nil) {
                            let qrCodeDataArray: [String] = self.qrCodeData_!
                                .components(separatedBy: "::");
                            
                            let appKey: String = qrCodeDataArray[0];
                            //register demo device
                            self.reactionSDK_!.registerDemoDevice(withAppKey: appKey);
                        }
                    })
                }
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onRefreshPress(_ sender: AnyObject) {
        self.iosID.text = self.reactionSDK_?.getDeviceID()
        self.appKey.text = self.appKeyStr_
    }
    
    @IBAction func onRegisterDemoPress(_ sender: AnyObject) {
        self.startQRScanner()
    }
    
    @IBAction func onReportStringPress(_ sender: AnyObject) {
        if (self.stringEventName.text?.characters.count > 0) &&
            (self.stringEventValue.text?.characters.count > 0) {
            self.reactionSDK_!.reportString(withName: stringEventName.text!,
                                            value: stringEventValue.text!)
        }
    }

    @IBAction func onReportNumberPress(_ sender: AnyObject) {
        if (self.numberEventName.text?.characters.count > 0) &&
            (self.numberEventValue.text?.characters.count > 0) {
            if let floatValue = Float(numberEventValue.text!) {
                self.reactionSDK_!.reportNumber(withName: numberEventName.text!,
                                                value: floatValue)
            }
        }
    }
    
    @IBAction func onReportRevenuePress(_ sender: AnyObject) {
        if self.revenueEventValue.text?.characters.count > 0 {
            if let floatValue = Float(revenueEventValue.text!) {
                self.reactionSDK_!.reportRevenue(floatValue)
            }
        }
    }
    
    @IBAction func onReportPurchasePress(_ sender: AnyObject) {
        if self.purchaseEventValue.text?.characters.count > 0 {
            if let floatValue = Float(purchaseEventValue.text!) {
                self.reactionSDK_!.reportPurchase(floatValue)
            }
        }
    }

}

