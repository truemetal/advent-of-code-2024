import Foundation

struct GenericError: Error { }
let genericError = GenericError()

extension Optional {
    func throwIfNil() throws -> Wrapped {
        guard let self else { throw genericError }
        return self
    }
}

extension Bool {
    @discardableResult func throwIfFalse() throws -> Bool {
        guard self else { throw genericError }
        return self
    }
}

extension BinaryInteger {
    var str: String { String(self) }
}

extension String {
    var int: Int? { Int(self) }
}

extension Collection {
    var arr: [Element] { Array(self) }
}

extension Collection {
    var isNotEmpty: Bool { !isEmpty }
}

extension Collection where Element == Character {
    var str: String { String(self) }
}

extension Collection where Element: Hashable {
    var set: Set<Element> { Set(self) }
}
