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
                         errorMessage: "cann't be empty",
                         placeholder: "Full name",
                         checkmark: checkmark)
        nameField.textFieldDelegate = self

        emailField.config(checkType: [.email, .notEmpty],
                         errorMessage: "not a valid email",
                         placeholder: "Email",
                         checkmark: checkmark)
        emailField.textFieldDelegate = self

        passwordField.config(checkType: .length,
                             errorMessage: "6 ~ 20 characters",
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
                   isSuccess: Bool,
                   errorMessage: String?) {

        if isSuccess {
            setRightView(for: textField, type: .none, errorMessage: nil)

        } else {

            switch type {
            case HCTextFieldCheckType.email:
                setRightView(for: textField, type: .email, errorMessage: errorMessage)

            case HCTextFieldCheckType.notEmpty:
                setRightView(for: textField, type: .notEmpty, errorMessage: errorMessage)

            case HCTextFieldCheckType.length:
                setRightView(for: textField, type: .length, errorMessage: errorMessage)

            default:
                break
            }
        }
    }

    // MARK: - Private implementations

    private func setRightView(for textField: HCTextField, type: HCTextFieldCheckType, errorMessage: String?) {
        guard let message = errorMessage else {
            textField.rightViewMode = .never
            return
        }

        if type.contains(.none) {
            textField.rightViewMode = .never
        } else {
            textField.rightViewMode = .unlessEditing
        }

        let attrText = NSMutableAttributedString(string: message,
                                                 attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 13)])
        attrText.append(NSMutableAttributedString(string: "      .",
                                                  attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 2)]))

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: textField.frame.size.height - 10))
        label.textAlignment = .right
        label.textColor = .red
        label.attributedText = attrText

        textField.rightView = label
    }

}

extension ViewController: HCTextFieldManagerDelegate {

    func textFieldManager(_ manager: HCTextFieldManager, lastTextFieldDidPressReturnKey textField: HCTextField) {
        loginButtonTapped()
    }
}
