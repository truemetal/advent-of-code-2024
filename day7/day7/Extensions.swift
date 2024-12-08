//
//  Extensions.swift
//  day7
//
//  Created by Bohdan Pashchenko on 08.12.2024.
//

import Foundation

struct GenericError: Error { }
let genericError = GenericError()

extension Optional {
    func throwIfNil() throws -> Wrapped {
        guard let self else { throw genericError }
        return self
    }
}
