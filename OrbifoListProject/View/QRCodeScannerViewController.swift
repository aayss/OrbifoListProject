//
//  QRCodeScannerViewController.swift
//  OrbifoListProject
//
//  Created by Ayse Cengiz on 7.12.2020.
//

import Foundation
import UIKit
import AVFoundation

class QRCodeScannerViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate, ScannerDelegate
{
    
    private var scanner: Scanner?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            
            self.scanner = Scanner(withDelegate: self)
            
            guard let scanner = self.scanner else {
                return
            }
            
            scanner.requestCaptureSessionStartRunning()
        }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        // Mark - AVFoundation delegate methods
        public func metadataOutput(_ output: AVCaptureMetadataOutput,
                                   didOutput metadataObjects: [AVMetadataObject],
                                   from connection: AVCaptureConnection) {
            guard let scanner = self.scanner else {
                return
            }
            scanner.metadataOutput(output,
                                   didOutput: metadataObjects,
                                   from: connection)
        }
        
        // Mark - Scanner delegate methods
        func cameraView() -> UIView
        {
            return self.view
        }
        
        func delegateViewController() -> UIViewController
        {
            return self
        }
        
        func scanCompleted(withCode code: String)
        {
            print("QR OKUNDU :  \(code)")
        }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
