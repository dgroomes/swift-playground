import Foundation

/*
 A simple logger interface.
 */
protocol Logger {
    func log(_ message: String)
}

/*
 A simple logger that writes to a file.

 Messages are formatted with a timestamp and a trailing newline.
 */
public class SimpleFileLogger: Logger {

    // For simplicity, we will hardcode an absolute file path. On macOS, the "~/Library/Logs/" path should be a
    // reasonable fit. No special permissions are needed and I see that at least a few other tools have logged there,
    // like JetBrains IDEs, HomeBrew, and some other random things.
    private let fileURL: URL
    private let loggerTimeFormatter: DateFormatter

    public init() {
        let logsDirectory = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library/Logs")
        fileURL = logsDirectory.appendingPathComponent("swift-playground.log")
        loggerTimeFormatter = DateFormatter()
        loggerTimeFormatter.dateFormat = "HH:mm:ss"

        // Create the log file if it does not already exist.
        // Note: We assume the "~/Library/Logs" directory exists even though that's not a safe assumption.
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            // Create empty file
            if !FileManager.default.createFile(atPath: fileURL.path, contents: nil) {
                fatalError("Error creating the log file.")
            }
        }
    }

    public func log(_ message: String) {
        do {
            let fileHandle = try FileHandle(forWritingTo: fileURL)
            defer {
                fileHandle.closeFile()
            }
            fileHandle.seekToEndOfFile()
            let currentDateTime: String = loggerTimeFormatter.string(from: Date())
            let line: String = "\(currentDateTime): \(message)\n"
            let data = line.data(using: .utf8)!
            fileHandle.write(data)
            fileHandle.closeFile()
        } catch {
            fatalError("Error appending to the log file: \(error)")
        }
    }
}

