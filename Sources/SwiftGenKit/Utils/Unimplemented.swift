//
// SwiftGenKit
// Copyright © 2022 SwiftGen
// MIT Licence
//

func unimplemented(_ message: @autoclosure () -> String = String(), file: StaticString = #file, line: UInt = #line) {
    unimplementedImp((message(), file: file, line: line))
}

// This could be overridden in tests, as necessary.
var unimplementedImp: ((message: String, file: StaticString, line: UInt)) -> Void = { arg in
    fatalError(arg.message, file: arg.file, line: arg.line)
}
