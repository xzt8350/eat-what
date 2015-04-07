//
//  PostPhotoViewController.swift
//  ShareYourMeal
//
//  Created by Tracy on 3/29/15.
//  Copyright (c) 2015 Tracy. All rights reserved.
//

import UIKit

class PostPhotoViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITabBarControllerDelegate{

 
    var image : UIImage!


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        
        println(image)
        
         self.performSegueWithIdentifier("JumpToPost", sender: self)

    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "JumpToPost"{
        
            var viewcontro : ReadyToPostViewController = segue.destinationViewController as ReadyToPostViewController
          
            viewcontro.image = image
            
            println("disanci")
            
            self.presentViewController(viewcontro, animated: true, completion: nil)
            
        }
        
        
        
    }
    

}
