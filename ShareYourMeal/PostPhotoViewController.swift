//
//  PostPhotoViewController.swift
//  ShareYourMeal
//
//  Created by Tracy on 3/29/15.
//  Copyright (c) 2015 Tracy. All rights reserved.
//

import UIKit

class PostPhotoViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{ 

    
    //var pickedImage : UIImage!
    
    var image : UIImage!
    
    @IBOutlet var pickedImage: UIImageView!
    
    @IBOutlet weak var text: UITextField!
    
    
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
    


    @IBAction func sentPhoto(sender: AnyObject) {
            
            println("hi")
            
            var post = PFObject(className: "Post")
            
            post["username"] = PFUser.currentUser().username
            
            post["descrptionOfPhoto"] = text.text
            
            let imageData = UIImagePNGRepresentation(image)
            
            let imageFile = PFFile(name:"image.png", data: imageData)
            
            post["imageFile"] = imageFile
            
            
            post.saveInBackgroundWithBlock{
                
                (success: Bool! , error : NSError!) -> Void in
                
                if success == false {
                    
                    self.displayAlert("Could Not Post Image", error : "Please try again later")
                    
                }else{
                    
                    println("posted successfully")
                }
                
            }
            
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

         pickedImage.image = image
        
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
