//
//  ViewController.swift
//  HelloWorld
//
//  Created by kuku_eri@yahoo.com on 4/2/18.
//  Copyright © 2018 kewser. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
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
        // Get a reference to the storage service using the default Firebase App
       // set the database reference
        
    ref = Database.database().reference()
         ref?.child("Kewser").observe(.childAdded, with: { (snapshot) in
            
            var name="name"
            var image="image"
            var record="record"
           
            if (( image.elementsEqual(snapshot.key)) == true){
                self.url=snapshot.value as? String
            }
            else if ((name.elementsEqual(snapshot.key)) == true){
                
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

