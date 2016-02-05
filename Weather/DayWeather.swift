//
//  DayWeather.swift
//  Weather
//
//  Created by Nisal Perera on 2015-11-02.
//  Copyright © 2015 BrainStation. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class DayWeather:Object {
    dynamic var summary: String = ""
    dynamic var iconName: String = ""
    dynamic var minTemp: Double = 0.0
    dynamic var maxTemp: Double = 0.0
    dynamic var date: NSDate = NSDate()

    static func fromJSON(json: JSON) -> DayWeather {
        let day = DayWeather()
        if let seconds = json["time"].double {
            day.date = NSDate(timeIntervalSince1970: seconds)
        }
        if let summary = json["summary"].string {
            day.summary = summary
        }
        if let iconName = json["icon"].string {
            day.iconName = iconName
        }
        if let temperatureMin = json["temperatureMin"].double {
            day.minTemp = temperatureMin
        }
        if let temperatureMax = json["temperatureMax"].double {
            day.maxTemp = temperatureMax
        }
        return day
    }
}
