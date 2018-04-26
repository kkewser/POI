//
//  ViewController.swift
//  HelloWorld
//
//  Created by kuku_eri@yahoo.com on 4/2/18.
//  Copyright © 2018 kewser. All rights reserved.
//

import UIKit
import Firebase
import CoreML
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    // Add the model used for face recognition
    let mlModel = FaceClassifier1()
    

    
//START OF KATA's PART
    @IBOutlet weak var Camera: UIButton!
    @IBOutlet weak var PhotoLibrary: UIButton!
    @IBOutlet weak var ImageDisplay: UIImageView!
    
    @IBOutlet weak var personPic: UIImageView!
    @IBOutlet weak var imageTake: UIImageView!
    var imagePicker: UIImagePickerController!
    
    @IBAction func CameraAction(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        
        present(picker, animated: true, completion: nil)
        
    }
    
    @IBAction func PhotoLibraryAction(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary;
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    
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
    


// END OF KATA's PART
    
    
    
    
    
    
    
    var importButton:UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Import", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .black
        btn.frame = CGRect(x: 0, y: 0, width: 110, height: 60)
        btn.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height*0.90)
        btn.layer.cornerRadius = btn.bounds.height/2
        btn.tag = 0
        return btn
    }()
    
    var previewImg:UIImageView = {
        let img = UIImageView()
        img.frame = CGRect(x: 0, y: 0, width: 350, height: 350)
        img.contentMode = .scaleAspectFit
        img.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/3)
        return img
    }()
    
    var descriptionLbl:UILabel = {
        let lbl = UILabel()
        lbl.text = "No Image Content"
        lbl.frame = CGRect(x: 0, y: 0, width: 350, height: 50)
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/1.5)
        return lbl
    }()
    
    //MARK:properties
    
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var nametextfield: UITextField!
    var ref: DatabaseReference?
    
    var url:String?
    var vurl:URL?
    var retrievename: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        importButton.addTarget(self, action: #selector(importFromCameraRoll), for: .touchUpInside)
        // For the image
        self.view.addSubview(previewImg)
        // Label for  the name
        self.view.addSubview(descriptionLbl)
        // button to recognize the image
        self.view.addSubview(importButton)
        
        
        // Get a reference to the storage service using the default Firebase App
       // set the database reference
         ref = Database.database().reference()
         ref?.child("Kewser").observe(.childAdded, with: { (snapshot) in
            
         //   var name="name"
         //   var image="image"
        //  var record="record"
           
            if (( image.elementsEqual(snapshot.key)) == true){
                self.url=snapshot.value as? String
            }
            else if ((name.elementsEqual(snapshot.key)) == true){
                // retrieve the name of a child
                self.retrievename = snapshot.value as? String
                
            }
            else {
                self.vurl = snapshot.value as? URL
            }
          
        })
      
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Imoprt the image to predect it
  /*  @objc func importFromCameraRoll() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }*/
    
    
    // Predict the image and gives the name of the person
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
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
    @IBAction func showMessage(sender: UIButton){
        
        if let urls = URL(string: url!){
            
            do {
                let data = try Data(contentsOf: urls)
                self.imageview.image = UIImage(data: data)
                
            }catch let err {
                print(" Error : \(err.localizedDescription)")
            }
            
            
        }
        //ref?.child("cargiver1").childByAutoId().setValue("hello")
        let alertController = UIAlertController(title: " Welcome to The First Step",message: retrievename,preferredStyle:UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title:"OK",style:UIAlertActionStyle.default,handler: nil))
        present(alertController, animated: true,completion: nil)
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
