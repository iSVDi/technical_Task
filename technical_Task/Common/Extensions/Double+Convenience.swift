//
//  Double+Convenience.swift
//  technical_Task
//
//  Created by Daniil on 07.09.2023.
//

import Foundation

extension Double {

    func toString(format: String = "%02d") -> String {
        return String(format: format, Int(self))
    }

}

