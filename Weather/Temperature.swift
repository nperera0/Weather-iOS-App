//
//  Temperature.swift
//  Weather
//
//  Created by Nisal Perera on 2015-11-09.
//  Copyright © 2015 BrainStation. All rights reserved.
//

import Foundation

class Temperature {
    var tempInCelsius: Double
    
    init(celsius: Double) {
        tempInCelsius = celsius
    }
    
    init(fahrenheit: Double) {
        tempInCelsius = (fahrenheit - 32.0) * 5.0 / 9.0
    }
    
    var celsius: Double {
        get {
            return tempInCelsius
        }
    }
    
    var fahrenheit: Double {
        get {
            return tempInCelsius * 9.0 / 5.0 + 32.0
        }
    }
}
