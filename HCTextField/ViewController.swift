//
//  ViewController.swift
//  HCTextField
//
//  Created by HAO WANG on 5/4/17.
//  Copyright © 2017 Hacknocraft. All rights reserved.
//

import UIKit

class ViewController: UIViewController, HCTextFieldDelegate {

    @IBOutlet weak var nameField: HCTextField!
    @IBOutlet weak var emailField: HCTextField!
    @IBOutlet weak var passwordField: HCTextField!

    var textFieldManager: HCTextFieldManager?

    override func viewDidLoad() {
        super.viewDidLoad()

        let checkmark = UIImage(named: "checkmark")

        nameField.config(checkType: .notEmpty,
                         placeholder: "Full name",
                         checkmark: checkmark)
        nameField.textFieldDelegate = self

        emailField.config(checkType: [.email, .notEmpty],
                         placeholder: "Email",
                         checkmark: checkmark)
        emailField.textFieldDelegate = self

        passwordField.config(checkType: .length,
                             placeholder: "Password",
                             checkmark: checkmark,
                             minLength: 6,
                             maxLength: 20)
        passwordField.textFieldDelegate = self

        textFieldManager = HCTextFieldManager(textFields: [nameField, emailField, passwordField])
        textFieldManager?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Actions

    @IBAction func loginButtonTapped() {
        var title = ""
        var message: String?

        if let manager = textFieldManager, manager.isAllTextFieldsPassedCheck() {
            title = "Login Successfully"
            message = nil
        } else {
            title = "Error"
            message = "Please fill in the fields as required"
        }

        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (_) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(ok)

        present(alertVC, animated: true, completion: nil)
    }

    // MARK: - HCTextFieldDelegate

    func textField(_ textField: HCTextField,
                   didCheckFor type: HCTextFieldCheckType,
                   isSuccess: Bool) {

        if isSuccess {
            textField.showErrorMessageOnRightView(nil)

        } else {

            var errorMessage = ""
            switch type {
            case HCTextFieldCheckType.email:
                errorMessage = "Not a valid email"

            case HCTextFieldCheckType.notEmpty:
                errorMessage = "Cann't be empty"

            case HCTextFieldCheckType.length:
                errorMessage = "6~20 characters"

            default:
                break
            }

            textField.showErrorMessageOnRightView(errorMessage)
        }
    }

    // MARK: - Private implementations

}

extension ViewController: HCTextFieldManagerDelegate {

    func textFieldManager(_ manager: HCTextFieldManager, lastTextFieldDidPressReturnKey textField: HCTextField) {
        loginButtonTapped()
    }
}
