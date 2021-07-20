//
//  WeatherManager.swift
//  Clima
//
//  Created by Apple on 18/05/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol weatherManagerDeligate {
    func didUpdateWeather(_ weatherMAnager:WeatherManager , weather:WeatherModel )
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    var deligate:weatherManagerDeligate?
        
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=ab4071fec8fbe659d56b967f1341e55d&units=metric"
    
    func fetchWeather(cityName:String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with : urlString)
    }
    
    func fetchWeather(latitude:CLLocationDegrees,longitide:CLLocationDegrees){
        
        let url = "\(weatherURL)&lat=\(latitude)&lon=\(longitide)"
        performRequest(with: url)
        
    }
    
     func performRequest(with urlString : String) {
                
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, urlResponse, error) in
                if error != nil {
                    deligate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.passJSON(safeData){
                        self.deligate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            task.resume()
            
        }
    }
    
     func passJSON(_ weatherData:Data ) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let cityName = decodedData.name
            let temperature = decodedData.main.temp
//          print(decodedData.weather[0].description)
            let weatherId = decodedData.weather[0].id
            let weather = WeatherModel(city: cityName, id: weatherId, temperature: temperature)
            return weather
            
        }
        catch{
            deligate?.didFailWithError(error: error)
            return nil
        }
    }

}
