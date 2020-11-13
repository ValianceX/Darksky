//
//  NetworkManagerProtocol.swift
//  Darksky
//
//  Created by Sydney Karimi on 11/8/20.
//

import Foundation

protocol NetworkManagerProtocol {

    func fetchCurrentLocationWeather(lat: Double, lon: Double, completion: @escaping (Weather.WeatherModel) -> ())
   
    func fetchZipcodeWeather(zipcode: Int, completion: @escaping (Weather.WeatherModel) -> ())
    
    func fetchCityWeather(city: String, completion: @escaping (Weather.WeatherModel) -> ())
}
