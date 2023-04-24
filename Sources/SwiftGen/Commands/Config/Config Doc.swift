//
// SwiftGen
// Copyright © 2022 SwiftGen
// MIT Licence
//

#if canImport(AppKit)
import AppKit
#endif
import ArgumentParser
import SwiftGenCLI

extension Commands.Config {
  struct Doc: ParsableCommand {
    static let configuration = CommandConfiguration(
      abstract: "Open the documentation for the configuration file on GitHub."
    )

    func run() throws {
      let docURL = gitHubDocURL(version: Version.swiftgen, path: "ConfigFile.md")
      logMessage(.info, "Open documentation at: \(docURL)")
#if canImport(AppKit)
      NSWorkspace.shared.open(docURL)
#endif
    }
  }
}
