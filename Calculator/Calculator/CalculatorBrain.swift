//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Bryan Brem on 2/1/16.
//  Copyright © 2016 Bryan Brem. All rights reserved.
//

//  TODO:


import Foundation

class CalculatorBrain
{
    //  enum is good for something of varying types
    private enum Op: CustomStringConvertible { // these "case's" represent the structure or Argument of our digits and Operations
        case Operand(Double)
        case UnaryOperation(String, Double -> Double) // These include the Operations Mathematical symbol (String) and function(double -> double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get{
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    // Dicitonary
    private var knownOps = [String:Op]()
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", *))
        knownOps["÷"] = Op.BinaryOperation("÷", { $1 / $0})
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["−"] = Op.BinaryOperation("−", { $1 - $0})
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        knownOps["sin"] = Op.UnaryOperation("sin", sin)
        knownOps["cos"] = Op.UnaryOperation("cos", cos)
    }
    // Recursive: Continuesly pulls ops off the stack and puts them in a sequence that makes sense.  ie... a stack of *, 4, +, 5, 6 would end up being 4 * (5 + 6) = 44
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) //  Syntas to creat and name a toople.
    {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {  //  Switch is how things are pulled off the stack of an Enum.
            case .Operand(let operand):
                return(operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return(operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                    
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) {
        if let operation = knownOps[symbol] {  //  This is looking up the "symbol" in the Dictionary (knownOps)
            opStack.append(operation)  //  This is "appending" the Operation to the Enum (Op) which will send it to display/function.  In other words, finally USING it.
        }
    }
        
    
}
