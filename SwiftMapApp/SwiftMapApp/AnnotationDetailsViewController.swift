//
//  AddToDoViewController.swift
//  WhereToDo
//
//  Created by Rodrigo Borges Soares on 09/10/14.
//  Copyright (c) 2014 Rodrigo Borges. All rights reserved.
//

import UIKit

class AnnotationDetailsViewController: UIViewController {

    @IBOutlet weak var descriptionTextField: UITextField!
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func addButtonPressed(sender: UIButton) {
        
        let mainDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        var insertionResult: Bool = mainDelegate.databaseHandler.insertAnnotation(self.descriptionTextField.text, latitude: latitude, longitude: longitude)

        if !insertionResult {
            NSLog("Error while insertin annotation")
        }
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
