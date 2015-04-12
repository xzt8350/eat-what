//
//  UserFeedTableViewController.swift
//  ShareYourMeal
//
//  Created by Tracy on 3/31/15.
//  Copyright (c) 2015 Tracy. All rights reserved.
//

import UIKit

class UserFeedTableViewController: UITableViewController, UITabBarControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    var picker:UIImagePickerController?=UIImagePickerController()
    var haha: PostPhotoViewController!
    
    
    var usernames = [String]()
    var images = [UIImage]()
    var imageFiles = [PFFile]()
    
    var numLikes = [Int]()
    var objectId = [String]()
    
    func tabBarController(tabBarController: UITabBarController,
        shouldSelectViewController viewController: UIViewController) -> Bool{
            
            if viewController.title == "Camera" {
                PhotoActionSheet()
                return false
            
            }
            else {
                
                return true
            }
    }

    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!)
    {
        
        println("did pick")
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        
        haha.image = info[UIImagePickerControllerOriginalImage] as UIImage
        
        
        self.tabBarController?.selectedIndex = 1;
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!)
    {
        println("picker cancel.")
        self.tabBarController?.selectedIndex = 0;
    }

    
    
    func PhotoActionSheet(){
        
        
        
        let optionMenu = UIAlertController(title: nil, message: "Choose your photo source", preferredStyle: .ActionSheet)
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .Default) {
            UIAlertAction in
            self.openCamera()
         
            
        }
        
        let chooseFromPhoto = UIAlertAction(title: "Choose from Photos", style: .Default){
            UIAlertAction in
            self.openGallary()
            
        }
        
        
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) {
            UIAlertAction in
            println("File Saved")
        }
        
        
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(chooseFromPhoto)
        optionMenu.addAction(cancel)
        
    
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    
        
        
    }
    
    
    
    func openGallary()
    {
      
        picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            picker?.delegate = self
            //println("i am here")
            self.presentViewController(picker!, animated: true, completion: nil)
            
            
        }
    }
    
    
    func openCamera()
    {
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            picker?.delegate = self
            picker!.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(picker!, animated: true, completion: nil)
        }
        else
        {
            openGallary()
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var barViewControllers = self.tabBarController?.viewControllers
        
        haha = barViewControllers![1] as PostPhotoViewController
        
        self.tabBarController?.delegate = self
        
        var query = PFQuery(className: "Post")
        
        query.findObjectsInBackgroundWithBlock{
            (objects: [AnyObject]!, error: NSError!) -> Void in
            
            if error == nil{
                
                println(objects)
                
                if objects != nil{
                
                for object in objects{
                     println(object)
                    
                    println(object["likes"])
                    
                    self.usernames.append(object["username"] as String)
                    self.imageFiles.append(object["imageFile"] as PFFile)
                    self.numLikes.append(object["numLikes"] as Int)
                    self.objectId.append(object.objectId as String)
                    
                    self.tableView.reloadData()
                }
                    
                }
                
            } else {
                println(error)
            }
            
        }
        
        
        
        self.tableView.separatorColor = UIColor.whiteColor();
        
        
        println(usernames)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        
        return usernames.count
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : PostTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("FoodCell") as PostTableViewCell
        
        // Configure the cell...
        cell.username.text = usernames[indexPath.row]
        cell.like.text = String(numLikes[indexPath.row])
  
        imageFiles[indexPath.row].getDataInBackgroundWithBlock{
            
            (imageData: NSData!, error: NSError!) -> Void in
            
            if error == nil {
                
                let foodImage = UIImage(data: imageData)
                
                cell.foodPhoto.image = foodImage
                
            }
        }
        
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: "likeButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //cell.foodPhoto.userInteractionEnabled = true
        
        return cell
    }
    
   
    
    func likeButtonClicked(sender:UIButton) {
        
        let buttonRow = sender.tag
        
        let postId = objectId[buttonRow]
        
        var postQuery = PFQuery(className: "Post")
        

        postQuery.getObjectInBackgroundWithId(postId){
            (post: PFObject!, error: NSError!) -> Void in
            
            
            if error == nil && post != nil {
                
                //Update the new number of like for this post
                
                
                var newNumLike = (post["numLikes"] as Int) + 1
                post["numLikes"] = newNumLike
                
                var newLikes = (post["likes"] as [String])
                
                newLikes.append(PFUser.currentUser().username)
                post["likes"] = newLikes
                
                
                post.saveInBackground()
                
            } else {
                println(error)
            }
            
            
        }
        
    
    }
    
    
    @IBAction func handleTap(sender: UITapGestureRecognizer) {
        sender.numberOfTapsRequired = 2
        
        
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
