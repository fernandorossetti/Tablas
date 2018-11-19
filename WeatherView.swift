//
//  WeatherView.swift
//  WeatherFeedBase
//
// Created by fernando rossetti 12/12/16.
//  Copyright © 2016 NextU. All rights reserved.
//

import UIKit

class WeatherView: UIView, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countrylabel: UILabel!
    @IBOutlet weak var degreesLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var weathers: [Day] = [Day]()
    let utils = Utils.sharedInstance

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(UINib(nibName: "WeatherCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! WeatherCell
        
        let weatherOfDay = weathers[indexPath.section].weathers
        
        let currentDay = weatherOfDay[indexPath.row]
        cell.dayLabel.text = "\(currentDay.weatherDescription.capitalizedString) - \(utils.getTime(currentDay.time).hour):00"
        
        cell.maxLabel.text = String(Int(currentDay.maximumTemperature))
        cell.minLabel.text = String(Int(currentDay.minimumTemperature))
        cell.imageIcon.image = currentDay.icon
        
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return weathers.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return weathers[section].name
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weathers[section].weathers.count
    }
}




