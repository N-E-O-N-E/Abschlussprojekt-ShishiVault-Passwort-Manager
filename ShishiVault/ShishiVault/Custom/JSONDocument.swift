//
//  JSONDocument.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 13.12.24.
//

import SwiftUI
import UniformTypeIdentifiers

struct JSONDocument: FileDocument {
    // Unterstützte Dateitypen
    static var readableContentTypes: [UTType] { [.json] }

    var json: Data

    init(json: Data) {
        self.json = json
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.json = data
    }

    // Speichere die Daten in eine Datei
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let result = FileWrapper(regularFileWithContents: json)
        return result
    }
}
