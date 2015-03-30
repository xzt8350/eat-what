//
//  UserTableViewController.swift
//  ShareYourMeal
//
//  Created by Tracy on 3/28/15.
//  Copyright (c) 2015 Tracy. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    var refresher : UIRefreshControl!
    
    var users = [""]

    var image : UIImage!
    
    
    var picker:UIImagePickerController?=UIImagePickerController()
    var popover:UIPopoverController?=nil
    
   
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!)
    {
        
        println("did pick")
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        
        image = info[UIImagePickerControllerOriginalImage] as UIImage
     
    
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc : PostPhotoViewController = mainStoryboard.instantiateViewControllerWithIdentifier("vc2") as PostPhotoViewController
        
        vc.image = image
        
        self.presentViewController(vc, animated: true, completion: nil)

        
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!)
    {
        println("picker cancel.")
    }
    

    
    @IBAction func PhotoActionSheet(sender: AnyObject) {
        
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        println(PFUser.currentUser())
        
        var query = PFUser.query()
        
        query.findObjectsInBackgroundWithBlock({ (objects:[AnyObject]!, error: NSError!) -> Void in
            
            self.users.removeAll(keepCapacity:true)
            
            for object in objects {
                
                var user:PFUser = object as PFUser
                
                self.users.append(user.username)
                
            }
            
            self.tableView.reloadData()
            
            
        })
        
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pill to refresh")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refresher)


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    func refresh(){
        //println("refreshed")
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
        return users.count
    }
 
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell

        // Configure the cell...
        cell.textLabel?.text = users[indexPath.row]
        
        return cell

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
