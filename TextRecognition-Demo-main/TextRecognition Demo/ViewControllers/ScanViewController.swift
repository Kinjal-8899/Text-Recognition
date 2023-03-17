//
//  ScanViewController.swift
//  TextRecognition Demo
//
//  Created by Harindra Pittalia on 08/03/22.
//

import UIKit

class ScanViewController: UIViewController {
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private lazy var cameraService = CameraService()
    private var cameraInited = false
    
    private enum ButtonState { case cancel, takePhoto }
    private var buttonState = ButtonState.takePhoto {
        didSet {
            switch buttonState {
                case .takePhoto: btn.setTitle("Take a photo", for: .normal)
                case .cancel: btn.setTitle("Cancel", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.layer.cornerRadius = 15
        activityIndicator.layer.borderColor = UIColor.white.cgColor
        activityIndicator.layer.borderWidth = 3
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setCamera()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.cameraService.stop()
    }

    // Ensure that the interface stays locked in Portrait.
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    // Ensure that the interface stays locked in Portrait.
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    @IBAction func nextBtnPressed(_ sender: UIButton) {
        let aVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    @IBAction func btnPressed(_ sender: UIButton) {
        activityIndicator.startAnimating()
        switch buttonState {
        case .takePhoto:
            showActivityIndicatory()
            cameraService.capturePhoto { [weak self] image, text in
                guard let self = self else {return }
                self.removeActivityIndicatory()
                self.cameraService.stop()
                self.buttonState = .cancel
                DispatchQueue.main.async {
                    self.show(image: image, text: text)
                }
            }
        case .cancel:
            buttonState = .takePhoto
            setCamera()
        }
    }
}

extension ScanViewController {
    
    func setCamera() {
        activityIndicator.isHidden = true
        previewView.isHidden = false
        imageView.isHidden = true
        textView.isHidden = true
        nextBtn.isHidden = true
        buttonState = .takePhoto
        cameraService.prepare(previewView: previewView, cameraPosition: .back) { [weak self] success in
            if success {
                self?.cameraService.start()
            }
        }
    }
    
    func show(image: UIImage, text: String) {
        removeActivityIndicatory()
        previewView.isHidden = false
        imageView.isHidden = true
        textView.isHidden = false
        nextBtn.isHidden = false
        imageView.image = image
        textView.text = text
    }
}


extension ScanViewController {
    func showActivityIndicatory() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func removeActivityIndicatory() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
}
