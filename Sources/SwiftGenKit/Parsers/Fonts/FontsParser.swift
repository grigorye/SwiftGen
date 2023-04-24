//
// SwiftGenKit
// Copyright © 2022 SwiftGen
// MIT Licence
//

#if !os(Linux)
import AppKit.NSFont
#endif
import Foundation
import PathKit

public enum Fonts {
  public final class Parser: SwiftGenKit.Parser {
    var entries: [String: Set<Font>] = [:]
    private let options: ParserOptionValues
    public var warningHandler: Parser.MessageHandler?

    public init(options: [String: Any] = [:], warningHandler: Parser.MessageHandler? = nil) throws {
      self.options = try ParserOptionValues(options: options, available: Self.allOptions)
      self.warningHandler = warningHandler
    }

    public static let defaultFilter = filterRegex(forExtensions: ["otf", "ttc", "ttf"])

    public func parse(path: Path, relativeTo parent: Path) throws {
#if os(Linux)
      unimplemented("Font parsing is not supported on Linux")
#else
      guard checkIsFont(path: path) else {
        warningHandler?("File is not a known font type: \(path)", #file, #line)
        return
      }

      let fonts = CTFont.parse(file: path, relativeTo: parent)
      fonts.forEach { addFont($0) }
#endif
    }
  }
}

// MARK: - Helpers

private extension Fonts.Parser {
  /// Try to quickly check if the given file is an actual font file.
  ///
  /// - Note: This can seemingly fail in sandboxed environments.
  func checkIsFont(path: Path) -> Bool {
    guard let values = try? path.url.resourceValues(forKeys: [.typeIdentifierKey]),
      let uti = values.typeIdentifier else {
      warningHandler?("Unable to determine the Universal Type Identifier for file \(path)", #file, #line)
      return true
    }

    #if canImport(AppKit)
    return UTTypeConformsTo(uti as CFString, kUTTypeFont)
    #else
    return false
    #endif
  }

  func addFont(_ font: Fonts.Font) {
    let familyName = font.familyName
    entries[familyName, default: []].insert(font)
  }
}
