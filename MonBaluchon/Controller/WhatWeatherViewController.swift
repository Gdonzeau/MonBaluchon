//
//  WhatWeatherViewController.swift
//  MonBaluchon
//
//  Created by Guillaume Donzeau on 19/05/2021.
//

import UIKit

class WhatWeatherViewController: UIViewController {
    
    @IBOutlet weak var townName: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var showWeather: UILabel!
    @IBOutlet weak var getWeather: UIButton!
    @IBOutlet weak var map: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleActivityIndicator(shown: false)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func getWeatherButton(_ sender: UIButton) {
        toggleActivityIndicator(shown: true)
        
        guard townName.text != "" else {
            toggleActivityIndicator(shown: false)
            allErrors(errorMessage: "You must write something.")
            return
        }
        
        guard let town = townName.text else {
            allErrors(errorMessage: "Nom de ville non trouvé.")
            return
        }
        print (town)
        if let httpString = town.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            townName.resignFirstResponder()
            WeatherService.shared.getWeather(town: httpString) {
                (success, result) in
                self.toggleActivityIndicator(shown: false)
                //longitude, latitude, vitesseVent, provenance du vent, nomVille,température,ressenti,tempmin, tempmax,pressure, humidity, temp
                if success, let lon = result[0], let lat = result[1], let windSpeed = result[2], let windDeg = result[3], let townName = result[4], let temperature = result[5], let ressenti = result[6], let temperatureMin = result[7], let temperatureMax = result[9], let pression = result[10], let humidity = result[8], let iconUrl = result[17] {
                    let descriptionWeather = "À \(townName), de lat: \(lat) et de long: \(lon), le vent vient du \(windDeg), avec une vitesse de \(windSpeed) m/s soit \(Int(windSpeed as! Double*3.6)) km/h. La température est de \(Int(temperature as! Double - 273.5)) avec une T.min de \(Int(temperatureMin as! Double - 273.5)) et une T.max de \(Int(temperatureMax as! Double - 273.5)) et une température ressentie de \(Int(ressenti as! Double - 273.5)). La pression est de \(pression) ha. L'humidité est de \(humidity)."
                    self.update(result: descriptionWeather, iconUrl: iconUrl as! URL)
                } else {
                    // print error
                    self.presentAlert()
                }
            }
        } else {
            print("Pas de ville")
        }
        //  }
    }
    
    @IBAction func dismissKeyborad(_ sender: UITapGestureRecognizer) {
        townName.resignFirstResponder()
    }
    
}
extension WhatWeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        townName.resignFirstResponder()
        return true
    }
}
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            guard let data = try? Data(contentsOf: url) else {
                return
            }
            //if let data = try? Data(contentsOf: url) {
            guard let image = UIImage(data:data) else {
                return
            }
            //  if let image = UIImage(data: data) {
            DispatchQueue.main.async {
                self?.image = image
            }
            //  }
            // }
        }
    }
}
extension WhatWeatherViewController {
    
    private func toggleActivityIndicator(shown: Bool) {
        getWeather.isHidden = shown
        activityIndicator.isHidden = !shown
    }
    private func nothingWrittenAlert() {
        let alertVC = UIAlertController(title: "Error", message: "You must write something", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC,animated: true,completion: nil)
    }
    private func update(result: String, iconUrl:URL) {
        showWeather.text = result
        map.load(url: iconUrl)
    }
    private func presentAlert() {
        let alertVC = UIAlertController(title: "Error", message: "The quote download failed", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC,animated: true,completion: nil)
    }
    private func allErrors(errorMessage: String) {
        let alertVC = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC,animated: true,completion: nil)
    }
    
}
