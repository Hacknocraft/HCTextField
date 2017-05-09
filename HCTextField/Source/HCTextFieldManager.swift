//
//  HCTextFieldManager.swift
//  HCTextField
//
//  Created by Lebron on 09/05/2017.
//  Copyright © 2017 Hacknocraft. All rights reserved.
//

import UIKit

open class HCTextFieldManager: NSObject {

    open static let shared = HCTextFieldManager()
    open var allTextFieldsPassedCheck: Bool {
        return wereAllTextFieldsPassedCheck()
    }
    private var textFields = [HCTextField]()

    open func addTextFields(_ textFields: [HCTextField]) {
        self.textFields.append(contentsOf: textFields)
    }

    // MARK: - Private implementations

    private func wereAllTextFieldsPassedCheck() -> Bool {
        resignFirstResponder()

        for textField in textFields where textField.passedCheck == false {
            return false
        }

        return true
    }

    private func resignFirstResponder() {
        textFields.forEach { (textField) in
            _ = textField.resignFirstResponder()
        }
    }
}
