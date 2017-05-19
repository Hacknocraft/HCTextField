//
//  HCTextFieldTests.swift
//  HCTextFieldTests
//
//  Created by HAO WANG on 5/4/17.
//  Copyright © 2017 Hacknocraft. All rights reserved.
//

import XCTest
@testable import HCTextField

class HCTextFieldTests: XCTestCase {

    var viewControllerUnderTest: ViewController?

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? ViewController {
            viewControllerUnderTest = vc
        }

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewControllerUnderTest = nil
        super.tearDown()
    }

    func testNameField() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        guard let viewController = viewControllerUnderTest else { return }
        viewController.loadView()
        viewController.viewDidLoad()
        viewController.nameField.setTextAndSendEvent("name")
        _ = viewController.nameField.resignFirstResponder()

        XCTAssert(viewController.nameField.passedCheck, "nameField wasn't passed check")
    }

    func testEmailField() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        guard let viewController = viewControllerUnderTest else { return }
        viewController.loadView()
        viewController.viewDidLoad()
        viewController.emailField.setTextAndSendEvent("123456@163.com")
        _ = viewController.emailField.resignFirstResponder()

        XCTAssert(viewController.emailField.passedCheck, "emailField wasn't passed check")
    }

    func testPasswordField() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        guard let viewController = viewControllerUnderTest else { return }
        viewController.loadView()
        viewController.viewDidLoad()
        viewController.passwordField.setTextAndSendEvent("123456789") // 6 ~ 20 characters
        _ = viewController.passwordField.resignFirstResponder()

        XCTAssert(viewController.passwordField.passedCheck, "passwordField wasn't passed check")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
