//
//  ChangeValueViewController.swift
//  MonBaluchon
//
//  Created by Guillaume Donzeau on 18/05/2021.
//

import UIKit

class ChangeValueViewController: UIViewController {
    
    var currency:Currency!
    
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var reverse: UILabel!
    @IBOutlet weak var buttonCurrency: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var currencyPickerView: UIPickerView!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var LabelCurrency: UILabel!
    @IBOutlet weak var sumEURToConvert: UITextField!
    @IBOutlet weak var resultOfConversion: UITextField!
    
    @IBAction func customGesture(_ sender: UIGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            print("rien")
        case .ended, .cancelled:
            let currencyIndex = currencyPickerView.selectedRow(inComponent: 0)
            let currencyName = currenciesAvailable[currencyIndex]
            currency = Currency(name: currencyName)
            LabelCurrency.text = currency.name
        default:
            break
        }
    }
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        password.resignFirstResponder()
        sumEURToConvert.resignFirstResponder()
        resultOfConversion.resignFirstResponder()
        
    }
}

extension ChangeValueViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currenciesAvailable.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row:Int, forComponent component: Int)-> String? {
        return currenciesAvailable[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .whiteLarge
        }
        toggleActivityIndicator(shown: false)
        // Do any additional setup after loading the view.
    }
}

extension ChangeValueViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        password.resignFirstResponder()
        sumEURToConvert.resignFirstResponder()
        resultOfConversion.resignFirstResponder()
        return true
    }
}


extension ChangeValueViewController {
    @IBAction func getConversion(_ sender: UIButton) {
        password.resignFirstResponder()
        sumEURToConvert.resignFirstResponder()
        resultOfConversion.resignFirstResponder()
        toggleActivityIndicator(shown: true)
        createCurrency()
        ConversionService.shared.getConversion(currencyName:currency.name!) { (success, result, result2,valueOfChange) in
            self.toggleActivityIndicator(shown: false)
            if success, let result = result, let result2 = result2, let valueOfChange = valueOfChange {
                // show result
                self.update(valueCurrency: result, inverse: result2, valueOfChange: valueOfChange)
            } else {
                // print error
                self.presentAlert()
            }
        }
    }
    
    func createCurrency() {
        let currencyIndex = currencyPickerView.selectedRow(inComponent: 0)
        let currencyName = currenciesAvailable[currencyIndex]
        currency = Currency(name: currencyName)
        LabelCurrency.text = currency.name
    }
    private func toggleActivityIndicator(shown: Bool) {
        buttonCurrency.isHidden = shown
        activityIndicator.isHidden = !shown
    }
    private func update(valueCurrency: String, inverse: String, valueOfChange: Double) {
        result.text = valueCurrency
        reverse.text = inverse
        if sumEURToConvert.text != "" {
            
            if let eurToConvert = Double(sumEURToConvert.text!) {
                resultOfConversion.text = String(format: "%.2f",eurToConvert * valueOfChange)
            } else {
                sumEURToConvert.text = "0"
            }
            
        } else if resultOfConversion.text != "" {
            if let curToConvert = Double(resultOfConversion.text!) {
                sumEURToConvert.text = String(format: "%.2f",curToConvert / valueOfChange)
            } else {
                resultOfConversion.text = "0"
            }
        }
    }
    
    private func presentAlert() {
        let alertVC = UIAlertController(title: "Error", message: "The quote download failed", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC,animated: true,completion: nil)
    }
}
