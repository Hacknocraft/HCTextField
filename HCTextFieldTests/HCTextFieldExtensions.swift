//
//  HCTextFieldExtensions.swift
//  HCTextField
//
//  Created by Lebron on 09/05/2017.
//  Copyright © 2017 Hacknocraft. All rights reserved.
//

import Foundation
import HCTextField

extension HCTextField {

    func setTextAndSendEvent(_ text: String) {
        self.text = text
        sendActions(for: .editingChanged)
    }
}
