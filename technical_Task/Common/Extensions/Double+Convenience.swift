//
//  Double+Convenience.swift
//  technical_Task
//
//  Created by Daniil on 07.09.2023.
//

import Foundation

extension Double {

    var degreesToRadians: Self { return self * .pi / 180 }
    
    func toString(format: String = "%.2f") -> String {
        return String(format: format, self)
    }

}

