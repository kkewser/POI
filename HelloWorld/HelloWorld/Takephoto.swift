//  ViewController.swift
//  TakePhoto
//
//  Created by Katariina Martikainen on 12/04/2018.
//  Copyright © 2018 Kata-M. All rights reserved.
//

import UIKit
import CoreImage

class Takephoto: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    @IBOutlet weak var PhotoLibrary: UIButton!
    @IBOutlet weak var Camera: UIButton!
    
    @IBOutlet weak var ImageDisplay: UIImageView!

    
    @IBOutlet weak var personPic: UIImageView!
    @IBOutlet weak var imageTake: UIImageView!
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func PhotoLibraryAction(_ sender: UIButton) {
         let picker = UIImagePickerController()
         picker.delegate = self
         picker.sourceType = .photoLibrary
 
        present(picker, animated: true, completion: nil)
    }
    
    
    
    @IBAction func CameraAction(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        
        present(picker, animated: true, completion: nil)
    }
    
    
    
//    @IBAction func PhotoLibraryAction(_ sender: UIButton) {
 /*       let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
   */
  //      present(picker, animated: true, completion: nil)
 //   }
    
 /*   @IBAction func CameraAction(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        
        present(picker, animated: true, completion: nil)
    } */
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let chosenImageView = UIImageView();
        chosenImageView.image = chosenImage
        // personPic.image = chosenImage
        
        print(":D")
        detect(_uiimageView: chosenImageView)
        print("detect")
        dismiss(animated:true, completion: nil)
        print("CONGRATULATION YOU FINISHED GOAL")
        
        
    }
    //new part below
    func detect(_uiimageView:UIImageView) {
        
        guard let personciImage = CIImage(image: _uiimageView.image!) else {
            return
        }
        print("personciImage")
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        print("accuacy")
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in: personciImage)
        print("faces")
        // For converting the Core Image Coordinates to UIView Coordinates
        let ciImageSize = personciImage.extent.size
        var transform = CGAffineTransform(scaleX: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -ciImageSize.height)
        // transform = CGAffineTransformTranslate(transform, 0, -ciImageSize.height)
        print("transform")
        for face in faces as! [CIFaceFeature] {
            
            print("Found bounds are \(face.bounds)")
            
            // Apply the transform to convert the coordinates
            var faceViewBounds = face.bounds.applying(transform)
            print("faceViewBounds after transformation are \(faceViewBounds)")
            
            
            //------------
            //Placing coordinates to Rect for cropping
            let xF = faceViewBounds.minX
            let yF = faceViewBounds.minY
            let widthF = faceViewBounds.width * 0.95
            let heightF = faceViewBounds.height * 0.95
            let rect = CGRect(x:xF,y: yF, width: widthF, height:heightF)
            print("Got past initialization of rect")
            print("x: \(xF)")
            print("y: \(yF)")
            print("width: \(widthF)")
            print("height: \(heightF)")
            //------------
            // Calculate the actual position and size of the rectangle in the image view
            /*let viewSize = _uiimageView.bounds.size
             let scale = min(viewSize.width / ciImageSize.width,
             viewSize.height / ciImageSize.height)
             let offsetX = (viewSize.width - ciImageSize.width * scale) / 2
             let offsetY = (viewSize.height - ciImageSize.height * scale) / 2
             let biggerY = offsetY * 0.5
             let biggerX = offsetX * 0.75
             
             faceViewBounds = faceViewBounds.applying(CGAffineTransform(scaleX: scale, y: scale))
             faceViewBounds.origin.x += biggerX
             faceViewBounds.origin.y += biggerY
             
             let faceBox = UIView(frame: faceViewBounds)
             print("faceBox")
             faceBox.layer.borderWidth = 3
             faceBox.layer.borderColor = UIColor.red.cgColor
             faceBox.backgroundColor = UIColor.clear
             _uiimageView.addSubview(faceBox)
             */
            //---------
            
            
            
            if face.hasLeftEyePosition {
                print("Left eye bounds are \(face.leftEyePosition)")
            }
            
            if face.hasRightEyePosition {
                print("Right eye bounds are \(face.rightEyePosition)")
            }
            
            // let rect = CGRect(x:85.0,y: 333.0,width: 372.0,height: 372.0)
            // print("Got past initialization of rect")
            
            let croppedPhoto = crop(image: _uiimageView.image!, cropRect: rect)
            print("Got past let croppedPhoto and CROP")
            ImageDisplay.image = croppedPhoto
            
            print("Got past ImageDisplay")
            //save(croppedPhoto!)
            
        }
    }
    
    
    
    func crop(image:UIImage, cropRect:CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(cropRect.size, false, image.scale)
        let origin = CGPoint(x: cropRect.origin.x * CGFloat(-1), y: cropRect.origin.y * CGFloat(-1))
        image.draw(at: origin)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return result
    }
    
    //MARK: - Take image
    @IBAction func takePhoto(_ sender: UIButton) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - Saving Image here
    @IBAction func save(_ sender: AnyObject) {
        UIImageWriteToSavedPhotosAlbum(imageTake.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
}

