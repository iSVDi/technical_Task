//
//  Double+Convenience.swift
//  technical_Task
//
//  Created by Daniil on 07.09.2023.
//

import Foundation

extension Double {

    func toString(format: String = "%2d") -> String {
        return String(format: format, Int(self))
    }

}

