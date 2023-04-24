//
// SwiftGenKit UnitTests
// Copyright © 2022 SwiftGen
// MIT Licence
//

#if !os(Linux)
import AppKit.NSFont
#endif
import PathKit
@testable import SwiftGenKit
import TestUtils
import XCTest

final class FontsTests: XCTestCase {
  func testEmpty() throws {
    let parser = try Fonts.Parser()

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "empty", sub: .fonts)
  }

  func testDefaults() throws {
#if os(Linux)
    throw XCTSkip("Font parsing is not supported on Linux")
#else
    let parser = try Fonts.Parser()
    try parser.searchAndParse(path: Fixtures.resourceDirectory())

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "defaults", sub: .fonts)
#endif
  }

  // MARK: - Custom options

  func testUnknownOption() throws {
    do {
      _ = try Fonts.Parser(options: ["SomeOptionThatDoesntExist": "foo"])
      XCTFail("Parser successfully created with an invalid option")
    } catch ParserOptionList.Error.unknownOption(let key, _) {
      // That's the expected exception we want to happen
      XCTAssertEqual(key, "SomeOptionThatDoesntExist", "Failed for unexpected option \(key)")
    } catch let error {
      XCTFail("Unexpected error occured: \(error)")
    }
  }

  // MARK: - Path relative(to:)

  func testPathRelativeTo_UnrelatedIsNil() throws {
    let parent = Path("/a/b/c")
    let file = Path("/d/e/f")

    XCTAssertNil(file.relative(to: parent))
  }

  func testPathRelativeTo_RelatedIsNotNil() throws {
    let parent = Path("/a/b/c")
    let file = Path("/a/b/c/d/e")

    XCTAssertNotNil(file.relative(to: parent))
  }

  func testPathRelativeTo_ResultIsNotFullPath() throws {
    let parent = Path("a/b/c")
    let absoluteParent = parent.absolute()
    let file = Path("a/b/c/d/e")
    let absoluteFile = file.absolute()

    XCTAssertEqual(file.relative(to: parent), "d/e")
    XCTAssertEqual(file.relative(to: absoluteParent), "d/e")
    XCTAssertEqual(absoluteFile.relative(to: parent), "d/e")
    XCTAssertEqual(absoluteFile.relative(to: absoluteParent), "d/e")
  }
}
