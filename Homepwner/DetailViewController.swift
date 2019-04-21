//
//  DetailViewController.swift
//  Homepwner
//
//  Created by AJMac on 4/16/19.
//  Copyright © 2019 AJMac. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imageStore: ImageStore!
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var serialNumberField: UITextField!
    @IBOutlet var valueField: UITextField!
    
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var imageView: UIImageView!
    
    
    
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        
        //If the device has a camera, take a picture; otherwise, pick from library
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        }else {
            imagePicker.sourceType = .photoLibrary
        }
        imagePicker.delegate = self
        
        //place image picker on the screen
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    
    @IBAction func deletePicture(_ sender: UIBarButtonItem) {
        
        //Get Key of Item
        let key = item.itemKey
        
        
        //Confirm Delete
        let title = "Delete Photo?"
        let message = "Are you sure you want to delete this item?"
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
            
            //remove the image from the image store
            self.imageStore.deleteImage(forKey: key)
            
            self.imageView.image = nil
            
        })
        ac.addAction(deleteAction)
        
        //present Alert Controller
        present(ac, animated: true, completion: nil)
    
        
    }

    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameField.text = item.name
        serialNumberField.text = item.serialNumber
        valueField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
        dateLabel.text = dateFormatter.string(from: item.dateCreated)
        
        //Get the item key
        let key = item.itemKey
        
        //If there is an image for the item display it in the image view
        let imageToDisplay = imageStore.image(forKey: key)
        imageView.image = imageToDisplay
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        
        //Save changes to item
        item.name = nameField.text ?? ""
        item.serialNumber = serialNumberField.text
        
        if let valueText = valueField.text,
            let value = numberFormatter.number(from: valueText) {
            item.valueInDollars = value.intValue
        }else{
            item.valueInDollars = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func backgroundtapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //Get picked image from info dictionary
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //Store the image in the ImageStore for the item's key
        imageStore.setImage(image, forKey: item.itemKey)
        
        //Put the image on the screen in the image view
        imageView.image = image
        
        //Tale the image picker off the screen
        //you must call this dismiss method
        dismiss(animated: true, completion: nil)
        
    }
}
