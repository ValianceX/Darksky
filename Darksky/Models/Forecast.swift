//
//  Forecast.swift
//  Darksky
//
//  Created by Sydney Karimi on 11/12/20.
//

import Foundation

class Forecast {
    struct Daily: Codable {
        let dt: Int
        let sunrise: Float
        let sunset: Float
        let temp: Temp
    }
    
    struct Hourly: Codable {
        let dt: Int
        let feels_like: Float
        
    }

    struct Temp: Codable {
        let day: Float
        let min: Float
        let max: Float
    }
    
    struct ForecastModel: Codable {
        let lat: Float
        let lon: Float
        let daily: [Daily]
        let hourly: [Hourly]
    }
}
