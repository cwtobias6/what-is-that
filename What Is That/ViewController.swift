//
//  ViewController.swift
//  What Is That
//
//  Created by Christian Tobias on 11/6/17.
//  Copyright © 2017 Christian Tobias. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var classifier: UILabel! // MARK: TODO: Use autolayout to center this on all devices!!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        
    }
}

