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
}

extension ChangeValueViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       // print("1")
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       // print("2")
        return currenciesAvailable.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row:Int, forComponent component: Int)-> String? {
       // print("3")
        return currenciesAvailable[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("4")
        labelCurrencyOrigin.text = currenciesAvailable[pickerView.selectedRow(inComponent: 0)]
        labelCurrency.text = currenciesAvailable[pickerView.selectedRow(inComponent: 1)]
        
        if dicoCurrencies != [:] {
            if let newCurrencyText = dicoCurrencies[currenciesAvailable[pickerView.selectedRow(inComponent: 1)]], let currencyFrom = dicoCurrencies[currenciesAvailable[pickerView.selectedRow(inComponent: 0)]]{
                update(valueOfChange: newCurrencyText,currencyFrom: currencyFrom)
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .whiteLarge
        }
        /*
        // Calendrier
        let lastDay = CurrentDay.lastDateUsed
        calendar()
        print("Test : \(CurrentDay.lastDateUsed)")
        
        // Fin Calendrier
        */
        toggleActivityIndicator(shown: false)
        // Do any additional setup after loading the view.
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

extension ChangeValueViewController {
    
    @IBAction func getConversion(_ sender: UIButton) {
        conversion()
    }
    
    func conversion() {
        sumEURToConvert.resignFirstResponder()
        resultOfConversion.resignFirstResponder()
        toggleActivityIndicator(shown: true)
        createCurrency()
        
        guard let currencyChosen = currency.name else {
            allErrors(errorMessage: "Currency unknown")
            return
        }
        
        ConversionService.shared.getConversion(currencyName:currencyChosen) { result in
            self.toggleActivityIndicator(shown: false)
            switch result {
            
            case.success(let data):
               // if let valueOfChange = data.rates[currencyChosen] {
                    self.dicoCurrencies = data.rates // Petite idée...
               // }
                
                guard let currencyFrom = self.labelCurrencyOrigin.text, let currencyTo = self.labelCurrency.text else {
                    return
                }
                
                guard let currencyFromValue = self.dicoCurrencies[currencyFrom], let currencyToValue = self.dicoCurrencies[currencyTo] else {
                    return
                }
                
                
                self.update(valueOfChange: currencyToValue, currencyFrom: currencyFromValue)
                
            case.failure(let error):
                self.allErrors(errorMessage: error.rawValue)
            }
        }
    }
    
    private func createCurrency() {
        
        let currencyIndex = currencyPickerView.selectedRow(inComponent: 1)
        let currencyName = currenciesAvailable[currencyIndex]
        currency = Currency(name: currencyName)
        
        let currencyOrigin = currencyPickerView.selectedRow(inComponent: 0)
        let currencyOriginName = currenciesAvailable[currencyOrigin]
        currencyBase = Currency(name: currencyOriginName)
    }
    private func toggleActivityIndicator(shown: Bool) {
        buttonCurrency.isHidden = shown
        activityIndicator.isHidden = !shown
    }
    private func update(valueOfChange: Double, currencyFrom: Double) {
        var newCorrectionText = ""
      //  course.text = String(format: "%.2f", valueOfChange * currencyFrom)
        
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
    func calendar() {
        // get the current date and time
        let currentDateTime = Date()
        // get the user's calendar
        let userCalendar = Calendar.current
        // choose which date and time components are needed
        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day
        ]

        // get the components
        let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)

        // now the components are available
        guard let year = dateTimeComponents.year else {
            return
        }
        guard let month = dateTimeComponents.month else {
            return
        }
        guard let day = dateTimeComponents.day else {
            return
        }
        CurrentDay.year = String(year)
        CurrentDay.month = String(month)
        CurrentDay.day = String(day)
        
        
    }
    
    private func allErrors(errorMessage: String) {
        let alertVC = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC,animated: true,completion: nil)
    }
}
