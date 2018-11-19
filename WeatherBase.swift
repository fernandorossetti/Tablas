//
//  WeatherBase.swift
//  WeatherFeed
//
//  Created by Mateo Olaya Bernal on 1/19/16.
//  Copyright © 2016 NextU. All rights reserved.
//

import UIKit
import Alamofire

typealias CityCompletion = (city:CityData) -> Void

struct ForecastData {
    var temperature:Int!
    var minimumTemperature:Float!
    var maximumTemperature:Float!
    var time:NSDate!
    var weatherDescription:String!
    var weatherCode:Int!
    var background:UIImage?
    var icon:UIImage!
}

struct CityData {
    var name:String?
    var countryISO:String?
    var forecasts:[ForecastData]!
}

enum WeatherUnits : String {
    case Metric = "&units=metric"
    case Imperial = "&units=imperial"
    case Standard = ""
}


class WeatherBase {
    static let sharedInstance = WeatherBase()
    var apiKey:String! = "b7507934ec3cef25f35b0f985ddb429c"
    var unit:WeatherUnits = .Metric
    
    private init() { }
    
    func iconWeather(code:Int) -> (icon:UIImage, background:UIImage) {
        switch code {
        case 200..<300:
            return (UIImage(named: "tormenta-icon")!, UIImage(named: "tormenta")!)
        case 300..<400:
            return (UIImage(named: "llovizna-icon")!, UIImage(named: "llovizna")!)
        case 500..<600:
            return (UIImage(named: "lluvia-icon")!, UIImage(named: "llovizna")!)
        case 600..<700:
            return (UIImage(named: "nieve-icon")!, UIImage(named: "nieve")!)
        case 700..<800:
            return (UIImage(named: "niebla-icon")!, UIImage(named: "niebla")!)
        case 800:
            return (UIImage(named: "soleado-icon")!, UIImage(named: "soleado")!)
        case 801..<810:
            return (UIImage(named: "nublado-icon")!, UIImage(named: "nublado")!)
        default:
            return (UIImage(named: "soleado-icon")!, UIImage(named: "soleado")!)
        }
    }
    
    func weatherDataWith(cityName:String, completion:CityCompletion) {
        let url = "http://api.openweathermap.org/data/2.5/forecast?q=\(cityName)&mode=json&appid=\(apiKey)\(unit.rawValue)&lang=es"
        let escapedAddress = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        Alamofire.request(.GET, escapedAddress!).responseJSON { (response) -> Void in
            if let result = response.result.value as? NSDictionary {
                var city = CityData()
                city.name = result["city"]!["name"] as? String
                city.countryISO = result["city"]!["country"] as? String
                
                var forecasts:[ForecastData] = []
                for f in result["list"] as! NSArray {
                    var forecast = ForecastData()
                    forecast.temperature = Int(round(f["main"]!!["temp"] as! Float))
                    forecast.maximumTemperature = (f["main"]!!["temp_max"] as! Float)
                    forecast.minimumTemperature = (f["main"]!!["temp_min"] as! Float)
                    
                    forecast.time = NSDate(timeIntervalSince1970: (f["dt"] as! Double))
                    
                    if let weather = f["weather"] as? NSArray {
                        //print(weather)
                        forecast.weatherCode = weather[0]["id"] as! Int
                        forecast.weatherDescription = weather[0]["description"] as! String
                    }
                    
                    let images = self.iconWeather(forecast.weatherCode)
                    
                    forecast.icon = images.icon
                    forecast.background = images.background
                    
                    forecasts.append(forecast)
                }
                
                city.forecasts = forecasts
                completion(city: city)
            }
        }
    }
}
