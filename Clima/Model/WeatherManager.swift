//
//  WeatherManager.swift
//  Clima
//
//  Created by Margi Bhatt on 25/10/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager,weather: WeatherModel)
    func didFailWithError(error: Error)
}
//we define protocol in the same file as where we use according to convention
struct WeatherManager {
    let weatherURL = MyOpenWeatherApiKey
//    Instead of MyOpenWeatherApiKey, add your api key.
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        //1.Create a URL.
        if let url = URL(string: urlString){
            //2. Create a URLSession.
            let session = URLSession(configuration: .default)
            //3.Give the session a task.
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return//nothing after return means exit from this function
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self,weather: weather)
                        
                    }
                    //parseJSON(weatherData: safeData)//add self in front of parseJSON if referring to a function in the same file is not being shown inside closures.
                }
            }
            //4.Start the task.
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
            
        }
        catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
