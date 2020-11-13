//
//  WeatherNetworkManager.swift
//  Darksky
//
//  Created by Sydney Karimi on 11/8/20.
//

import Foundation
import CoreLocation

class WeatherNetworkManager : NetworkManagerProtocol{
    
    let API_KEY = "76bb3bbe235e15f41b6309fa64b17722"
    var locationManager = CLLocationManager()
    
    func fetchCurrentLocationWeather(lat: Double, lon: Double, completion: @escaping (Weather.WeatherModel) -> ()) {
        //api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
        print("Fetching current location weather")
        let API_URL = "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(API_KEY)"
        
        guard let url = URL(string: API_URL) else {
            fatalError()
        }
        
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else {return}
            
            do {
                let currentWeather = try JSONDecoder().decode(Weather.WeatherModel.self, from: data)
                print(type(of: currentWeather))
                completion(currentWeather)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func fetchZipcodeWeather(zipcode: Int, completion: @escaping (Weather.WeatherModel) -> ()) {
        //api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
        print("Fetching weather by zipcode")
        let API_URL = "http://api.openweathermap.org/data/2.5/weather?zip=\(zipcode),us&appid=\(API_KEY)"
        
        guard let url = URL(string: API_URL) else {
            fatalError()
        }
        
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else {return}
            
            do {
                let currentWeather = try JSONDecoder().decode(Weather.WeatherModel.self, from: data)
                completion(currentWeather)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func fetchCityWeather(city:String, completion: @escaping (Weather.WeatherModel) -> ()) {
        //api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
        print("Fetching weather by city")
        let formattedCity = city.replacingOccurrences(of: " ", with: "+")
        let API_URL = "http://api.openweathermap.org/data/2.5/weather?q=\(formattedCity),us&appid=\(API_KEY)"
        
        guard let url = URL(string: API_URL) else {
            fatalError()
        }
        
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else {return}
            
            do {
                let currentWeather = try JSONDecoder().decode(Weather.WeatherModel.self, from: data)
                print(currentWeather)
                completion(currentWeather)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func fetchForecast(lat: Double, lon: Double, completion: @escaping (Forecast.ForecastModel) -> ()) {
        //api.openweathermap.org/data/2.5/onecall?lat={lat}&lon={lon}&exclude=current,minutely&appid=76bb3bbe235e15f41b6309fa64b17722

        print("Fetching current location weather")
        let API_URL = "http://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&appid=\(API_KEY)"
        
        guard let url = URL(string: API_URL) else {
            fatalError()
        }
        
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else {return}
            
            do {
                let forecast = try JSONDecoder().decode(Forecast.ForecastModel.self, from: data)
                print(type(of: forecast))
                completion(forecast)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func fetchHistory(lat: Double, lon: Double, time: Int, completion: @escaping (History.HistoryModel) -> ()) {
        //api.openweathermap.org/data/2.5/onecall/timemachine?lat=33.57&lon=-117.73&dt=1605172880&appid=76bb3bbe235e15f41b6309fa64b17722

        print("Fetching current location weather")
        let API_URL = "http://api.openweathermap.org/data/2.5/onecall/timemachine?lat=\(lat)&lon=\(lon)&dt=\(time)&appid=\(API_KEY)"
        
        guard let url = URL(string: API_URL) else {
            fatalError()
        }
        
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else {return}
            
            do {
                let history = try JSONDecoder().decode(History.HistoryModel.self, from: data)
                completion(history)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func convertTime(time:Int) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(time))
    }
}
