//
//  ViewController.swift
//  ImagePicker
//
//  Created by Taof on 12/3/19.
//  Copyright © 2019 Taof. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Picture"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(selectedImage))
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
    }
    
    // MARK: - Chọn ảnh
    @objc func selectedImage(){
        let alert = UIAlertController(title: "My App", message: "Chọn ảnh từ", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
        let camera = UIAlertAction(title: "Máy ảnh", style: .default, handler: { (_) in
            self.fromCamera()
        })
        let libray = UIAlertAction(title: "Thư viện", style: .default, handler: { (_) in
            self.fromLibrary()
        })
        
        alert.addAction(camera)
        alert.addAction(libray)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    func confirm(message: String, viewController: UIViewController?, success: @escaping () -> Void){
        let alert = UIAlertController(title: "My App", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            success()
        }
        alert.addAction(action)
        
        viewController?.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Open setting photos của hệ điều hành
    func setting(){
        let message = "App cần truy cập máy ảnh và thư viện của bạn. Ảnh của bạn sẽ không được chia sẻ khi chưa được phép của bạn."
        confirm(message: message, viewController: self) {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.openURL(settingsUrl)
                } else {
                    UIApplication.shared.openURL(settingsUrl)
                }
            }
        }
    }
    
    // MARK: - Lấy ảnh từ thư viện
    private func fromLibrary(){
        func choosePhoto(){
            DispatchQueue.main.async {
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                self.imagePicker.modalPresentationStyle = .popover
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        
        // khai báo biến để lấy quyền truy cập
        let status = PHPhotoLibrary.authorizationStatus()
        if (status == PHAuthorizationStatus.authorized) {
            // quyền truy cập đã được cấp
            choosePhoto()
        }else if (status == PHAuthorizationStatus.denied) {
            // quyền truy cập bị từ chối
            setting()
        }else if (status == PHAuthorizationStatus.notDetermined) {
            // quyền truy cập chưa được xác nhận
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                if (newStatus == PHAuthorizationStatus.authorized) {
                    choosePhoto()
                }else {
                    print("Không được cho phép truy cập vào thư viện ảnh")
                    DispatchQueue.main.async {
                        self.setting()
                    }
                }
            })
        }else if (status == PHAuthorizationStatus.restricted) {
            // Truy cập bị hạn chế, thông thường sẽ không xảy ra
            setting()
        }
    }
    
    // MARK: - Lấy ảnh từ camera
    private func fromCamera(){
        func takePhoto(){
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                DispatchQueue.main.async {
                    self.imagePicker.allowsEditing = false
                    self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                    self.imagePicker.cameraCaptureMode = .photo
                    self.imagePicker.cameraDevice = .front
                    self.imagePicker.modalPresentationStyle = .fullScreen
                    self.present(self.imagePicker, animated: true,completion: nil)
                }
            }else{
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Thông báo", message: "Không tìm thấy máy ảnh", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        //Camera
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                takePhoto()
            } else {
                print("camera denied")
                self.setting()
            }
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("error: \(info)")
            return
        }
        self.photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
}
