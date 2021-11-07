//
//  ViewController.swift
//  SkillBoxCalc
//
//  Created by Serge on 23.10.2021.
//

import UIKit

class ViewController: UIViewController {
    
    var firstArgu: Int? = nil
    var secondArgu: Int? = nil
    var operation: MathOperation? = nil
    var isPostiveNumber = true
    var state: CalcStates = .ready
    

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var calculationLabel: UILabel!
    
    @IBAction func numericButtonTapped(_ sender: UIButton) {
        let titleString = sender.titleLabel!.text!

        if titleString == "-/+" {
            changeSign()
        } else {
            addDigit(titleString)
        }

    }
    
    @IBAction func operationButtonTapped(_ sender: UIButton) {
        addMathOperation(sender.titleLabel!.text!)
    }
    
    @IBAction func equalButtonTapped() {
        calculate()
    }
    
    @IBAction func clearButtonTapped() {
        clearOperation()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = Constantstring.Calculator.title
    }

    
    func changeSign(){
        if state == CalcStates.ready {
            isPostiveNumber = !isPostiveNumber
            resultLabel.text = isPostiveNumber ? "0" : "-0"
        } else if state == CalcStates.firstArguIn {
            isPostiveNumber = !isPostiveNumber
            firstArgu! *= -1
            resultLabel.text = String(firstArgu!)
            calculationLabel.text = String(firstArgu!)
        } else if state == CalcStates.operationIn {
            state = .seconArguIn
            isPostiveNumber = !isPostiveNumber
            secondArgu = 0
            resultLabel.text = isPostiveNumber ? "0" : "-0"
            calculationLabel.text = String(firstArgu!)  + " " + operation!.toStr()
        } else if state == CalcStates.seconArguIn {
            isPostiveNumber = !isPostiveNumber
            if secondArgu == 0 {
                resultLabel.text = isPostiveNumber ? "0" : "-0"
                calculationLabel.text = String(firstArgu!)  + " " + operation!.toStr()
            } else {
                secondArgu! *= -1
                resultLabel.text = String(secondArgu!)
                calculationLabel.text = String(firstArgu!)
                                            + " " + operation!.toStr()
                                            + " " + String(secondArgu!)
            }
            
        } else if state == CalcStates.resIn {
            isPostiveNumber = !isPostiveNumber
            firstArgu! *= -1
            resultLabel.text = String(firstArgu!)
            calculationLabel.text = String(firstArgu!)
        }
    }

    func addDigit(_ digit: String) {
        if state == CalcStates.ready {
            if digit != "0" {
                state = .firstArguIn
                firstArgu = isPostiveNumber ? Int(digit)! : -Int(digit)!
                resultLabel.text = String(firstArgu!)
                calculationLabel.text = String(firstArgu!)
            }
        } else if state == CalcStates.firstArguIn {
            if resultLabel.text!.count < 9 {
                firstArgu = Int(resultLabel.text! + digit)
                resultLabel.text = String(firstArgu!)
                calculationLabel.text = String(firstArgu!)
            }
        } else if state == CalcStates.operationIn {
            state = .seconArguIn
            secondArgu = Int(digit)!
            resultLabel.text = digit
            calculationLabel.text = String(firstArgu!) +
                                        " " + operation!.toStr() +
                                        " " + digit
        } else if state == CalcStates.seconArguIn {
            if secondArgu == 0 {
                secondArgu = isPostiveNumber ? Int(digit)! : -Int(digit)!
            } else {
                if resultLabel.text!.count < 9 {
                    secondArgu = Int(resultLabel.text! + digit)
                }
            }
            resultLabel.text = String(secondArgu!)
            calculationLabel.text = String(firstArgu!)
                                        + " " + operation!.toStr()
                                        + " " + String(secondArgu!)

        } else if state == CalcStates.resIn {
            setReady()
            addDigit(digit)
        }

    }
    
