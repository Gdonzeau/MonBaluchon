//
//  ChangeValueViewController.swift
//  MonBaluchon
//
//  Created by Guillaume Donzeau on 18/05/2021.
//

import UIKit

class ChangeValueViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  
    @IBAction func getConversion(_ sender: UIButton) {
        ConversionService.getConversion()
    }
}
