//
//  Weather.swift
//  Darksky
//
//  Created by Sydney Karimi on 11/5/20.
//

import Foundation

class Weather {
    private var BASE_URL = "http://api.openweathermap.org/data/2.5/weather"
    private var API_KEY = "76bb3bbe235e15f41b6309fa64b17722"
    
    struct Coord: Codable {
        let lon: Float
        let lat: Float
    }
    
    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct Main: Codable {
        let temp: Float
        let feels_like: Float
        let temp_min: Float
        let temp_max: Float
        let pressure: Float
        let humidity: Float
    }
    
    struct Sys: Codable {
        let country: String?
        let sunrise: Int?
        let sunset: Int?
    }
    
    struct WeatherModel: Codable {
        let coord: Coord
        let weather: [Weather]
        let main: Main
        let sys: Sys
        let name: String?
        let dt: Int
        let timezone: Int?
        let dt_text: String?
    }
    
    
}
