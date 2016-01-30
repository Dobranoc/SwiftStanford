//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Bryan Brem on 1/29/16.
//  Copyright © 2016 Bryan Brem. All rights reserved.
//

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
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                return (operation(operand), operandEvaluation.remainOps)
            }
                //  TODO: case.BinaryOperation
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
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
