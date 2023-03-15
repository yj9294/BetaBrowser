//
//  CameraUtil.swift
//  BetaBrowser
//
//  Created by yangjian on 2023/3/14.
//

import UIKit
import AVFoundation

class CameraUtil: NSObject, AVCapturePhotoCaptureDelegate {
    static let share = CameraUtil()
    var picData = Data(count: 0)
    var image: UIImage? = nil
    var orientation: UIImage.Orientation = .up
    var session = AVCaptureSession()
    var output = AVCapturePhotoOutput()
    var preview : AVCaptureVideoPreviewLayer!
    var completion: ((Bool)->Void)? = nil
    func requestPermission(completion: @escaping (Bool)-> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            setUp()
            completion(true)
        case .notDetermined:
//            FirebaseManager.logEvent(name: .permissionShow)
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                DispatchQueue.main.async{
                    if status == true {
//                        FirebaseManager.logEvent(name: .permissionAgree)
                        self.setUp()
                    }
                    completion(status)
                }
            }
        case .denied:
            completion(false)
        default:
            completion(false)
        }
    }
    
    func setUp(){
        do{
            self.session.beginConfiguration()
            let decive = AVCaptureDevice.default(for: .video)
            let input = try AVCaptureDeviceInput(device: decive!)
            if self.session.canAddInput(input) {
                self.session.addInput(input)
            }
            if self.session.canAddOutput(self.output){
                self.session.addOutput(self.output)
            }
            self.session.commitConfiguration()
        } catch{
            print(error.localizedDescription)
        }
    }
    
    func takePic(completion: @escaping (Bool)->Void){
        self.completion = completion
        DispatchQueue.global(qos: .background).async {
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        }
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.2) {
            self.session.stopRunning()
        }
    }
    
    func reTake(){
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
        }
    }
    
    func stop() {
        DispatchQueue.global(qos: .background).async {
            self.session.stopRunning()
        }
    }
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        self.picData = Data(count: 0)
        self.image = nil
        if error != nil{
            DispatchQueue.main.async {
                self.completion?(false)
            }
            return
        }
        guard let imageData = photo.fileDataRepresentation() else {
            DispatchQueue.main.async {
                self.completion?(false)
            }
            return
        }
        self.picData = imageData
        var orientation: UIImage.Orientation
        switch UIDevice.current.orientation {
        case .portrait, .faceUp:
            orientation = .right
        case .portraitUpsideDown, .faceDown:
            orientation = .left
        case .landscapeLeft:
            orientation = .up
        case .landscapeRight:
            orientation = .down
        default:
            orientation = .up
        }
        self.orientation = orientation
        self.image = UIImage(data: picData)
        if self.image != nil {
            DispatchQueue.main.async {
                self.completion?(true)
            }
        } else {
            DispatchQueue.main.async {
                debugPrint("[TR] 图片失败")
                self.completion?(false)
            }
        }
    }
}
