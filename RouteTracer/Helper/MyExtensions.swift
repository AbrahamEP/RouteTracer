//
//  MyExtensions.swift
//  RouteTracer
//
//  Created by Abraham Escamilla Pinelo on 30/01/20.
//  Copyright © 2020 Abraham Escamilla Pinelo. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import RealmSwift
import MapKit

extension UIViewController {
    /**
     Creates and presents an alert on the ViewController is called.
     - Parameter title: the title of the alertcontroller. The default value is "Dypaq"
     - Parameter message: the message to be displayed on the alert. The default value is nil.
     - Parameter type: The UIAlertControllerStyle of the AlertController. The default is .alert
     - Parameter actions: An array of the actions that the alert is going to have. The default value is an action with title "Aceptar" and no closure.
     */
    func createAlertView(_ title: String? = "Dypaq", _ message: String? = nil, type : UIAlertController.Style = .alert ,actions: [UIAlertAction] = [UIAlertAction.init(title: "Aceptar", style: .default, handler: nil)]) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: type)
        actions.forEach { (action) in
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion:nil)
    }
    
    func showAlertOneButtonWith(alertTitle: String?, alertMessage: String?, buttonTitle: String, handler:  ((UIAlertAction) -> Void)? = nil){
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let button = UIAlertAction(title: buttonTitle, style: .default, handler: handler)
        
        alert.addAction(button)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertTwoButtonsWith(
        alertTitle: String?,
        alertMessage: String?,
        firstButtonTitle: String,
        firstButtonStyle: UIAlertAction.Style,
        firstButtonHandler: ((UIAlertAction) -> Void)? = nil,
        secondtButtonTitle: String,
        secondButtonStyle: UIAlertAction.Style,
        secondButtonHandler: ((UIAlertAction) -> Void)? = nil){
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let firstButton = UIAlertAction(title: firstButtonTitle, style: firstButtonStyle, handler: firstButtonHandler)
        
        let secondButton = UIAlertAction(title: secondtButtonTitle, style: secondButtonStyle, handler: secondButtonHandler)
        
        
        
        alert.addAction(firstButton)
        alert.addAction(secondButton)
        
        self.present(alert, animated: true, completion: nil)
    }
}

/// A validation rule for text input.
public enum TextValidationRule {
    /// Any input is valid, including an empty string.
    case noRestriction
    /// The input must not be empty.
    case nonEmpty
    /// The enitre input must match a regular expression. A matching substring is not enough.
    case regularExpression(NSRegularExpression)
    /// The input is valid if the predicate function returns `true`.
    case predicate((String) -> Bool)

    public func isValid(_ input: String) -> Bool {
        switch self {
        case .noRestriction:
            return true
        case .nonEmpty:
            return !input.isEmpty
        case .regularExpression(let regex):
            let fullNSRange = NSRange(input.startIndex..., in: input)
            return regex.rangeOfFirstMatch(in: input, options: .anchored, range: fullNSRange) == fullNSRange
        case .predicate(let p):
            return p(input)
        }
    }
}
extension UIAlertController {
    public enum TextInputResult {
        /// The user tapped Cancel.
        case cancel
        /// The user tapped the OK button. The payload is the text they entered in the text field.
        case ok(String)
    }

    /// Creates a fully configured alert controller with one text field for text input, a Cancel and
    /// and an OK button.
    ///
    /// - Parameters:
    ///   - title: The title of the alert view.
    ///   - message: The message of the alert view.
    ///   - cancelButtonTitle: The title of the Cancel button.
    ///   - okButtonTitle: The title of the OK button.
    ///   - validationRule: The OK button will be disabled as long as the entered text doesn't pass
    ///     the validation. The default value is `.noRestriction` (any input is valid, including
    ///     an empty string).
    ///   - textFieldConfiguration: Use this to configure the text field (e.g. set placeholder text).
    ///   - onCompletion: Called when the user closes the alert view. The argument tells you whether
    ///     the user tapped the Close or the OK button (in which case this delivers the entered text).
    public convenience init(title: String, message: String? = nil,
                            cancelButtonTitle: String, okButtonTitle: String,
                            validate validationRule: TextValidationRule = .noRestriction,
                            textFieldConfiguration: ((UITextField) -> Void)? = nil,
                            onCompletion: @escaping (TextInputResult) -> Void) {
        self.init(title: title, message: message, preferredStyle: .alert)

        /// Observes a UITextField for various events and reports them via callbacks.
        /// Sets itself as the text field's delegate and target-action target.
        class TextFieldObserver: NSObject, UITextFieldDelegate {
            let textFieldValueChanged: (UITextField) -> Void
            let textFieldShouldReturn: (UITextField) -> Bool

            init(textField: UITextField, valueChanged: @escaping (UITextField) -> Void, shouldReturn: @escaping (UITextField) -> Bool) {
                self.textFieldValueChanged = valueChanged
                self.textFieldShouldReturn = shouldReturn
                super.init()
                textField.delegate = self
                textField.addTarget(self, action: #selector(TextFieldObserver.textFieldValueChanged(sender:)), for: .editingChanged)
            }

            @objc func textFieldValueChanged(sender: UITextField) {
                textFieldValueChanged(sender)
            }

            // MARK: UITextFieldDelegate
            func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                return textFieldShouldReturn(textField)
            }
        }

        var textFieldObserver: TextFieldObserver?

        // Every `UIAlertAction` handler must eventually call this
        func finish(result: TextInputResult) {
            // Capture the observer to keep it alive while the alert is on screen
            textFieldObserver = nil
            onCompletion(result)
        }

        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: { _ in
            finish(result: .cancel)
        })
        let okAction = UIAlertAction(title: okButtonTitle, style: .default, handler: { [unowned self] _ in
            finish(result: .ok(self.textFields?.first?.text ?? ""))
        })
        addAction(cancelAction)
        addAction(okAction)
        preferredAction = okAction

        addTextField(configurationHandler: { textField in
            textFieldConfiguration?(textField)
            textFieldObserver = TextFieldObserver(textField: textField,
                valueChanged: { textField in
                    okAction.isEnabled = validationRule.isValid(textField.text ?? "")
                },
                shouldReturn: { textField in
                    validationRule.isValid(textField.text ?? "")
                })
        })
        // Start with a disabled OK button if necessary
        okAction.isEnabled = validationRule.isValid(textFields?.first?.text ?? "")
    }
}


extension CLLocationCoordinate2D {
    func toCoordinateLocation() -> CoordinateLocation {
        let coordinate = CoordinateLocation()
        coordinate.createWith(coordinate: self)
        
        return coordinate
    }
    
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        return fromLocation.distance(from: toLocation)
    }
}

extension Array where Element == CLLocationCoordinate2D {
    func calculateTotalDistanceInKm() -> CLLocationDistance {
        var total = 0.0
        for i in 0..<self.count - 1 {
            let start = self[i]
            let end = self[i + 1]
            let distance = start.distance(from: end)
            total += distance
        }
        return total / 1000
    }
}

extension MKMapView {
    func goToCurrentLocation() {
        if let coor = self.userLocation.location?.coordinate{
            self.setCenter(coor, animated: true)
        }
    }
}
