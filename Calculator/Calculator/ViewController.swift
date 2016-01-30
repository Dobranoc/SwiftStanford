//
//  ViewController.swift
//  Calculator
//
//  Created by Bryan Brem on 1/25/16.
//  Copyright © 2016 Bryan Brem. All rights reserved.
//

// Merry Christmas

import UIKit

class ViewController: UIViewController {
    // outlets
    @IBOutlet weak var display: UILabel!
    
    // variables
    var userIsInTheMiddleOfTypingANumber: Bool = false
    var operandStack = Array<Double>()
    var calculatorConstants = [
        "π": M_PI
    ]
    
    // add digits
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        //  Enable only one "."
        if userIsInTheMiddleOfTypingANumber {
            if !(digit == "." && display.text!.rangeOfString(".") != nil) {
                display.text = display.text! + digit
            }
        }
        else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    //  enable π
    @IBAction func displayAndEnterConstant(sender: UIButton) {
        let constant = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        display.text = "\(calculatorConstants[constant]!)"
        enter()
        userIsInTheMiddleOfTypingANumber = false
    }
    
    //  enable Operations
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        switch operation {
            case "×": performOperation { $0 * $1 }
            case "÷": performOperation { $1 / $0 }
            case "+": performOperation { $0 + $1 }
            case "−": performOperation { $1 - $0 }
            case "√": performOperation { sqrt($0)}
            case "sin": performOperation { sin($0)}
            case "cos": performOperation { cos($0)}
            
        default:break
        }
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
        displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
        enter()
        }
    }
    
    @nonobjc func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    //  enable Enter
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        print("operandStack = \(operandStack)")
    }
    
    var displayValue: Double {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    
}

