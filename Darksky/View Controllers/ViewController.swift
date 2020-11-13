//
//  ViewController.swift
//  Darksky
//
//  Created by Sydney Karimi on 11/4/20.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var minmaxLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var citySearchButton: UIButton!
    @IBOutlet weak var zipcodeSearchButton: UIButton!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunriseImageView: UIImageView!
    @IBOutlet weak var sunsetImageView: UIImageView!
    @IBOutlet weak var sunsetLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentLat: Double!
    var currentLon: Double!
    var currentWeatherModel: Weather.WeatherModel!
    var currentWeather: Weather.Weather!
    var currentWeatherTemps: Weather.Main!
    var forecast: Forecast.ForecastModel?
    var history: History.HistoryModel!
    var lastFiveDays: [History.HistoryModel] = []
    var dt: Int!
    var oneDay: Int!
    var notLoaded = true

    
    var locationManager = CLLocationManager()

    let networkManager = WeatherNetworkManager()
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        var leftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeMade(_:)))
        leftRecognizer.direction = .left
        var rightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeMade(_:)))
        rightRecognizer.direction = .right
        self.view.addGestureRecognizer(leftRecognizer)
        self.view.addGestureRecognizer(rightRecognizer)
        tableView.delegate = self
        tableView.dataSource = self
        
        oneDay = 86400
        super.viewDidLoad()
        sunriseImageView.image = UIImage(named: "dawn.png")
        sunsetImageView.image = UIImage(named: "sunset.png")
        // Do any additional setup after loading the view.
        if notLoaded {
            getUserLocation()
            notLoaded = false
        }
        else {
            loadData(lat: currentLat, lon: currentLon)
        }
        
    }
    
    @IBAction func swipeMade(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            print("left swipe")
            performSegue(withIdentifier: "MainToForecast", sender: nil)
        }
        if sender.direction == .right {
            performSegue(withIdentifier: "MainToHistory", sender: nil)
            print("right swipe")
        }
    }
    
    func kelvinToF(temp: Float) -> Int {
        return Int(round(temp * (9/5) - 459.67))
    }
    
    func timeToText(time: Int) -> String {
        var formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        var date = Date(timeIntervalSince1970: Double(time))
        return formatter.string(from: date)
    }
    
    func updateWeatherView(weath: Weather.Weather, weathTemp: Weather.Main, weathModel: Weather.WeatherModel) {
        var currTemp = kelvinToF(temp: weathTemp.feels_like)
        var icon = weath.icon
        temperatureLabel.text = String(currTemp) + "°"
        descriptionLabel.text = weath.description
        locationLabel.text = weathModel.name
        
        weatherImageView.loadImage(withUrl: URL(string: "http://openweathermap.org/img/wn/\(icon)@2x.png") ?? URL(string: "https://image.flaticon.com/icons/png/512/36/36601.png")!)
        
        minmaxLabel.text = String(kelvinToF(temp: weathTemp.temp_min)) + "° / " + String(kelvinToF(temp: weathTemp.temp_max)) + "°"
        feelsLikeLabel.text = "Feels like: " + String(kelvinToF(temp: weathTemp.feels_like)) + "°"
        humidityLabel.text = "Humidity: " + String(weathTemp.humidity) + "%"
        if let sunrise = weathModel.sys.sunrise,
           let sunset = weathModel.sys.sunset {
            sunriseLabel.text = timeToText(time: sunrise)
            sunsetLabel.text = timeToText(time: sunset)
        } else {return}
        
        
        print(currentWeatherModel.dt)

    }
    
    func updateForecastView() {
        return
    }

    func getUserLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else {
            return
        }
        //latitudeLabel.text = "Lat: " + String(loc.coordinate.latitude)
        //longitudeLabel.text = "Long: " + String(loc.coordinate.longitude)
        loadData(lat: loc.coordinate.latitude, lon: loc.coordinate.longitude)
    }
    
    @IBAction func onZipcodeSearchButton(_ sender: Any) {
        let zipcodeAlert = UIAlertController(title: "Zipcode Search", message: "Type in a Zipcode", preferredStyle: .alert)
    
        zipcodeAlert.addTextField(configurationHandler: {textField in
            textField.placeholder = "Type in a valid zipcode"
        })
        let ok = UIAlertAction(title: "Search", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            print("Zipcode: \(zipcodeAlert.textFields?.first?.text ?? "")")
            var z = Int(zipcodeAlert.textFields?.first?.text ?? "")
            self.loadData(zipcode: z!)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        zipcodeAlert.addAction(ok)
        zipcodeAlert.addAction(cancel)
        
        self.present(zipcodeAlert, animated: true, completion: nil)
    }
    
    @IBAction func onCitySearchButton(_ sender: Any) {
        let cityAlert = UIAlertController(title: "City Search", message: "Type in a City Name", preferredStyle: .alert)
        
        cityAlert.addTextField(configurationHandler: {textField in
            textField.placeholder = "Type in a City Name"
        })
        let ok = UIAlertAction(title: "Search", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            var c = cityAlert.textFields?.first?.text ?? ""
            print("City: \(cityAlert.textFields?.first?.text ?? "")")
            self.loadData(city: c)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        cityAlert.addAction(ok)
        cityAlert.addAction(cancel)
        self.present(cityAlert, animated: true, completion: nil)
    }
    
    func loadData(lat: Double, lon: Double) {
        networkManager.fetchCurrentLocationWeather(lat: lat, lon: lon) { (weather) in
            self.currentWeather = weather.weather[0]
            self.currentWeatherTemps = weather.main
            self.currentWeatherModel = weather
            self.currentLat = Double(weather.coord.lat)
            self.currentLon = Double(weather.coord.lon)
            self.dt = weather.dt
            
            //get the rest of the data
            self.getForecast()
            self.getHistory()
            
            DispatchQueue.main.async {
                self.updateWeatherView(weath: self.currentWeather, weathTemp: self.currentWeatherTemps, weathModel: self.currentWeatherModel)
                self.tableView.reloadData()
            
            }
        }
    }
    
    func loadData(zipcode: Int) {
        networkManager.fetchZipcodeWeather(zipcode: zipcode) { (weather) in
            self.currentWeather = weather.weather[0]
            self.currentWeatherTemps = weather.main
            self.currentWeatherModel = weather
            self.currentLat = Double(weather.coord.lat)
            self.currentLon = Double(weather.coord.lon)
            self.dt = weather.dt

            
            //get the rest of the data
            self.getForecast()
            self.getHistory()
            
            DispatchQueue.main.async {
                self.updateWeatherView(weath: self.currentWeather, weathTemp: self.currentWeatherTemps, weathModel: self.currentWeatherModel)
                self.tableView.reloadData()

            }
        }
    }
    
    func loadData(city: String) {
        networkManager.fetchCityWeather(city: city) { (weather) in
            self.currentWeather = weather.weather[0]
            self.currentWeatherTemps = weather.main
            self.currentWeatherModel = weather
            self.currentLat = Double(weather.coord.lat)
            self.currentLon = Double(weather.coord.lon)
            self.dt = weather.dt

            
            //get the rest of the data
            self.getForecast()
            self.getHistory()
            
            DispatchQueue.main.async {
                self.updateWeatherView(weath: self.currentWeather, weathTemp: self.currentWeatherTemps, weathModel: self.currentWeatherModel)
                self.tableView.reloadData()

            }
        }
    }
    
    func getForecast() {
        networkManager.fetchForecast(lat: self.currentLat, lon: self.currentLon) { (forecast) in
            self.forecast = forecast
            print(forecast)
        }
    }
    
    func getHistory() {
        networkManager.fetchHistory(lat: self.currentLat, lon: self.currentLon, time: self.dt-oneDay) {
            (history) in
            self.history = history
            print(history)
        }
        
        for i in 1...5 {
            networkManager.fetchHistory(lat: self.currentLat, lon: self.currentLon, time: self.dt-(oneDay*i)) {
                (history) in
                self.lastFiveDays.append(history)
            }
        }
    }
    
    @IBAction func onHistoryButton(_ sender: Any) {
        performSegue(withIdentifier: "MainToHistory", sender: nil)
    }
    @IBAction func onForecastButton(_ sender: Any) {
        performSegue(withIdentifier: "MainToForecast", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainToHistory" {
            let controller = segue.destination as! HistoryViewController
            controller.currentLat = currentLat
            controller.currentLon = currentLon
            controller.lastFiveDays = lastFiveDays
            
            controller.dt = dt
        }
        if segue.identifier == "MainToForecast" {
            let controller = segue.destination as! ForecastViewController
            controller.currentLat = currentLat
            controller.currentLon = currentLon
            controller.forecast = forecast!
            controller.lastFiveDays = lastFiveDays
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 24
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let forecast = forecast {
            let cell = tableView.dequeueReusableCell(withIdentifier: "hourlyCell", for: indexPath) as! HourlyTableViewCell
            
            
            var formatter = DateFormatter()
            formatter.dateFormat = "HH:00"
            var dtToDate = Date(timeIntervalSince1970: Double(forecast.hourly[indexPath.row].dt))
            
            cell.timeLabel.text = formatter.string(from: dtToDate)
            cell.tempLabel.text = String(kelvinToF(temp: Float(forecast.hourly[indexPath.row].feels_like))) + "°"
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "hourlyCell", for: indexPath) as! HourlyTableViewCell
            cell.timeLabel.text = ""
            cell.tempLabel.text = ""
            return cell
        }
        

    }
}

extension UIImageView {
    func loadImage(withUrl url: URL) {
           DispatchQueue.global().async { [weak self] in
               if let imageData = try? Data(contentsOf: url) {
                   if let image = UIImage(data: imageData) {
                       DispatchQueue.main.async {
                           self?.image = image
                       }
                   }
               }
           }
       }
}
