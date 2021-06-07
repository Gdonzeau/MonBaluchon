//
//  TranslationViewController.swift
//  MonBaluchon
//
//  Created by Guillaume Donzeau on 19/05/2021.
//

import UIKit

class TranslationViewController: UIViewController {
    
    var language:Language!
    var languageCode = ""
    @IBOutlet weak var textToTranslate: UITextView!
    @IBOutlet weak var translation: UITextView!
    
    @IBOutlet weak var languagesPickerView: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var buttonTranslation: UIButton!
    
    override func viewDidLoad() {
        toggleActivityIndicator(shown: false)
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .whiteLarge
        }
        textToTranslate.text = ""
        // Do any additional setup after loading the view.
    }
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textToTranslate.resignFirstResponder()
    }
    
    @IBAction func tranlation(_ sender: UIButton) {
        pleaseTranslate()
    }
    
    func pleaseTranslate() {
        toggleActivityIndicator(shown: true)
        if let text = textToTranslate.text {
            guard text != "" else {
                allErrors(errorMessage: "You must write something.")
                return
            }
            guard let httpString = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
                allErrors(errorMessage: "The quote download failed.")
                return
            }
            textToTranslate.resignFirstResponder()
            chooseLanguage()
            
            TranslationService.shared.getTranslation(toLanguage: languageCode, text:httpString) {
                result in
                self.toggleActivityIndicator(shown: false)
                switch result {
                
                case.success(let translation):
                    self.update(result: translation)
                    
                case.failure(let error):
                    print(error)
                }
            }
        }
    }
}
extension TranslationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languagesAvailable.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row:Int, forComponent component: Int)-> String? {
        return languagesAvailable[row]
    }
}

extension TranslationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textToTranslate.resignFirstResponder()
        return true
    }
}

extension TranslationViewController {
    func chooseLanguage() {
        let languageIndex = languagesPickerView.selectedRow(inComponent: 0)
        let languageName = languagesAvailable[languageIndex]
        language = Language(code: languagesSet[languageName])
        if let languageChoosen = language.code {
            languageCode = languageChoosen
            print("Code: \(languageCode)")
        }
    }
    private func toggleActivityIndicator(shown: Bool) {
        buttonTranslation.isHidden = shown
        activityIndicator.isHidden = !shown
    }
    private func nothingWrittenAlert() {
        let alertVC = UIAlertController(title: "Error", message: "You must write something", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC,animated: true,completion: nil)
    }
    private func update(result: String) {
        translation.text = result
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

