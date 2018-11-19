//
//  Date.swift
//  WeatherFeedBase
//
//  Created by fernando rossetti 12/12/16.
//  Copyright © 2016 NextU. All rights reserved.
//

import Foundation

struct Date {
    let year: Int!
    let day: Int!
    let hour: Int!
    let month: Int!
    let nameDay: String!
    
    init(year: Int, day: Int, hour: Int, month: Int, nameDay: String) {
        self.year = year
        self.day = day
        self.hour = hour
        self.month = month
        self.nameDay = nameDay
    }
}