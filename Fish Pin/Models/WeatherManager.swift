//
//  WeatherManager.swift
//  Fish Pin
//
//  Created by Caleb Hodges on 2/8/22.
//

import Foundation

protocol WeatherDelegate {
    func didRecieveWeather(_ weather: WeatherData)
    func didRecieveError(_ error: Error?)
}

struct WeatherManager {
    
    var delegate:  WeatherDelegate?
    
    func getWeather(_ lat: Double, _ lon: Double) {
        
        let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=\(Secret.apiKey)&units=imperial&lat=\(lat)&lon=\(lon)"
        
        if let url = URL(string: weatherURL) {
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: url) { data, response, error in
                
                if error != nil {
                    // Handle error: Could not complete datatask
                    delegate?.didRecieveError(error)
                    
                } else {
                    if let data = data {
                        if let weather = self.parseJson(data) {
                            delegate?.didRecieveWeather(weather)
                        }
                    }
                }
            }
            dataTask.resume()
        }
    } // End getWeather
    
    func parseJson(_ data: Data) -> WeatherData? {
        
        let decoder = JSONDecoder()
        
        do {
            let weather = try decoder.decode(WeatherData.self, from: data)
            return weather
        } catch {
            // Handle error: Could not parse the JSON
            delegate?.didRecieveError(error)
            return nil
        }
    }
    
} // WeatherManager struct
