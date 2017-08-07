//
//  HCTextField.swift
//  HCTextField
//
//  Created by HAO WANG on 5/4/17.
//  Copyright © 2017 Hacknocraft. All rights reserved.
//

import UIKit
import Foundation

private let kMinLength = 4
private let kMaxLength = 50

private enum HCTextFieldType {
    case normal
    case highlighted
    case error
}

public struct HCTextFieldBorderColor {
    static var normal: UIColor = .gray
    static var highlighted: UIColor = .orange
    static var error: UIColor = .red
}

public struct HCTextFieldCheckType: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    /// don't perform any check
    public static let none = HCTextFieldCheckType(rawValue: 1 << 0)
    /// check if input is valid email
    public static let email = HCTextFieldCheckType(rawValue: 1 << 1)
    /// check content length
    public static let length = HCTextFieldCheckType(rawValue: 1 << 2)
    /// check if a put was missing
    public static let notEmpty = HCTextFieldCheckType(rawValue: 1 << 3)
}

open class HCTextField: UITextField {

    open var checkType: HCTextFieldCheckType = .notEmpty
    open var errorMessage: String?
    open var minLength: Int = kMinLength
    open var maxLength: Int = kMaxLength
    open var passedCheck: Bool = false
    open var checkmark: UIImage?
    weak open var textFieldDelegate: HCTextFieldDelegate?

    private var rightContainerView: UIView?

    // MARK: - Initializers & setup data

    public init(frame: CGRect,
                checkType: HCTextFieldCheckType,
                errorMessage: String?,
                placeholder: String?,
                checkmark: UIImage?,
                minLength: Int? = nil,
                maxLength: Int? = nil) {
        super.init(frame: frame)
        config(checkType: checkType,
               errorMessage: errorMessage,
               placeholder: placeholder,
               checkmark: checkmark,
               minLength: minLength,
               maxLength: maxLength)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setBorder(for: .normal)
    }

    open func config(checkType: HCTextFieldCheckType,
                     errorMessage: String?,
                     placeholder: String?,
                     checkmark: UIImage?,
                     minLength: Int? = nil,
                     maxLength: Int? = nil) {

        self.placeholder = placeholder
        self.checkmark = checkmark
        self.checkType = checkType
        self.errorMessage = errorMessage
        self.setBorder(for: .normal)
        self.minLength = minLength ?? kMinLength
        self.maxLength = maxLength ?? kMaxLength
    }

    // MARK: - Override methods

    open override func becomeFirstResponder() -> Bool {
        setBorder(for: .highlighted)

        passedCheck = false
        removeCheckmark()

        return super.becomeFirstResponder()
    }

    open override func resignFirstResponder() -> Bool {

        if checkType.contains(.email) && !isEmail(text) {

            passedCheck = false
            setBorder(for: .error)
            textFieldDelegate?.textField(self, didCheckFor: .email, isSuccess: false, errorMessage: errorMessage)

        } else if checkType.contains(.length) && !satisfiesLengthRequirement(text) {

            passedCheck = false
            setBorder(for: .error)
            textFieldDelegate?.textField(self, didCheckFor: .length, isSuccess: false, errorMessage: errorMessage)

        } else if checkType.contains(.notEmpty) && isEmpty(text) {

            passedCheck = false
            setBorder(for: .error)
            textFieldDelegate?.textField(self, didCheckFor: .notEmpty, isSuccess: false, errorMessage: errorMessage)

        } else {

            passedCheck = true
            setBorder(for: .normal)
            textFieldDelegate?.textField(self, didCheckFor: .none, isSuccess: true, errorMessage: nil)
            addCheckmark()
        }

        return super.resignFirstResponder()
    }

    // MARK: - Private implementations

    private func isEmail(_ text: String?) -> Bool {
        guard let email = text else { return false }

        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with:email)
    }

    private func satisfiesLengthRequirement(_ text: String?) -> Bool {
        guard let content = text else { return false }

        return (content.characters.count >= minLength) && (content.characters.count <= maxLength)
    }

    private func isEmpty(_ text: String?) -> Bool {
        guard let t = text else { return false }
        return t.isEmpty
    }

    private func setBorder(for type: HCTextFieldType) {
        layer.cornerRadius = 3
        layer.borderWidth = 1

        switch type {
        case .normal:
            layer.borderColor = HCTextFieldBorderColor.normal.cgColor

        case .highlighted:
            layer.borderColor = HCTextFieldBorderColor.highlighted.cgColor

        case .error:
            layer.borderColor = HCTextFieldBorderColor.error.cgColor
        }
    }

    private func addCheckmark() {
        guard let checkmark = self.checkmark else {
            return
        }

        rightViewMode = .unlessEditing

        guard self.rightContainerView == nil else {
            rightView = self.rightContainerView
            return
        }

        let dividerWidth: CGFloat = 5
        let imageViewWH = frame.size.height * 0.8
        let containerViewWidth = imageViewWH + dividerWidth

        let rightContainerView = UIView(frame: CGRect(x: 0, y: 0, width: containerViewWidth, height: imageViewWH))

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageViewWH, height: imageViewWH))
        imageView.image = checkmark
        rightContainerView.addSubview(imageView)

        let divider = UIView(frame: CGRect(x: imageViewWH, y: 0, width: dividerWidth, height: imageViewWH))
        rightContainerView.addSubview(divider)

        self.rightContainerView = rightContainerView
        rightView = rightContainerView
    }

    private func removeCheckmark() {
        if rightContainerView != nil {
            rightView = nil
            rightContainerView = nil
        }
    }
}

// MARK: - HCTextFieldDelegate
public protocol HCTextFieldDelegate: UITextFieldDelegate {

    // Objective-C doesn't support OptionSet
    func textField(_ textField: HCTextField,
                   didCheckFor type: HCTextFieldCheckType,
                   isSuccess: Bool,
                   errorMessage: String? )

}
