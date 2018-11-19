//
//  Utils.swift
//  WeatherFeedBase
//
//  Created by fernando rossetti 12/12/16.
//  Copyright © 2016 NextU. All rights reserved.
//

import UIKit


typealias locationData = (City, UIImage) -> Void
typealias locationDat = (CityData, UIImage)

struct Utils {
    static let sharedInstance = Utils()
    
    private init() {}
    
    func getTime(time: NSDate) -> Date {
        let formater = NSDateFormatter()
        formater.dateFormat = "EEEE"
        let name = formater.stringFromDate(time)
    
        let cal = NSCalendar.currentCalendar()
        let year = cal.component(.Year, fromDate: time)
        let month = cal.component(.Month, fromDate: time)
        let day = cal.component(.Day, fromDate: time)
        let hour = cal.component(.Hour, fromDate: time)
        return Date(year: year, day: day, hour: hour, month: month, nameDay: name)
    }
    
    
    func makeDaysArray(currentDay: Int, forecast: [ForecastData]) -> [Day] {
        var weathers = [ForecastData]()
        var lastDays = [Day]()
        var dayName: String = ""
        
        for (i, element) in forecast.enumerate() {
            let date = self.getTime(element.time)
            if currentDay != date.day {
                let restElements: [ForecastData] = Array(forecast[i..<forecast.count])
                lastDays.appendContentsOf(makeDaysArray(date.day, forecast: restElements))
                break
            }
            dayName = date.nameDay
            weathers.append(element)
        }
        
        let dayStruct = Day(name: dayName, weathers: weathers)
        lastDays.insert(dayStruct, atIndex: 0)
        
        return lastDays
     }
    
    func createLocation(location: String, onComplete: locationData) {
        WeatherBase.sharedInstance.weatherDataWith(location) { (city) in
            let cityName = city.name
            let forecasts = city.forecasts
            let today = forecasts[0]
            
            let currentDay = self.getTime(forecasts[1].time).day
            let removeToday = Array(forecasts[1..<forecasts.count])
            let weathers = self.makeDaysArray(currentDay, forecast: removeToday)
            let newPlace = City(name: cityName!, country: city.countryISO!, today: today, weathers: weathers)
            
            onComplete(newPlace, today.background!)
        }
    }
}








