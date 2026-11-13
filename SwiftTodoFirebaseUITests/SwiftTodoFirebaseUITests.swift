//
//  SwiftTodoFirebaseUITests.swift
//  SwiftTodoFirebaseUITests
//
//  Created by Md Sabbir Hossain on 13/11/26.
//

import XCTest

/// End-to-end authentication and task list flow.
///
/// Uses a unique email each run so the suite is repeatable against the real
/// Firebase project. Field navigation relies on the Return-key chaining wired
/// in the auth forms.
final class SwiftTodoFirebaseUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testRegisterAndLandOnHomeScreen() throws {
        let app = XCUIApplication()
        app.launch()

        // If a previous session persisted, log out first.
        let logoutButton = app.buttons["Log out"]
        if logoutButton.waitForExistence(timeout: 10) {
            logoutButton.tap()
        }

        // From the login screen, go to registration (cold launch can be slow).
        let signUpButton = app.buttons["Sign Up"].firstMatch
        let signUpText = app.staticTexts["Sign Up"].firstMatch
        let appeared = signUpButton.waitForExistence(timeout: 25) || signUpText.waitForExistence(timeout: 2)
        XCTAssertTrue(appeared, "Login screen did not appear")

        let createAccount = app.buttons["Create Account"].firstMatch
        var retries = 0
        while !createAccount.waitForExistence(timeout: 4) && retries < 2 {
            (signUpButton.exists ? signUpButton : signUpText).tap()
            retries += 1
        }
        XCTAssertTrue(createAccount.waitForExistence(timeout: 8), "Register screen did not appear")

        // Fill the registration form (unique email per run).
        let suffix = String(Int(Date().timeIntervalSince1970))
        let email = "uitest.\(suffix)@example.com"
        let password = "uitest1234"

        field(app, placeholder: "Email").tap()
        field(app, placeholder: "Email").typeText(email)
        field(app, placeholder: "Password (min. 6 characters)").tap()
        field(app, placeholder: "Password (min. 6 characters)").typeText(password)
        createAccount.tap()

        // Registration should land on the home screen with a greeting.
        let greeting = app.staticTexts.element(matching: NSPredicate(
            format: "label BEGINSWITH 'Good '"
        ))
        XCTAssertTrue(greeting.waitForExistence(timeout: 25), "Home screen did not appear after registration")

        // Dismiss the system "Save Password?" sheet if shown.
        let notNow = app.buttons["Not Now"].firstMatch
        if notNow.waitForExistence(timeout: 4) {
            notNow.tap()
        }

        // Add a task so the list is exercised end to end.
        let addButton = app.buttons["Add task"].firstMatch
        XCTAssertTrue(addButton.waitForExistence(timeout: 10), "Add task button not found")
        Thread.sleep(forTimeInterval: 1.5)
        addButton.tap()

        let titleField = field(app, placeholder: "Task title")
        var formRetries = 0
        while !titleField.waitForExistence(timeout: 5) && formRetries < 2 {
            addButton.tap()
            formRetries += 1
        }
        XCTAssertTrue(titleField.waitForExistence(timeout: 8), "Task form did not appear")
        titleField.tap()
        titleField.typeText("Buy groceries")
        app.buttons["Save"].tap()

        XCTAssertTrue(app.staticTexts["Buy groceries"].waitForExistence(timeout: 10), "Task did not appear in list")
    }

    // MARK: - Private

    /// Matches a field by its placeholder, which is how SwiftUI text fields
    /// expose themselves here.
    private func field(_ app: XCUIApplication, placeholder: String) -> XCUIElement {
        app.descendants(matching: .any).element(
            matching: NSPredicate(format: "placeholderValue == %@", placeholder)
        )
    }
}
