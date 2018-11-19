//
//  Place.swift
//  WeatherFeedBase
//
//  Created by fernando rossetti 12/12/16.
//  Copyright © 2016 NextU. All rights reserved.
//

import Foundation

class City {
    let name: String
    let country: String
    let today: ForecastData
    let weathers: [Day]
    
    init(name: String, country: String, today: ForecastData, weathers: [Day]) {
        self.name = name
        self.country = country
        self.today = today
        self.weathers = weathers
    }
}