//
//  CurrentWeather.swift
//  Weather
//
//  Created by Nisal Perera on 2015-11-02.
//  Copyright © 2015 BrainStation. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift 

class CurrentWeather: Object {
    dynamic var summary: String = ""
    dynamic var iconName: String = ""
    dynamic var temperature: Double = 0.0
    dynamic var date: NSDate = NSDate()

    static func fromJSON(json: JSON) -> CurrentWeather {
        let current = CurrentWeather()
        if let seconds = json["time"].double {
            current.date = NSDate(timeIntervalSince1970: seconds)
        }
        if let summary = json["summary"].string {
            current.summary = summary
        }
        if let iconName = json["icon"].string {
            current.iconName = iconName
        }
        if let temperature = json["temperature"].double {
            current.temperature = temperature
        }
        return current
    }
}
