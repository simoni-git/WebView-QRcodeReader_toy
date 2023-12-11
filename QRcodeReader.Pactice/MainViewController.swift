//
//  ViewController.swift
//  QRcodeReader.Pactice
//
//  Created by 시모니 on 12/11/23.
//

import UIKit
import WebKit
import AVFoundation
import QRCodeReader

class MainViewController: UIViewController , QRCodeReaderViewControllerDelegate {
   
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var qrcodeBtn: UIButton!
    
    //⬇️ QR코드 리더 뷰컨트롤러 만드는 오픈소스
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            
            // Configure the view controller (optional)
            $0.showTorchButton        = false
            $0.showSwitchCameraButton = false
            $0.showCancelButton       = false
            $0.showOverlayView        = true
            $0.rectOfInterest         = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        qrcodeBtn.layer.borderWidth = 3
        qrcodeBtn.layer.borderColor = UIColor.blue.cgColor
        qrcodeBtn.layer.cornerRadius = 10
        qrcodeBtn.addTarget(self, action: #selector(qrcodeReaderLaunch), for: .touchUpInside)
    }
   
    @objc fileprivate func qrcodeReaderLaunch() {
        print("MainViewController 에서  qrcodeReaderLaunch() 가 호출되었다. ")
          readerVC.delegate = self
          readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            print(result)
              
              guard let scannedURLString = result?.value else {return}
              print("scannedURLString--> \(scannedURLString)")
              
              let scannedURL = URL(string: scannedURLString)
              self.webView.load(URLRequest(url: scannedURL!))
              
          }
         
          readerVC.modalPresentationStyle = .formSheet
          present(readerVC, animated: true, completion: nil)
    }
    
    //MARK: - QR코드 리더 델리겟 메서드
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        //오픈소스에 있는거임
        reader.stopScanning()
          dismiss(animated: true, completion: nil)
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        //오픈소스에 있는거임
        reader.stopScanning()
         dismiss(animated: true, completion: nil)
    }
    
   

}

