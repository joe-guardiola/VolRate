//
//  AddOrganizationController.swift
//

import UIKit
import CoreData
import Firebase

class AddOrganizationController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var imageView:UIImageView!
    @IBOutlet var organizationNameTextField:UITextField!
    @IBOutlet var organizationTypeTextField:UITextField!
    @IBOutlet var organizationLocationTextField:UITextField!
    @IBOutlet var organizationPhoneTextField:UITextField!
    
    var myRootRef = Firebase(url:"https://volrate.firebaseio.com/Organization")
    var organizationVisited:Bool?
    var organization:Organization!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .PhotoLibrary
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // get the image
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true

        // make the constraints allow the image to fit
        
        let leadingContraint = NSLayoutConstraint(item: imageView, attribute: .Leading, relatedBy: .Equal, toItem: imageView.superview, attribute: .Leading, multiplier: 1, constant: 0)
        leadingContraint.active = true
        
        let trailingContraint = NSLayoutConstraint(item: imageView, attribute: .Trailing, relatedBy: .Equal, toItem: imageView.superview, attribute: .Trailing, multiplier: 1, constant: 0)
        trailingContraint.active = true
        
        let topContraint = NSLayoutConstraint(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: imageView.superview, attribute: .Top, multiplier: 1, constant: 0)
        topContraint.active = true
        
        let bottomConstraint = NSLayoutConstraint(item: imageView, attribute: .Bottom, relatedBy: .Equal, toItem: imageView.superview, attribute: .Bottom, multiplier: 1, constant: 0)
        bottomConstraint.active = true
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func saveOrganization(sender: UIButton) {
        var message:String?
        
        if organizationNameTextField.text?.characters.count == 0 {
            message = "You haven't provided a organization name"
        } else if organizationTypeTextField.text?.characters.count == 0 {
            message = "You haven't provided a organization type"
        } else if organizationLocationTextField.text?.characters.count == 0 {
            message = "You haven't provided a organization location"
        } else if organizationVisited == nil {
            message = "You haven't selected whether or not you visited this organization."
        }
        
        if let validationError = message {
            let alert = UIAlertController(title: "VolRate", message: validationError, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }

//       if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
//            organization = NSEntityDescription.insertNewObjectForEntityForName("Organization", inManagedObjectContext: managedObjectContext) as! Organization
//            organization.name = organizationNameTextField.text!
//            organization.type = organizationTypeTextField.text!
//            organization.location = organizationLocationTextField.text!
//            organization.phoneNumber = organizationPhoneTextField.text!
//            if let organizationImage = imageView.image {
//                organization.image = UIImagePNGRepresentation(organizationImage)
//            }
//            organization.isVisited = organizationVisited
//            
//            do {
//                try managedObjectContext.save()
//            } catch {
//                print(error)
//                return
//            }
//        }
        
        //need to add the image somehow
        let tempKey = organizationNameTextField.text! + organizationLocationTextField.text!
        let newOrgRef = myRootRef.childByAppendingPath(tempKey)
        var data:NSData = NSData()
        if let organizationImage = imageView.image {
            data = UIImageJPEGRepresentation(organizationImage,0.1)!
        }
        let base64String = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        let newOrg = ["name": organizationNameTextField.text!, "type": organizationTypeTextField.text!, "location":organizationLocationTextField.text!, "phoneNumber": organizationPhoneTextField.text!, "image": base64String, "isVisited": organizationVisited!, "rating": "rating"]
        newOrgRef.setValue(newOrg)
        
        self.performSegueWithIdentifier("unwindToHomeScreen", sender: self)
    }
    
    @IBAction func hasVolunteeredAtOrganization(sender: UIButton) {
        switch(sender.tag) {
        case 400:
            organizationVisited = true
            view.viewWithTag(400)?.backgroundColor = UIColor.blueColor()
            view.viewWithTag(500)?.backgroundColor = UIColor.grayColor()
        case 500:
            organizationVisited = false
            view.viewWithTag(500)?.backgroundColor = UIColor.blueColor()
            view.viewWithTag(400)?.backgroundColor = UIColor.grayColor()
        default: break
        }
    }
    
}
