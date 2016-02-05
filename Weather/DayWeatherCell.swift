//
//  DayWeatherCell.swift
//  Weather
//
//  Created by Nisal Perera on 2015-11-02.
//  Copyright © 2015 BrainStation. All rights reserved.
//

import UIKit

class DayWeatherCell: UITableViewCell {

    // Define outlets here
    @IBOutlet var dayLabel:UILabel!
    @IBOutlet var tempLable: UILabel!
    @IBOutlet var iconView:UIImageView!
    
    var weather: DayWeather? {
        didSet {
            // Update outlets based on new weather data here
            if let weather = self.weather{
                let formatter = NSDateFormatter()
                formatter.dateFormat = "EEEE MM d"
                dayLabel.text = formatter.stringFromDate(weather.date)
                
                // Convert temperatures from farenheit to Celsius 
                let minTemp = Temperature(fahrenheit: weather.minTemp)
                let maxTemp = Temperature(fahrenheit: weather.maxTemp)
                
                let minTempString = String(format: "%.f", minTemp.celsius)
                let maxTempString = String(format: "%.f", maxTemp.celsius)
                
                tempLable.text = "\(minTempString)-\(maxTempString)"
                
                iconView.image = UIImage(named: weather.iconName)
            }
            else{
                dayLabel.text = ""
                tempLable.text = ""
                iconView.image = nil 
            }
            
        }
    }

}
