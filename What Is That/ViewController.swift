//
//  ViewController.swift
//  What Is That
//
//  Created by Christian Tobias on 11/6/17.
//  Copyright © 2017 Christian Tobias. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    var model: Inceptionv3!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        model = Inceptionv3()
    }

    @IBAction func openCamera(_ sender: Any) {
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }
        
        let cameraImagePicker = UIImagePickerController()
        
        cameraImagePicker.delegate = self
        cameraImagePicker.sourceType = .camera
        cameraImagePicker.allowsEditing = false
        
        present(cameraImagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func openLibrary(_ sender: Any) {
        
        let photoLibraryPicker = UIImagePickerController()
        
        photoLibraryPicker.delegate = self
        photoLibraryPicker.sourceType = .photoLibrary
        photoLibraryPicker.allowsEditing = false
        
        present(photoLibraryPicker, animated: true, completion: nil)
    }
    
}

extension ViewController: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        imagePickerControllerDidCancel(picker)
        
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageView.image = userPickedImage
            
            guard let convertedCIImage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert user picked image into CIIMage")
            }
            
            detect(image: convertedCIImage)
            
        }
        
        
    }
    
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("CoreML Model Failed to load")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model Failed to Process Image.")
            }
            
            let classification = request.results?.first as? VNClassificationObservation
            
            self.navigationItem.title = classification?.identifier.capitalized
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
            
        } catch {
            print(error)
        }
        
        
    }
    
    
    
}
