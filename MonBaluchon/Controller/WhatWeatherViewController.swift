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
        getTheWeather()
    }
    
    @IBAction func dismissKeyborad(_ sender: UITapGestureRecognizer) {
        townName.resignFirstResponder()
    }
    
    func getTheWeather() {
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
            var result0 = ""
            var result1 = ""
            var onVaYArriver = URL(string: "")
            townName.resignFirstResponder()
            WeatherService.shared.getWeather(town: httpString) {
                message in
                
                self.toggleActivityIndicator(shown: false)
                switch message {
                case.success(let results):
                    if let finalResult = results[0] {
                        result0 = finalResult
                    }
                    if let iconUrl = results[1] {
                        result1 = iconUrl
                    }
                    if let optionnel = URL(string:result1) {
                    onVaYArriver = optionnel
                    }
                    // Ici pourquoi faut-il un déballage multiple. En particulier, on a un String qu'on met dans une adresse. Malgré tout xcode exige son ! ou son option ?? pour fonctionner.
                    self.update(result: result0, iconUrl: onVaYArriver!)
                    
                case.failure(let error):
                    print(error)
                    return
                }
                
                //longitude, latitude, vitesseVent, provenance du vent, nomVille,température,ressenti,tempmin, tempmax,pressure, humidity, temp
               // self.buildStringAnswer(result: results)
            }
        } else {
            print("Pas de ville")
        }
        //  }
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
    }
    private func allErrors(errorMessage: String) {
        let alertVC = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC,animated: true,completion: nil)
    }
    
}
