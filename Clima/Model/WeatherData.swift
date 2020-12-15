//
//  WeatherData.swift
//  Clima
//
//  Created by Margi Bhatt on 27/10/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData:Codable {
    //Codable is typeAlias(consists of/combination of) of decodable and encodable,i.e. combines 2 protocols
    let name : String
    let main : Main
    let weather : [Weather]
    
}
struct Main:Codable {
    let temp: Double
}
struct Weather:Codable {
    let description : String
    let id: Int
}