    func addMathOperation(_ name: String){
        if state == CalcStates.ready {
            return
        } else if state == CalcStates.firstArguIn || state == CalcStates.operationIn{
            state = .operationIn
            operation = operationFrom(name)!
            isPostiveNumber = true
            calculationLabel.text = String(firstArgu!) + " " + name
        } else if state == CalcStates.seconArguIn {
            state = .operationIn
            do{
                let result = try operation!.makeOperation(firstArgu!, secondArgu!)
                firstArgu = result
                operation = operationFrom(name)
                resultLabel.text = String(firstArgu!)
                calculationLabel.text = String(firstArgu!)
                                            + " " + operation!.toStr()

                isPostiveNumber = result > 0
            } catch {
                setReady()
                resultLabel.text = error.localizedDescription
                return
            }

            
        } else if state == CalcStates.resIn {
            state = .operationIn
            operation = operationFrom(name)!
            isPostiveNumber = true
            calculationLabel.text = String(firstArgu!) + " " + name
        }
        
    }
    
    func calculate() {
        if state == CalcStates.ready || state == CalcStates.firstArguIn {
            return
        } else if state == CalcStates.operationIn || state == CalcStates.seconArguIn || state == CalcStates.resIn  {
            state = .resIn
            secondArgu = Int(resultLabel.text!)!
            
            do{
                let result = try operation!.makeOperation(firstArgu!, secondArgu!)
                resultLabel.text = String(result)
                calculationLabel.text = String(firstArgu!)
                                            + " " + operation!.toStr()
                                            + " " + String(secondArgu!)
                                            + " = " + String(result)
                firstArgu = result
                isPostiveNumber = result > 0
                
            } catch {
                setReady()
                resultLabel.text = error.localizedDescription
                return
            }
        }
    }
    

    
    func clearOperation() {
        if state == CalcStates.ready {
            setReady()
        } else if state == CalcStates.firstArguIn {
            setReady()
        } else if state == CalcStates.operationIn {
            state = .firstArguIn
            resultLabel.text = String(firstArgu!)
            calculationLabel.text = String(firstArgu!)
        } else if state == CalcStates.seconArguIn {
            state = .operationIn
            secondArgu = 0
            isPostiveNumber = true
            resultLabel.text = "0"
            calculationLabel.text = String(firstArgu!)
                                        + " " + operation!.toStr()
        } else if state == CalcStates.resIn  {
            setReady()
        }

    }
    
    func setReady() {
        firstArgu = nil
        secondArgu = nil
        operation = nil
        isPostiveNumber = true
        state = .ready
        resultLabel.text = "0"
        calculationLabel.text = ""
    }
    
    func renewCalculationLabel(){
        
    }
}

enum CalcStates {
    case ready, firstArguIn, seconArguIn, resIn, operationIn
}


enum MathOperation {
    case sum, substract, multyply, devide
    
    func makeOperation(_ argument: Int, _ secondArgument: Int)throws -> Int {
        switch self {
        case .sum:
            let (res, over) = argument.addingReportingOverflow(secondArgument)
            if over {
                throw MathOperationError.numOverflow
            }
            return res
        case .substract:
            let (res, over) = argument.subtractingReportingOverflow(secondArgument)
            if over {
                throw MathOperationError.numOverflow
            }
            return res
        case .multyply:
            let (res, over) = argument.multipliedReportingOverflow(by: secondArgument)
            if over {
                throw MathOperationError.numOverflow
            }
            return res
        case .devide:
            let (res, over) = argument.dividedReportingOverflow(by: secondArgument)
            if over {
                throw MathOperationError.zeroDevide
            }
            return res
        }
    }
    
    func toStr() -> String {
        switch self {
        case .sum:
            return "+"
        case .substract:
            return "-"
        case .multyply:
            return "*"
        case .devide:
            return "/"
        }
    }
}

func operationFrom(_ str: String) -> MathOperation?{
    switch str {
    case "+":
        return MathOperation.sum
    case "-":
        return MathOperation.substract
    case "*":
        return MathOperation.multyply
    case "/":
        return MathOperation.devide
    default:
        return nil
    }
}

