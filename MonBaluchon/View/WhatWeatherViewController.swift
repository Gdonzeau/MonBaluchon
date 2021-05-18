//
//  WhatWeatherViewController.swift
//  MonBaluchon
//
//  Created by Guillaume Donzeau on 19/05/2021.
//

import UIKit

class WhatWeatherViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func getWeather(_ sender: UIButton) {
        WeatherService.getWeather()
    }
    
}
