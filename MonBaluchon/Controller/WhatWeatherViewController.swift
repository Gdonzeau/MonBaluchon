//
//  WhatWeatherViewController.swift
//  MonBaluchon
//
//  Created by Guillaume Donzeau on 19/05/2021.
//

import UIKit

class WhatWeatherViewController: UIViewController {
    //var defaultTown = "New York"
    @IBOutlet weak var townName: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var showWeather: UILabel!
    @IBOutlet weak var getWeather: UIButton!
    @IBOutlet weak var map: UIImageView!
    @IBOutlet weak var mapDefault: UIImageView!
    @IBOutlet weak var showWeatherDefault: UILabel!
    @IBOutlet weak var villeParDefault: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleActivityIndicator(shown: false)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func getWeatherButton(_ sender: UIButton) {
        let towns = [townName!,villeParDefault!]
        getTheWeather(townName: townName!)
        
        //getTheWeatherDefault()
    }
    
    @IBAction func dismissKeyborad(_ sender: UITapGestureRecognizer) {
        townName.resignFirstResponder()
        villeParDefault.resignFirstResponder()
    }

    func getTheWeather(townName: UITextField!) {
        toggleActivityIndicator(shown: true)

        guard townName.text != "" else {
            toggleActivityIndicator(shown: false)
            allErrors(errorMessage: "You must write something.")
            return
        }
        guard let town = townName.text else {
            allErrors(errorMessage: "Town's name incorrect.")
            return
        }
        townName.resignFirstResponder()
        WeatherService.shared.getWeather(town: town) {
            message in

            self.toggleActivityIndicator(shown: false)
            switch message {
            case.success(let results):
                print("results reçu : \(results)")
                let iconUrl = "http://openweathermap.org/img/w/\(results.weather[0].icon).png"

                guard let url = URL(string: iconUrl) else {
                    print("Bad URL")
                    return
                }
                let weatherData = [results.name,results.main.temp,results.weather[0].weatherDescription] as [Any]

                self.update(result: self.buildStringAnswer(result: weatherData), iconUrl: url)

            case.failure(let error):
                print(error)
                return
            }
        }
    }

    func getTheWeatherDefault() {
        toggleActivityIndicator(shown: true)
        
        guard villeParDefault.text != "" else {
            toggleActivityIndicator(shown: false)
            allErrors(errorMessage: "You must write something.")
            return
        }
        guard let town = villeParDefault.text else {
            allErrors(errorMessage: "Town's name incorrect.")
            return
        }

        villeParDefault.resignFirstResponder()
        WeatherService.shared.getWeather(town: town) {
            message in

            self.toggleActivityIndicator(shown: false)
            switch message {
            case.success(let results):
                let iconUrl = "http://openweathermap.org/img/w/\(results.weather[0].icon).png"
                
                guard let url = URL(string: iconUrl) else {
                    print("Bad URL")
                    return
                }
                let weatherdata = [results.name,results.main.temp,results.weather[0].weatherDescription] as [Any]

                self.updateDefault(result: self.buildStringAnswer(result: weatherdata), iconUrl: url)

            case.failure(let error):
                self.allErrors(errorMessage: error.rawValue)
            }
        }
    }
}
extension WhatWeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        townName.resignFirstResponder()
        villeParDefault.resignFirstResponder()
        return true
    }
}
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            guard let data = try? Data(contentsOf: url) else {
                return
            }
            guard let image = UIImage(data:data) else {
                return
            }
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}
extension WhatWeatherViewController {

    func buildStringAnswer(result: [Any])-> String {
        let townName = result[0]
        let temperature = result[1]
        let description = result[2]
        let descriptionWeather = "\(townName), \n temperature : \n \(Int(temperature as! Double)) degrees \n and weather is \n \(description)"
        return descriptionWeather
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        getWeather.isHidden = shown
        activityIndicator.isHidden = !shown
    }
    private func update(result: String, iconUrl:URL) {
        showWeather.text = result
        map.load(url: iconUrl)
        getTheWeatherDefault()
    }
    private func updateDefault(result: String, iconUrl:URL) {
        showWeatherDefault.text = result
        mapDefault.load(url: iconUrl)
    }
    private func allErrors(errorMessage: String) {
        let alertVC = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC,animated: true,completion: nil)
    }
}
