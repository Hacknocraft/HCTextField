//
//  HCTextFieldManager.swift
//  HCTextField
//
//  Created by Lebron on 09/05/2017.
//  Copyright © 2017 Hacknocraft. All rights reserved.
//

import UIKit

open class HCTextFieldManager: NSObject {

    public weak var delegate: HCTextFieldManagerDelegate?

    open var textFields: [HCTextField]

    /// Creates a HCTextFieldManager with several HCTextFields
    ///
    /// - parameter textFields: the textFields you want to be managed, should be correctly ordered
    public init(textFields: [HCTextField]) {
        self.textFields = textFields
        super.init()

        if textFields.count == 1 {

            textFields[0].delegate = self

        } else if textFields.count > 1 {

            for i in 0...(textFields.count - 1) {

                textFields[i].delegate = self
                // setup returnKeyType to ".next" except the last one (so user can customize it)
                if i != (textFields.count - 1) {
                    textFields[i].returnKeyType = .next
                }
            }
        }
    }

    open func isAllTextFieldsPassedCheck() -> Bool {
        resignFirstResponderForAllTextFields()

        for textField in textFields where textField.passedCheck == false {
            return false
        }

        return true
    }

    // MARK: - Private implementations

    private func resignFirstResponderForAllTextFields() {
        textFields.forEach { (textField) in
            _ = textField.resignFirstResponder()
        }
    }
}

// MARK: - UITextFieldDelegate
extension HCTextFieldManager: UITextFieldDelegate {

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField.returnKeyType == .next,
            let indexOfCurrentTextField = textFields.index(where: { return $0 == textField }),
            indexOfCurrentTextField < textFields.count - 1 {

            let nextTextField = textFields[indexOfCurrentTextField + 1]
            _ = nextTextField.becomeFirstResponder()

        } else if let lastTextField = textFields.last {

            _ = lastTextField.resignFirstResponder()
            delegate?.textFieldManager?(self, lastTextFieldDidPressReturnKey: lastTextField)
        }

        return true
    }
}

// MARK: - HCTextFieldManagerDelegate
@objc public protocol HCTextFieldManagerDelegate: class {

    /// called after the last textField has pressed return key
    @objc optional func textFieldManager(_ manager: HCTextFieldManager,
                                         lastTextFieldDidPressReturnKey textField: HCTextField)
}
