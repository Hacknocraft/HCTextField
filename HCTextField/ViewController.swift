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

    override func viewDidLoad() {
        super.viewDidLoad()

        nameField.setCheckType(.notEmpty, errorMessage: "cann't be empty")
        nameField.textFieldDelegate = self

        emailField.setCheckType([.email, .notEmpty], errorMessage: "not a valid email")
        emailField.textFieldDelegate = self

        passwordField.setCheckType(.length, errorMessage: "6 ~ 20 characters", minLength: 6, maxLength: 20)
        passwordField.textFieldDelegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Actions

    @IBAction func loginButtonTapped() {
        HCTextField.resignFirstResponder()

        var title = ""
        var message: String?

        if HCTextField.allChecksPassed {
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
                   errorMessage: String?,
                   success: Bool) {

        if success {
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
