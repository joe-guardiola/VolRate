//

import UIKit
import CoreData
import Firebase

class OrganizationTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
    var organizations:[Organization] = []
    var fetchResultController:NSFetchedResultsController!

    var searchController:UISearchController!
    var results:[Organization] = []
    
    
    var myRootRef = Firebase(url:"https://volrate.firebaseio.com/Organization")
    //let dataSource: FirebaseTableDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let fetchRequest = NSFetchRequest(entityName: "Organization")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                organizations = fetchResultController.fetchedObjects as! [Organization]
            } catch {
                print(error)
            }
        }
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = "Search your organizations…"
        searchController.searchBar.tintColor = UIColor.whiteColor()
        
        tableView.tableHeaderView = searchController.searchBar
        
        
        
        
        myRootRef.observeEventType(.Value, withBlock: {snapshot in
            print(snapshot.value)
            
            self.organizations = []
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
            
                for snap in snapshots {
                    let newOrganization = Organization(snap: snap)
                    self.organizations.insert(newOrganization, atIndex: 0)
                }
            }
            self.tableView.reloadData()
        })
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let hasViewedWalkthrough = defaults.boolForKey("hasViewedWalkthrough")
        if hasViewedWalkthrough {
            return
        }
        
        if let pageViewController = storyboard?.instantiateViewControllerWithIdentifier("WalkthroughController") as? WalkthroughPageViewController {
            presentViewController(pageViewController, animated: true, completion: nil)
        }
        
//        myRootRef.observeEventType(.Value, withBlock: { snapshot in
//            var newItems = [Organization]()
//            for item in snapshot.children {
//                //let newOrganizationInfo = Organization(snapshot: item as! FDataSnapshot)
//                
//            }
//        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active {
            return results.count
        } else {
            return organizations.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! OrganizationTableViewCell
        
        let organization = (searchController.active) ? results[indexPath.row] : organizations[indexPath.row]
        
        // make the cell look pretty!
        cell.nameLabel.text = organization.name
        cell.thumbnailImageView.image = UIImage(data: organization.image!)
        cell.locationLabel.text = organization.location
        cell.typeLabel.text = organization.type
//        if let isVisited = organization.isVisited?.boolValue {
//            cell.accessoryType = isVisited ? .Checkmark : .None
//        }
        cell.accessoryType = organization.isVisited ? .Checkmark : .None
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return !searchController.active
    }
 
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            // delete row from data source
            organizations.removeAtIndex(indexPath.row)
        }
        
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Share", handler: { (action, indexPath) -> Void in
            
            let defaultText = "Just checking in at " + self.organizations[indexPath.row].name
            if let imageToShare = UIImage(data: self.organizations[indexPath.row].image!) {
                let activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
                self.presentViewController(activityController, animated: true, completion: nil)
            }
        })
        
        // delete button creation
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete",handler: { (action, indexPath) -> Void in
            let key = self.organizations[indexPath.row].name +  self.organizations[indexPath.row].location
            var myRootRef = Firebase(url:"https://volrate.firebaseio.com/Organization")
            myRootRef = myRootRef.childByAppendingPath(key)
            myRootRef.removeValue()
            // delete row from database
//            if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
//                let organizationToDelete = self.fetchResultController.objectAtIndexPath(indexPath) as! Organization
//                managedObjectContext.deleteObject(organizationToDelete)
//
//                do {
//                    try managedObjectContext.save()
//                } catch {
//                    print(error)
//                }
//            }
        })
        
        //set the button color
        shareAction.backgroundColor = UIColor(red: 28.0/255.0, green: 165.0/255.0, blue: 253.0/255.0, alpha: 1.0)
        deleteAction.backgroundColor = UIColor(red: 224.0/255.0, green: 96.0/255.0, blue: 96.0/255.0, alpha: 1.0)

        return [deleteAction, shareAction]
    }
//
    // prepare for navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showOrganizationInfo" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destinationViewController as! OrganizationDetailViewController
                destinationController.organization = (searchController.active) ? results[indexPath.row] : organizations[indexPath.row]
                // hide tab
                destinationController.hidesBottomBarWhenPushed = true
            }
        }
    }
    
    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
        
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        // modify the table
        switch type {
        case .Insert:
            if let _newIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([_newIndexPath], withRowAnimation: .Fade)
            }
        case .Delete:
            if let _indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([_indexPath], withRowAnimation: .Fade)
            }
        case .Update:
            if let _indexPath = indexPath {
                tableView.reloadRowsAtIndexPaths([_indexPath], withRowAnimation: .Fade)
            }
        default:
            tableView.reloadData()
        }

        //modify organizations array
        organizations = controller.fetchedObjects as! [Organization]
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    //search for organizations by title and location
    func filterContentForSearchText(searchText: String) {
        results = organizations.filter({ (organization: Organization) -> Bool in
            let nameMatch = organization.name.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            let locationMatch = organization.location.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return ((nameMatch != nil) || (locationMatch != nil))
        })
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContentForSearchText(searchText)
            tableView.reloadData()
        }
    }
}
