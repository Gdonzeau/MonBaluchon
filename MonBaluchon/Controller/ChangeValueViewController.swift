//
//  ChangeValueViewController.swift
//  MonBaluchon
//
//  Created by Guillaume Donzeau on 18/05/2021.
//

import UIKit

class ChangeValueViewController: UIViewController {
    
    var currency:Currency!
    var currencyBase:Currency!
    /*
    private let urlBase = "http://data.fixer.io/api/latest?"
    private let authorization = "&access_key="
    private var code = Keys.change
    //private var value = "USD"
    */
    private var dicoCurrencies:[String:Double] = [:]
    
    @IBOutlet weak var buttonCurrency: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var currencyPickerView: UIPickerView!
    @IBOutlet weak var labelCurrencyOrigin: UILabel!
    @IBOutlet weak var labelCurrency: UILabel!
    @IBOutlet weak var sumEURToConvert: UITextField!
    @IBOutlet weak var resultOfConversion: UITextField!
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        sumEURToConvert.resignFirstResponder()
        resultOfConversion.resignFirstResponder()
    }
    @IBAction func getConversion(_ sender: UIButton) {
        conversion()
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

extension ChangeValueViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // print("1")
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // print("2")
        return Config.Currency.currenciesAvailable.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row:Int, forComponent component: Int)-> String? {
        // print("3")
        return Config.Currency.currenciesAvailable[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("4")
        labelCurrencyOrigin.text = Config.Currency.currenciesAvailable[pickerView.selectedRow(inComponent: 0)]
        labelCurrency.text = Config.Currency.currenciesAvailable[pickerView.selectedRow(inComponent: 1)]
        
        if dicoCurrencies != [:] {
            if let newCurrencyText = dicoCurrencies[Config.Currency.currenciesAvailable[pickerView.selectedRow(inComponent: 1)]], let currencyFrom = dicoCurrencies[Config.Currency.currenciesAvailable[pickerView.selectedRow(inComponent: 0)]]{
                update(valueOfChange: newCurrencyText,currencyFrom: currencyFrom)
            }
        }
    }
}

extension ChangeValueViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sumEURToConvert.resignFirstResponder()
        resultOfConversion.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) { // to reset TextFields
        sumEURToConvert.text = ""
        resultOfConversion.text = ""
    }
}

// MARK: - Private methods

extension ChangeValueViewController {
    
    
    private func conversion() {
        sumEURToConvert.resignFirstResponder()
        resultOfConversion.resignFirstResponder()
        toggleActivityIndicator(shown: true)
        createCurrency()
        
        let stringAdress = Config.Currency.urlBase + Config.Currency.authorization + Config.Currency.code.rawValue
        
        ConversionService.shared.getConversion(stringAdress: stringAdress) { result in
            self.toggleActivityIndicator(shown: false)
            switch result {
            
            case.success(let data):
                self.prepareUpdate(data: data)
            case.failure(let error):
                self.allErrors(errorMessage: error.rawValue)
            }
        }
    }
    
    private func prepareUpdate(data: RatesOnLine) {
        
        self.dicoCurrencies = data.rates // Petite idée...
        guard let currencyFrom = self.labelCurrencyOrigin.text, let currencyTo = self.labelCurrency.text else {
            return
        }
        guard let currencyFromValue = self.dicoCurrencies[currencyFrom], let currencyToValue = self.dicoCurrencies[currencyTo] else {
            return
        }
        self.update(valueOfChange: currencyToValue, currencyFrom: currencyFromValue)
    }
    
    private func createCurrency() {
        
        let currencyIndex = currencyPickerView.selectedRow(inComponent: 1)
        let currencyName = Config.Currency.currenciesAvailable[currencyIndex]
        currency = Currency(name: currencyName)
        
        let currencyOrigin = currencyPickerView.selectedRow(inComponent: 0)
        let currencyOriginName = Config.Currency.currenciesAvailable[currencyOrigin]
        currencyBase = Currency(name: currencyOriginName)
    }
    private func toggleActivityIndicator(shown: Bool) {
        buttonCurrency.isHidden = shown
        activityIndicator.isHidden = !shown
    }
    private func update(valueOfChange: Double, currencyFrom: Double) {
        var newCorrectionText = ""
        
        if sumEURToConvert.text != "" {
            if let correctionText = sumEURToConvert.text { // Get a available format
                newCorrectionText = correctionText.replacingOccurrences(of: ",", with: ".", options: .literal, range: nil) // No keyboard found with . so we change , into . to avoid error
                sumEURToConvert.text = newCorrectionText
            }
            if let eurToConvert = Double(newCorrectionText) {
                resultOfConversion.text = String(format: "%.2f",(eurToConvert / currencyFrom) * valueOfChange)// 2 digits after the point
            } else {
                sumEURToConvert.text = "0"
            }
            
        } else if resultOfConversion.text != "" {
            if let correctionText = resultOfConversion.text {
                newCorrectionText = correctionText.replacingOccurrences(of: ",", with: ".", options: .literal, range: nil) // No keyboard found with . so we change , into . to avoid error
                resultOfConversion.text = newCorrectionText
            }
            
            if let curToConvert = Double(newCorrectionText) {
                sumEURToConvert.text = String(format: "%.2f",(curToConvert / valueOfChange) * currencyFrom)// 2 digits after the point
            } else {
                resultOfConversion.text = "0"
            }
        }
    }
    
    private func allErrors(errorMessage: String) {
        let alertVC = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC,animated: true,completion: nil)
    }
}
