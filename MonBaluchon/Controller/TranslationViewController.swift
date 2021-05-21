//
//  TranslationViewController.swift
//  MonBaluchon
//
//  Created by Guillaume Donzeau on 19/05/2021.
//

import UIKit

class TranslationViewController: UIViewController {
    
    @IBOutlet weak var textToTranslate: UITextField!
    @IBOutlet weak var translation: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var buttonTranslation: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        textToTranslate.text = ""
        // Do any additional setup after loading the view.
    }
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textToTranslate.resignFirstResponder()
    }
    @IBAction func tranlation(_ sender: UIButton) {
        if let text = textToTranslate.text {
            print(text)
            if let superNewString = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) { //String(data: text.data(using: .utf8)!, encoding: .windowsCP1250) {
                //let newString = text.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
                print(superNewString)
                textToTranslate.resignFirstResponder()
                TranslationService.getTranslation(text:superNewString) {
                    (success, result) in
                    self.toggleActivityIndicator(shown: false)
                    if success, let result = result {
                        self.update(result: result)
                    } else {
                        // print error
                        self.presentAlert()
                    }
                }
            } else {
                nothingWrittenAlert()
            }
        }
    }
}

extension TranslationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textToTranslate.resignFirstResponder()
        return true
    }
}

extension TranslationViewController {
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
}

