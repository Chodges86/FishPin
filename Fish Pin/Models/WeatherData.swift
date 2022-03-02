//
//  WeatherModel.swift
//  Fish Pin
//
//  Created by Caleb Hodges on 2/7/22.
//

import Foundation


struct WeatherData: Codable {
    
    let main: Main
    let weather: [Weather]
    
}

struct Main: Codable {
    
    let temp: Double
}

struct Weather: Codable {
    
    let description: String
}


