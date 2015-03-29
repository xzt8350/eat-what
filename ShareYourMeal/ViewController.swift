//
//  ViewController.swift
//  ShareYourMeal
//
//  Created by Tracy on 3/28/15.
//  Copyright (c) 2015 Tracy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    /* @ Display Alert of the error
     *
     */
    func displayAlert(title:String, error:String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var email: UITextField!
    
    
    @IBAction func joinNow(sender: AnyObject) {
        
        var error = ""
        
        if(username.text == ""){
            error = "Please enter your username"
            displayAlert("Error in Form", error: error)
        }
        else if (password.text == ""){
            error = "Please enter your password"
            displayAlert("Error in Form", error: error)
            
        }
        else if (email.text == ""){
            error = "Please enter your email"
            displayAlert("Error in Form", error: error)
        }
        else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()

            
            var user = PFUser()
            user.username = username.text
            user.password = password.text
            user.email = email.text
            
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool!, signupError: NSError!) -> Void in
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if signupError == nil  {
                    // Hooray! Let them use the app now.
                    
                    println("signed up")
                    
                    
                    
                } else {
                    if let errorString = signupError.userInfo?["error"] as? NSString {
                        
                        // Update - added as! String
                        
                        error = errorString
                        
                    } else {
                        
                        error = "Please try again later."
                        
                    }
                    
                    self.displayAlert("Could Not Sign Up", error: error)
                    
                }
            }

            
            
        }
        
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
