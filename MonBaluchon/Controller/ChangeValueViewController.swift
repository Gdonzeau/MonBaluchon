//
//  ChangeValueViewController.swift
//  MonBaluchon
//
//  Created by Guillaume Donzeau on 18/05/2021.
//

import UIKit

class ChangeValueViewController: UIViewController {
    
    var currency:Currency!
    
    @IBOutlet weak var buttonCurrency: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var currencyPickerView: UIPickerView!
    @IBOutlet weak var labelCurrency: UILabel!
    @IBOutlet weak var sumEURToConvert: UITextField!
    @IBOutlet weak var resultOfConversion: UITextField!
    @IBOutlet weak var course: UILabel!
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
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
        labelCurrency.text = currenciesAvailable[row]
        if ConversionService.dicoCurrencies != [:] {
            if let newCurrencyText = ConversionService.dicoCurrencies[currenciesAvailable[row]] {
                update(valueOfChange: newCurrencyText)
                course.text = String(format: "%.2f" , newCurrencyText)
            }
            //  print(ConversionService.dicoCurrencies[currenciesAvailable[row]])
        }
        if ConversionService.dicoCurrencies[currenciesAvailable[row]] != 0 {
            
        }
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
            
            case.success(let valueOfChange):
                self.update(valueOfChange: valueOfChange)
                
            case.failure(let error):
                print(error)
            }
        }
        
    }
    
    private func createCurrency() {
        let currencyIndex = currencyPickerView.selectedRow(inComponent: 0)
        let currencyName = currenciesAvailable[currencyIndex]
        currency = Currency(name: currencyName)
    }
    private func toggleActivityIndicator(shown: Bool) {
        buttonCurrency.isHidden = shown
        activityIndicator.isHidden = !shown
    }
    private func update(valueOfChange: Double) {
        var newCorrectionText = ""
        course.text = String(format: "%.2f", valueOfChange)
        
        if sumEURToConvert.text != "" {
            if let correctionText = sumEURToConvert.text {
                newCorrectionText = correctionText.replacingOccurrences(of: ",", with: ".", options: .literal, range: nil) // No keyboard found with . so we change , into . to avoid error
                sumEURToConvert.text = newCorrectionText
            }
            if let eurToConvert = Double(newCorrectionText) {
                resultOfConversion.text = String(format: "%.2f",eurToConvert * valueOfChange)// 2 digits after the point
            } else {
                sumEURToConvert.text = "0"
            }
            
        } else if resultOfConversion.text != "" {
            if let correctionText = resultOfConversion.text {
                newCorrectionText = correctionText.replacingOccurrences(of: ",", with: ".", options: .literal, range: nil) // No keyboard found with . so we change , into . to avoid error
                resultOfConversion.text = newCorrectionText
            }
            
            if let curToConvert = Double(newCorrectionText) {
                sumEURToConvert.text = String(format: "%.2f",curToConvert / valueOfChange)// 2 digits after the point
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
