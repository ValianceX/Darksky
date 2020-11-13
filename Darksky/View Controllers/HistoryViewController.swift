//
//  HistoryViewController.swift
//  Darksky
//
//  Created by Sydney Karimi on 11/12/20.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    var lastFiveDays: [History.HistoryModel] = []
    var dt: Int!
    let oneDay = 86400
    var currentLat: Double!
    var currentLon: Double!
    
    override func viewDidLoad() {
        view.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
        super.viewDidLoad()
        
        var leftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeMade(_:)))
        leftRecognizer.direction = .left
        self.view.addGestureRecognizer(leftRecognizer)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func swipeMade(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            print("left swipe")
            performSegue(withIdentifier: "HistoryToMain", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryTableViewCell
        print(indexPath.row)
        var i = indexPath.row
        cell.historyCellLabel.text = String(kelvinToF(temp: lastFiveDays[i].current.temp)) + "°"
        var formatter = DateFormatter()
        formatter.dateFormat = "MM-dd"
        var dtToDate = Date(timeIntervalSince1970: Double(dt-(i+1)*oneDay))
        var dateText = formatter.string(from: dtToDate)
        cell.dateLabel.text = dateText
        cell.mainWeatherLabel.text = lastFiveDays[i].current.weather[0].main
        var icon = lastFiveDays[i].current.weather[0].icon
        cell.weatherIcon.loadImage(withUrl: URL(string: "http://openweathermap.org/img/wn/\(icon)@2x.png") ?? URL(string: "https://image.flaticon.com/icons/png/512/36/36601.png")!)
        return cell
    }
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
 
    func kelvinToF(temp: Float) -> Int {
        return Int(round(temp * (9/5) - 459.67))
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HistoryToMain" {
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
