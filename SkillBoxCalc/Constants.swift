//
//  Constants.swift
//  SkillBoxCalc
//
//  Created by Serge on 24.10.2021.
//

import Foundation

enum Constantstring {
    enum Calculator {
        static let title = "SkillBox Calculator"
    }
    
    enum Errors {
        static let zeroDivideErrorStr = "Ошибка\n - деление на ноль"
        static let overflowErrorStr = "Ошибка\n - переполнение"
    }
}

enum MathOperationError: Error {
    case zeroDevide
    case numOverflow
}

extension MathOperationError: LocalizedError {
    public var errorDescription: String?{
        switch self {
        case .zeroDevide:
            return NSLocalizedString(Constantstring.Errors.zeroDivideErrorStr, comment: "zero divide")
        case .numOverflow:
            return NSLocalizedString(Constantstring.Errors.overflowErrorStr, comment: "overflow")
        }
    }
}

