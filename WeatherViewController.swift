//
//  WeatherViewController.swift
//  WeatherFeedBase
//
//  Created by fernando rossetti 12/12/16.
//  Copyright © 2016 NextU. All rights reserved.
//

import UIKit
import Alamofire

class WeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var backgorundImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var cities: [City] = [City]()
    var image: UIImage!
    let utils = Utils.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgorundImage.image = image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Actions
    
    func deletePlace(place: City, row: Int) {
        NSNotificationCenter.defaultCenter().postNotificationName("deletedPlace", object: row)
        
        let index = NSIndexPath(forRow: row, inSection: 0)
        self.tableView.reloadRowsAtIndexPaths([index], withRowAnimation: .Right)
        self.cities.removeAtIndex(row)
        self.tableView.reloadData()
    }
    
    func addLocationToArray(location: String) {
        utils.createLocation(location) { (place, image) in
            dispatch_async(dispatch_get_main_queue()) {
                let data: [AnyObject] = [place, image]
                
                NSNotificationCenter.defaultCenter().postNotificationName("addedPlace", object: data)
                
                self.cities.append(place)
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func addLocation(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add location", message: nil, preferredStyle: .Alert)
        let saveAction = UIAlertAction(title: "Ok", style: .Default) { (action) in
            let location = alertController.textFields!.first
            self.addLocationToArray(location!.text!)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Location: "
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: tableView configuration
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("locationCell", forIndexPath: indexPath)
        let place = cities[indexPath.row]
        cell.textLabel?.text = place.name
        cell.detailTextLabel?.text = "\(place.today.temperature)°c"
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { (action, index) in
            let place = self.cities[index.row]
            self.deletePlace(place, row: index.row)
        }
        delete.backgroundColor = UIColor.redColor()
        return [delete]
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

}
