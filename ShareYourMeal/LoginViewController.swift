//
//  LoginViewController.swift
//  ShareYourMeal
//
//  Created by Tracy on 3/28/15.
//  Copyright (c) 2015 Tracy. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
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

    
    @IBOutlet var usernameOrEmail: UITextField!
    @IBOutlet var password: UITextField!
    

    @IBAction func SignIn(sender: AnyObject) {
        
        var error = ""
        
        if(usernameOrEmail.text == ""){
            error = "Please enter your username or eamil"
            displayAlert("Error in Form", error: error)
        }
        else if (password.text == ""){
            error = "Please enter your password"
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
            user.username = usernameOrEmail.text
            user.password = password.text
           
            PFUser.logInWithUsernameInBackground(usernameOrEmail.text, password:password.text) {
                (user: PFUser!, loginError: NSError!) -> Void in
                
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                
                if loginError == nil {
                    // Do stuff after successful login.
                    
                    println("logged in")
                    
                    
                } else {
                    // The login failed. Check error to see why.
                    
                    if let errorString =  loginError.userInfo?["error"] as? NSString {
                        
                        // Update - added as! String
                        
                        error = errorString
                        
                    } else {
                        
                        error = "Please try again later."
                        
                    }
                    
                    self.displayAlert("Could Not Log in", error: error)

                    
                    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
