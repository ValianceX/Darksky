//
//  ForecastViewController.swift
//  Darksky
//
//  Created by Sydney Karimi on 11/12/20.
//

import UIKit

class ForecastViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var forecast: Forecast.ForecastModel!
    var forecastArray: [Forecast.Daily]!
    var currentLat: Double!
    var currentLon: Double!
    var lastFiveDays: [History.HistoryModel] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        forecastArray = forecast.daily
        
        var rightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeMade(_:)))
        rightRecognizer.direction = .right
        self.view.addGestureRecognizer(rightRecognizer)
        
        tableView.delegate = self
        tableView.dataSource = self
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func swipeMade(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .right {
            performSegue(withIdentifier: "ForecastToMain", sender: nil)
            print("right swipe")
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section:Int) -> String?
    {
      return "Forecast"
    }
    
    func kelvinToF(temp: Float) -> Int {
        return Int(round(temp * (9/5) - 459.67))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell", for: indexPath) as! ForecastTableViewCell
        print(indexPath.row)
        
        var formatter = DateFormatter()
        formatter.dateFormat = "MM-dd"
        var dtToDate = Date(timeIntervalSince1970: Double(forecast.daily[indexPath.row].dt))
        
        cell.dateLabel.text = formatter.string(from: dtToDate)
        cell.minLabel.text = "Min: " + String(kelvinToF(temp: forecast.daily[indexPath.row].temp.min)) + "°"
        cell.maxLabel.text = "Max: " + String(kelvinToF(temp: forecast.daily[indexPath.row].temp.max)) + "°"

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ForecastToMain" {
            let controller = segue.destination as! ViewController
            controller.currentLat = currentLat
            controller.currentLon = currentLon
            controller.lastFiveDays = lastFiveDays
            controller.notLoaded = false
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
