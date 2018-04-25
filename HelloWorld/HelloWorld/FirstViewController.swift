//
//  FirstViewController.swift
//  HelloWorld
//
//  Created by kuku_eri@yahoo.com on 4/17/18.
//  Copyright © 2018 kewser. All rights reserved.
//

import UIKit
import Firebase

class FirstViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Name of the caregiver is signed to name
    var nameOfCaregiver:String?
    
    // Button to return back to main view
    @IBOutlet weak var Back: UIButton!
    
    //Button to send the detected name to database
    @IBOutlet weak var Send: UIButton!
    
    // Caregive image
    @IBOutlet weak var caregiverImage: UIImageView!
    
    // Caregiver name from label
    @IBOutlet weak var nameCaregiver: UILabel!
    
    // The trained core model for face recognition
    let mlModel = FaceClassifier1()
    
    // reference to Database
    var reference: DatabaseReference?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
   
    // Send the name to Firebase
    @IBAction func SendToDataBase(_ sender: Any) {
        reference?.child("Result").setValue(nameOfCaregiver);
    }
    
    // Back to the main view
    @IBAction func BackToTakePhotp(_ sender: Any) {
        self.performSegue(withIdentifier: "BackToPhoto", sender: self)
    }

    override func viewDidAppear(_ animated: Bool)
    {
       
        // reference to the project database
        reference = Database.database().reference()
        // Caregiver face image is assgined to UIimage
        caregiverImage.image = imageToFR
                // check if we recieve a face image if not ask the caregiver to take another one
                if ( imageToFR == nil)
                    {
                            nameCaregiver.text = "Unable To Recognize:Take a photo again"
                            print("There is no picture")
                    }
                else
                    {        // if yes we apply Face Recogniation model and recognize the caregiver
                            if let buffer = imageToFR.buffer(with: CGSize(width:224, height:224))
                            {
                                guard let prediction = try? mlModel.prediction(image: buffer) else {fatalError("Unexpected runtime error")}
                                
                                let predecitname:String = prediction.facerecognition
                                
                                let probability:Double = prediction.facerecognitionProbability[predecitname]!
                                // Fail the prediction if the propability is less than 0.85 ( This percentage need to be set after testing)
                                    if probability < 0.90
                                    {
                                        nameCaregiver.text = " Unable To Recognize:Take a photo again "
                                        nameOfCaregiver=nameCaregiver.text
                                    }
                                    else
                                    {
                                        nameCaregiver.text = prediction.facerecognition
                                        nameOfCaregiver=nameCaregiver.text
                                    }
                                print(prediction.facerecognitionProbability)
                            }
                            else
                            {
                                print("failed buffer")
                            }
                }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
}
extension UIImage {
    func buffer(with size:CGSize) -> CVPixelBuffer? {
        if let image = self.cgImage {
            let frameSize = size
            var pixelBuffer:CVPixelBuffer? = nil
            let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(frameSize.width), Int(frameSize.height), kCVPixelFormatType_32BGRA , nil, &pixelBuffer)
            if status != kCVReturnSuccess {
                return nil
            }
            CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags.init(rawValue: 0))
            let data = CVPixelBufferGetBaseAddress(pixelBuffer!)
            let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
            let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)
            let context = CGContext(data: data, width: Int(frameSize.width), height: Int(frameSize.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: bitmapInfo.rawValue)
            context?.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height))
            CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
            
            return pixelBuffer
        }else{
            return nil
        }
    }
}

/* var previewImg:UIImageView = {
 let img = UIImageView()
 img.frame = CGRect(x: 0, y: 0, width: 350, height: 350)
 img.contentMode = .scaleAspectFit
 img.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/3)
 return img
 }()
 */
/*  var descriptionLbl:UILabel = {
 let lbl = UILabel()
 lbl.text = "No Image Content"
 lbl.frame = CGRect(x: 0, y: 0, width: 350, height: 50)
 lbl.textColor = .black
 lbl.textAlignment = .center
 lbl.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/1.5)
 return lbl
 }()
 */
// importButton.addTarget(self, action: #selector(importFromCameraRoll), /for: .touchUpInside)
// self.view.addSubview(previewImg)
// Label for  the name
// self.view.addSubview(descriptionLbl)
// button to recognize the image
//self.view.addSubview(importButton)
// Declaring the firebase reference'
/*  @objc func importFromCameraRoll() {
 if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
 let imagePicker = UIImagePickerController()
 imagePicker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
 imagePicker.sourceType = .photoLibrary;
 imagePicker.allowsEditing = true
 self.present(imagePicker, animated: true, completion: nil)
 }
 }*/
// Predict the image and gives the name of the person
/*  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
 if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
 previewImg.image = image
 if let buffer = image.buffer(with: CGSize(width:224, height:224)) {
 guard let prediction = try? mlModel.prediction(image: buffer) else {fatalError("Unexpected runtime error")}
 descriptionLbl.text = prediction.facerecognition
 print(prediction.facerecognitionProbability)
 }else{
 print("failed buffer")
 }
 }
 dismiss(animated:true, completion: nil)
 }
 
 
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */
/*var importButton:UIButton = {
 let btn = UIButton(type: .system)
 btn.setTitle("Send", for: .normal)
 btn.setTitleColor(.white, for: .normal)
 btn.backgroundColor = .black
 btn.frame = CGRect(x: 0, y: 0, width: 110, height: 60)
 btn.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height*0.90)
 btn.layer.cornerRadius = btn.bounds.height/2
 btn.tag = 0
 return btn
 }()
 */

