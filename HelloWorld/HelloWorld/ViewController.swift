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
  /*  let mlModel = FaceClassifier1()
    
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
  */
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
      /*  importButton.addTarget(self, action: #selector(importFromCameraRoll), for: .touchUpInside)
        // For the image
        self.view.addSubview(previewImg)
        // Label for  the name
        self.view.addSubview(descriptionLbl)
        // button to recognize the image
        self.view.addSubview(importButton)
        
       */
        // Get a reference to the storage service using the default Firebase App
       // set the database reference
         ref = Database.database().reference()
        ref?.child("Kewser").observe(.childAdded, with: { (snapshot) in
            
           var name="name"
           var image="image"
           // var record="record"
           
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
   /* @objc func importFromCameraRoll() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
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
    }*/
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
/*extension UIImage {
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
*/
