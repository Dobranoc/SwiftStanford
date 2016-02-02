//
//  ViewController.swift
//  Calculator
//
//  Created by Bryan Brem on 1/31/16.
//  Copyright © 2016 Bryan Brem. All rights reserved.
//

//  TODO:



import UIKit

class ViewController: UIViewController {

    // Variables
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var historyDisplay: UILabel!
    
    var brain = CalculatorBrain()
    
    var UserIsInTheMiddleOfTypingANumber = false
    var calculatorConstants = [
        "π": M_PI]
    var operandStack = Array<Double>()  // delete?
    
    //  Apend
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        // Display digit if it's a number or the first "."
        if UserIsInTheMiddleOfTypingANumber && digit != "."  || (digit == "." && display.text!.rangeOfString(".") == nil) {
            display.text = display.text! + digit
        } else {
            display.text = digit
            UserIsInTheMiddleOfTypingANumber = true
        }
        appendHistory(digit)
    }
    //  Clear Button
    @IBAction func clear(sender: UIButton) {
        operandStack.removeAll()
        operandStack.removeAll()
        display.text = "0"
        displayValue = 0
        enter()
    }
    
    //  Operations
    @IBAction func operate(sender: UIButton) {
        if UserIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
            displayValue = result
        } else {
            displayValue = 0
        }
        
        }
        appendHistory(operation)
    }
    
    //  Operations Returns
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    //  Operations Returns
    private func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
            }

        }
    
    //  Using Constants
    @IBAction func displayAndEnterConstant(sender: UIButton) {
        let constant = sender.currentTitle!
        if UserIsInTheMiddleOfTypingANumber {
            enter()
        }
        display.text = "\(calculatorConstants[constant]!)"
        enter()
        UserIsInTheMiddleOfTypingANumber = false
    }
    
    //  Enter
    @IBAction func enter() {
        UserIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        }   else {
            displayValue = 0
        }
    }
    
    //  Display
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            UserIsInTheMiddleOfTypingANumber = false
        }
    }
    
    
    func appendHistory(operandOrOperator: String) {
        if historyDisplay.text != nil {
            historyDisplay.text = historyDisplay.text! + operandOrOperator
        } else {
            historyDisplay.text = operandOrOperator
        }
    }
}

