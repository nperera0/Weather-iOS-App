//
//  ViewController.swift
//  Weather
//
//  Created by Nisal Perera on 2015-11-02.
//  Copyright © 2015 BrainStation. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func getWeather() {
        // This function returns immediately: The request happens on a
        // background thread, and then it calls the completionHandler closure
        // you pass in.
        Alamofire.request(.GET, "https://api.forecast.io/forecast/e0ad861e183017092cec7fb188c2d787/37.8267,-122.423").response {
            (request: NSURLRequest?, response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> Void in
            print("Request completed!")
            if let data = data {
                // Interpret data (which is NSData) as a JSON object
                let json = JSON(data: data)
                // Create a CurrentWeather instance from the JSON
                let current = CurrentWeather.fromJSON(json["currently"])
                let dailyData = json["daily"]["data"].array
                if let daily = dailyData?.map(DayWeather.fromJSON) {
                    for day in daily {
                        print("Day \(day.date): \(day.summary)")
                    }
                }
                print("Current condition: \(current.date) \(current.summary) \(current.temperature)°F")
            }
        }
        print("Sent request")
    }

}

