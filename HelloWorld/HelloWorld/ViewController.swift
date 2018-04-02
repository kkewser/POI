//
//  ViewController.swift
//  HelloWorld
//
//  Created by kuku_eri@yahoo.com on 4/2/18.
//  Copyright © 2018 kewser. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func showMessage(sender: UIButton){
        let alertController = UIAlertController(title: " Welcome to My First App",message: "HelloWorld",preferredStyle:UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title:"OK",style:UIAlertActionStyle.default,handler: nil))
        present(alertController, animated: true,completion: nil)
    }

}

