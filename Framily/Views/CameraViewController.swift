//
//  MusicViewController.swift
//  CustomSideMenuiOSExample
//
//  Created by John Codeos on 2/9/21.
//

import UIKit
import Vision
import AVFoundation

class CameraViewController: UIViewController {
    @IBOutlet var sideMenuBtn: UIBarButtonItem!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var scanButton: UIButton!
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var imagePicker: UIImagePickerController!
    var photoOutput: AVCapturePhotoOutput!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BackgroundManager.shared.backgroundColor
        self.sideMenuBtn.target = revealViewController()
        self.sideMenuBtn.action = #selector(self.revealViewController()?.revealSideMenu)
        setupCameraView()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.revealViewController()?.gestureEnabled = false
        captureSession.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.revealViewController()?.gestureEnabled = true
        captureSession.stopRunning()
    }
    func setupCameraView() {
        captureSession = AVCaptureSession()

        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            fatalError("Unable to access camera.")
        }

        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
        } catch {
            print("Error setting up camera input:", error)
            return
        }

        photoOutput = AVCapturePhotoOutput()
        captureSession.addOutput(photoOutput)

        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.frame = cameraView.layer.bounds
        cameraView.layer.addSublayer(videoPreviewLayer)

        captureSession.startRunning()
    }

    @IBAction func galleryButtonTapped(_ sender: UIButton) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func scanButtonTapped(_ sender: UIButton) {
        guard let videoConnection = photoOutput.connection(with: .video) else {
            print("Unable to obtain video connection.")
            return
        }

        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)

        videoConnection.isEnabled = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showScannedView" {
            let scannedViewController = segue.destination as! ScannedViewController
            if let image = sender as? UIImage {
                scannedViewController.image = image
            }
            scannedViewController.delegate = self
        }
    }

}

extension CameraViewController: ScannedViewControllerDelegate {
    func didCaptureImage(_ image: UIImage) {
        performSegue(withIdentifier: "showScannedView", sender: image)
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(), let capturedImage = UIImage(data: imageData) else {
            print("Error capturing photo.")
            return
        }
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showScannedView", sender: capturedImage)
        }
    }
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true) {
            guard let image = info[.originalImage] as? UIImage else {
                print("Error selecting image from gallery.")
                return
            }
            self.performSegue(withIdentifier: "showScannedView", sender: image)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

protocol ScannedViewControllerDelegate: AnyObject {
    func didCaptureImage(_ image: UIImage)
}

class ScannedViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    var image: UIImage?
    weak var delegate: ScannedViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        recognizeText(image: image)
    }

    private func recognizeText(image: UIImage?) {
        guard let image = image else {
            print("Error: Image is nil.")
            return
        }

        guard let cgImage = image.cgImage else {
            print("Error converting image to CGImage.")
            return
        }

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { [weak self] request, error in
            if let error = error {
                print("Error recognizing text:", error)
                return
            }

            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                print("No text recognized.")
                return
            }

            let text = observations.compactMap({ $0.topCandidates(1).first?.string }).joined(separator: " ")
            DispatchQueue.main.async {
                self?.label.text = text
            }
        }

        do {
            try handler.perform([request])
        } catch {
            print("Error performing text recognition:", error)
        }
    }
}

