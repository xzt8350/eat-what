//
//  StartPageViewController.swift
//  ShareYourMeal
//
//  Created by Tracy on 3/28/15.
//  Copyright (c) 2015 Tracy. All rights reserved.
//

import UIKit

class StartPageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
        println(PFUser.currentUser())
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
         //PFUser.logOut()
        
         println(PFUser.currentUser())
        
        if PFUser.currentUser() != nil{
            
            self.performSegueWithIdentifier("JumpToUserTable", sender: self)
        }
    }
   
}
