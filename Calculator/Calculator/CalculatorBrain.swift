//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Bryan Brem on 1/29/16.
//  Copyright © 2016 Bryan Brem. All rights reserved.
//

//  55:00 in to Course 3

import Foundation

class CalculatorBrain
{
    private enum Op {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        
    }
    private var opStack = [Op]()
    
    //  Dictionary
    private var knownOps = [String:Op]()
    
    init() {
        knownOps["×"] = Op.BinaryOperation("x", *)
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        //  TODO rest of the Unary and Binary Operations, fix to NEW style when bringing over, remember "/" and "-" dont work the new way.
    }
    
    //Recursion
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                        
                    }
                }
            }
                //  TODO: case.BinaryOperation
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, _) = evaluate(opStack)
        return result
    
    }
    
    func pushOperand(operand: Double) {
        opStack.append(Op.Operand(operand))
    }
    
    func performOperation(symbol: String) {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
    }
}
