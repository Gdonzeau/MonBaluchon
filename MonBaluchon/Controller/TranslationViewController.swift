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
    
    private let urlBase = "https://translation.googleapis.com/language/translate/v2?"
    private let authorization = "&key="
    private var code = Keys.translation
    private var askForWord = "q="
    private var askForLanguage = "&target="
    private var format = "&format=html"
    
    
    
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
            //var toTranslate = ""
            let word = "\(text)"
            
            print("word :\(word)")
            
            guard let httpString = word.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
                allErrors(errorMessage:"Bad url.")
                return
            }
            
            textToTranslate.resignFirstResponder()
            chooseLanguage()
            
            let stringAdress = urlBase + askForWord + httpString + askForLanguage + languageCode + authorization + code.rawValue + format
            
            
            TranslationService.shared.getTranslation(stringAdress : stringAdress) {
                result in
                self.toggleActivityIndicator(shown: false)
                switch result {
                
                case.success(let translation):
                    
                    let wordTranslated = translation.data.translations[0].translatedText
                    
                    self.update(result: wordTranslated)
                    
                case.failure(let error):
                    self.allErrors(errorMessage: error.rawValue)
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
        return Config.Language.languagesAvailable.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row:Int, forComponent component: Int)-> String? {
        return Config.Language.languagesAvailable[row]
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
        let languageName = Config.Language.languagesAvailable[languageIndex]
        language = Language(code: Config.Language.languagesSet[languageName])
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

