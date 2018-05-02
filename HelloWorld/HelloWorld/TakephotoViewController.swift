//
//  TakephotoViewController.swift
//  HelloWorld
//
//  Created by kuku_eri@yahoo.com on 4/17/18.
//  Copyright © 2018 kewser. All rights reserved.
//

import UIKit

var imageToFR:UIImage!

class TakephotoViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    //Button to for photo library
    @IBOutlet weak var PhotoLibrary: UIButton!
    //Button for camera
    @IBOutlet weak var Camera: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        imageToFR=nil
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    @IBAction func PhotoLibrary(_ sender: Any)
    {
        let picker = UIImagePickerController()
        picker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func Camera(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let chosenImageView = UIImageView();
        
       
            
        if (chosenImage.imageOrientation == UIImageOrientation.up) {
                chosenImageView.image = chosenImage
            }
         else
        {
            UIGraphicsBeginImageContextWithOptions(chosenImage.size, false, chosenImage.scale);
            let rect = CGRect(x: 0, y: 0, width: chosenImage.size.width, height: chosenImage.size.height)
            chosenImage.draw(in: rect)
            
            let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext();
             chosenImageView.image = normalizedImage;
        }
       // chosenImageView.image = chosenImage
        
        // To let the detect function return before continuing with the next line
        let dispatchgroup = DispatchGroup()
            print(":D")
        // Enter to dispatch
        dispatchgroup.enter()
            self.detect(_uiimageView: chosenImageView)
        // imageToFR=chosenImageView.image
        // Leave from dispatch
        dispatchgroup.leave()
            print("detect")
        dispatchgroup.notify(queue: .main)
        {
            self.dismiss(animated: true, completion:
                {   // switch to second view
                    self.performSegue(withIdentifier: "Takephoto", sender: self)
                })
        }
        print("CONGRATULATION YOU FINISHED GOAL")
     
       
    
    }
    
    func detect(_uiimageView:UIImageView) {
        
        guard let personciImage = CIImage(image: _uiimageView.image!) else
        {
            return
        }
        print(_uiimageView.image)
        print(personciImage)
        print("personciImage")
      //  let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyLow]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in: personciImage)
        print(faces)
        if (faces == [])
        {
            imageToFR = _uiimageView.image
        }
        else {
                // For converting the Core Image Coordinates to UIView Coordinates
                let ciImageSize = personciImage.extent.size
                var transform = CGAffineTransform(scaleX: 1, y: -1)
                transform = transform.translatedBy(x: 0, y: -ciImageSize.height)
                ///////////////////////////////// This function  has a problem //////////////////////
    
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
     
            
                    if face.hasLeftEyePosition {
                        print("Left eye bounds are \(face.leftEyePosition)")
                    }
            
                    if face.hasRightEyePosition {
                        print("Right eye bounds are \(face.rightEyePosition)")
                    }
            
                    // let rect = CGRect(x:85.0,y: 333.0,width: 372.0,height: 372.0)
                    // print("Got past initialization of rect")
            
                    let croppedPhoto = self.crop(image: _uiimageView.image!, cropRect: rect)
                    print("Got past let croppedPhoto and CROP")
                    //ImageDisplay.image = croppedPhoto
                    imageToFR=croppedPhoto
           
           
                    print("Got past ImageDisplay")
                    //save(croppedPhoto!)
            
            }
            
        }
            print("reach here")
    }
    
    
  
    
    func crop(image:UIImage, cropRect:CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(cropRect.size, false, image.scale)
        let origin = CGPoint(x: cropRect.origin.x * CGFloat(-1), y: cropRect.origin.y * CGFloat(-1))
        image.draw(at: origin)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return result
    }
    

}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */
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

//  let im = UIImagePickerControllerOriginalImage
//  ImageDisplay.image = info[UIImagePickerControllerOriginalImage] as? UIImage;dismiss(animated: true, completion: nil)
//       print("past ImageDisplay.image")
