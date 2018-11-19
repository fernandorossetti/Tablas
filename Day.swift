//
//  Day.swift
//  WeatherFeedBase
//
// Created by fernando rossetti 12/12/16.
//  Copyright © 2016 NextU. All rights reserved.
//

import Foundation

struct Day {
    let name: String
    let weathers: [ForecastData]
    
    init(name: String, weathers: [ForecastData]) {
        self.name = name
        self.weathers = weathers
    }
}