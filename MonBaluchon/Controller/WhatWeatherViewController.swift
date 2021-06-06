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
        getTheWeather()
        
        //getTheWeatherDefault()
    }
    
    @IBAction func dismissKeyborad(_ sender: UITapGestureRecognizer) {
        townName.resignFirstResponder()
        villeParDefault.resignFirstResponder()
    }
    
    func getTheWeather() {
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
      //  if let httpString = town.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            townName.resignFirstResponder()
            WeatherService.shared.getWeather(town: town) {
                message in
                
                self.toggleActivityIndicator(shown: false)
                switch message {
                case.success(let results):
                    
                    guard let weatherdescription = results[0] else {
                        return
                    }
                    guard let iconUrl = results[1] else {
                        return
                    }
                    guard let url = URL(string: iconUrl) else {
                        print("Bad URL")
                        return
                    }
                    self.update(result: weatherdescription, iconUrl: url)
                    
                case.failure(let error):
                    print(error)
                    return
                }
            }
          /*
        } else {
            print("Pas de ville")
        }
        */
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
        
       // if let httpString = town.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            villeParDefault.resignFirstResponder()
            WeatherService.shared.getWeather(town: town) {
                message in
                
                self.toggleActivityIndicator(shown: false)
                switch message {
                case.success(let results):
                    
                    guard let weatherdescription = results[0] else {
                        return
                    }
                    guard let iconUrl = results[1] else {
                        return
                    }
                    guard let url = URL(string: iconUrl) else {
                        print("Bad URL")
                        return
                    }
                    self.updateDefault(result: weatherdescription, iconUrl: url)
                    
                case.failure(let error):
                    print(error)
                    return
                }
            }
            /*
        } else {
            print("Pas de ville")
        }
 */
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
