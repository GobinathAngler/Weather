//
//  WeatherReportViewController.swift
//  weatherTasks
//
//  Created by Premkumar Arul on 15/10/22.
//

import UIKit
import CoreLocation

class WeatherReportViewController: UIViewController,WeatherManagerDelegate {
    
    var SelectedCityLoc = String()
    var weatherManager = WeatherManager()
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var conditionImage: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var humidityLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        loader.startAnimating()
        weatherManager.fetchWeather(cityName: SelectedCityLoc)
    }
    
    // MARK: - WeatherManagerDelegate
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        
        DispatchQueue.main.async {
            self.loader.stopAnimating()
            self.loader.isHidden = true
            let icon = weather.icon
            
            if icon.contains("n") {
                
                self.conditionImage.image = UIImage.init(systemName: weather.nightConditionName)
                
            } else if icon.contains("d") {
                
                self.conditionImage.image = UIImage.init(systemName: weather.dayConditionName)
            }
            
            self.descriptionLabel.text = weather.description
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.currentTemperatureString
            self.feelsLikeLabel.text = weather.feelsLikeString + " ºC"
            self.pressureLabel.text = weather.pressureString + " hPa"
            self.humidityLabel.text = weather.humidityString + " %"
            self.minTemperatureLabel.text = weather.lowTemperatureString + " ºC"
            self.maxTemperatureLabel.text = weather.highTemperatureString + " ºC"
        }
    }
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            self.loader.stopAnimating()
            self.loader.isHidden = true
        self.view.makeToast("Something Went Wrong In Fetching Error Please Try Later!!!", duration: 3.0, position: .center)
        }

        
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


