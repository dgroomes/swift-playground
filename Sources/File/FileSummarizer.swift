import Foundation

/**
 Summarize the given file. Specifically, print out its size in bytes.
 */
public func summarizeFile(fileName: String) {
    let currentWorkingDir = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)

    let fileURL = currentWorkingDir.appendingPathComponent(fileName)
    let filePath: String = fileURL.path

    if !FileManager.default.fileExists(atPath: filePath) {
        print("It was requested to summarize file '\(filePath)' but this file does not exist.")
        return
    }

    do {
        let content = try String(contentsOf: fileURL, encoding: .utf8)
        let sizeInBytes = content.lengthOfBytes(using: String.Encoding.utf8)
        print("File '\(fileName)' has size \(sizeInBytes) bytes")
    } catch {
        print("Something went wrong: \(error)")
    }
}
