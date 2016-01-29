//
//  ViewController.swift
//  Calculator
//
//  Created by Bryan Brem on 1/25/16.
//  Copyright © 2016 Bryan Brem. All rights reserved.
//



import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!  //  The difference between ! and ? matters only in the usage of it.  The exclamation point unwraps it here frow now on.  So now you dont have to unwrap it everytime you call "display" down below.  You always want to "unwrap" it when you create it so you dont have to do it every time you use this Property.
    
    //  What the next line does is Clear out the 0 when the user types out a number.  So it shows up as "56" instead of 056".  So we create a variable with that long Name and set its type: Bool, and give it a value.  If it's not given a value you will get an error as EVERY property must have a value, even if its "false" or "nil" or whatever.
    var userIsInTheMiddleOfTypingANumber: Bool = false

    @IBAction func appendDigit(sender: UIButton) {
        
        //  declare a Local Variable named "digit", "sender" means I'm sending an action to this button.  What action?  The "currentTitle" action.  Which I can see exactly what that is if I CMD-click and open the documentation and see exactly what that does.  "digit" is an optional.  You can tell that by CMD-Clicking on "digit" and it will tell you.  This is an optional that can be a String.  The EXCLAMATION POINT is "unwrapping" the optional to show/use/display the String, or crashes of the value is nil.
        let digit = sender.currentTitle! // What this line is doing is "sending" the "current Title" of the button to the console.
        
        //  The if/else statement below is saying:  IF the User is typing a number perform the first action, which is to simply add the number they just typed "digit" to the number already in the display "display.text!".
        if userIsInTheMiddleOfTypingANumber {
        //  To actually Display the button being pressed in the Calculator you use the "display.text" property of the UILabel.  Now what Value do I set the Optional (display.text) to (=)?  The value should be the String "display.text + digit".  "digit" being the Variable we've been moving around in this Method.  The Explamation must be used here because it must be displayed as a "String" and that turns the "display.text" into an Optional-String.
        display.text = display.text! + digit
        } else {
        //  This next line of code is used (else) the user WAS NOT in the middle of typing a number.  So it simply "enters" the number the user clicked, it does not add it to the end of the numbers that are already in the display, it clears them.
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
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
            
        default:break  //  This tells the code, "if it's not one of these "cases" listed above, stop looking.
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
    //  The Array being created below is for the "Stack" of numbers that the Enter key is storing, so they can be called back up later when needed.  "Double" is they type.  So we just created an Array with the Double type and named it "operandStack".
    var operandStack = Array<Double>()
    @IBAction func enter() {  //  This "Enter" key needs to add this number to the Calculator's Internal Stack.  Which means if you press 2 (enter) 3 (enter) 4 (enter) TIMES 6, it's stacking those first three numbers into a queue of sorts.  It's just sort of storing them for later use.
        userIsInTheMiddleOfTypingANumber = false //  Because we want to clear out that number to type a new number to add to the Stack.
        //  Because we copy/pasted the Enter key from a Digit, it had the appendDigit function attached.  So we had to remove that by right-clicking on the Enter key in the Storyboard and "unclicking" the appendDigit function in the popup window.
        operandStack.append(displayValue)//  What this line NEEDS to do is Add the digit that is in the DISPLAY to the opperandStack Array.  I'm UNABLE to just insert "display.text" into the element field "(***)" because display.text is a String and I can only add Double's to the operandStack Array.
        print("operandStack = \(operandStack)")
    }
    //  Below, this is a Computed Property.  What we need it to do is take the String from the Display that came from my button press and convert it into a Double.  Because my Array can only accept Double's because answers to some of the equations that I'm looking for have the possibilty of being a Double.
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

