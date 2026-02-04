import SwiftUI
import UniformTypeIdentifiers

struct JSONDocument: FileDocument {
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

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let result = FileWrapper(regularFileWithContents: json)
        return result
    }
}
