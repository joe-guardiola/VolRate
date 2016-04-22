//
//  OrganizationDetailViewController.swift

import UIKit

class OrganizationDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var organizationImageView:UIImageView!
    @IBOutlet var tableView:UITableView!
    @IBOutlet var ratingButton:UIButton!
    
    var organization:Organization!

    override func viewDidLoad() {
        super.viewDidLoad()

        organizationImageView.image = UIImage(data: organization.image!)
        
        // change color of table
        tableView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.2)
        
        // remove empty rows
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        // change color of row seperators
        tableView.separatorColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)
        
        // set title
        title = organization.name
        
        // auto resize cells
        tableView.estimatedRowHeight = 36.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if let rating = organization.rating {
            ratingButton.setImage(UIImage(named: rating), forState: .Normal)
        }
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! OrganizationDetailTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = "Name"
            cell.valueLabel.text = organization.name
        case 1:
            cell.fieldLabel.text = "Type"
            cell.valueLabel.text = organization.type
        case 2:
            cell.fieldLabel.text = "Location"
            cell.valueLabel.text = organization.location
        case 3:
            cell.fieldLabel.text = "Phone"
            cell.valueLabel.text = organization.phoneNumber
        case 4:
            cell.fieldLabel.text = "Been here"
            if let isVisited = organization.isVisited?.boolValue {
                cell.valueLabel.text = isVisited ? "Yes, I've been here before" : "No"
            }
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }
        
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    @IBAction func close(segue:UIStoryboardSegue) {
        if let reviewViewController = segue.sourceViewController as? ReviewViewController {
            if let rating = reviewViewController.rating where rating != "" {
                organization.rating = rating
                ratingButton.setImage(UIImage(named: rating), forState: .Normal)
                
                if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
                    do {
                        try managedObjectContext.save()
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMap" {
            let destinationViewController = segue.destinationViewController as! MapViewController
            destinationViewController.organization = organization
        }
    }

}
