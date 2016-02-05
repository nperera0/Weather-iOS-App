//
//  CurrentWeatherCell.swift
//  Weather
//
//  Created by Nisal Perera on 2015-11-09.
//  Copyright © 2015 BrainStation. All rights reserved.
//

import UIKit

class CurrentWeatherCell: UITableViewCell {
    
    // Define outlets here
    @IBOutlet var dayLabel:UILabel!
    @IBOutlet var tempLable: UILabel!
    @IBOutlet var iconView:UIImageView!
    
    var weather: CurrentWeather? {
        didSet {
            // Update outlets based on new weather data here
            if let weather = self.weather {
                let formatter = NSDateFormatter()
                formatter.dateFormat = "EEEE MM d"
                dayLabel.text = formatter.stringFromDate(weather.date)
                
                // Convert temperatures from farenheit to Celsius
                let Temp = Temperature(fahrenheit: weather.temperature)
               
                let TempString = String(format: "%.f", Temp.celsius)
                
                
                tempLable.text = "\(TempString)"
                
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