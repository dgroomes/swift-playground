import Foundation

/*
 Let's explore how to create and write to files from Swift. Let's consider the common use case of "writing log messages
 to a file". To do this, let's implement a mini logging system.
 */

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

    // For simplicity, we will hardcode an absolute file path. On macOS, the "/usr/local/var/log" path should be a reasonable
    // fit. No special permissions are needed and I see that at least a few other tools have logged there, like Redis, Kafka,
    // and Zookeeper.
    private let filePath = "/usr/local/var/log/swift-playground.log"
    private let fileURL: URL
    private let loggerTimeFormatter: DateFormatter

    public init() {
        fileURL = URL(fileURLWithPath: filePath)
        loggerTimeFormatter = DateFormatter()
        loggerTimeFormatter.dateFormat = "HH:mm:ss"

        // Create the log file if it does not already exist.
        if !FileManager.default.fileExists(atPath: filePath) {
            // Create empty file
            if !FileManager.default.createFile(atPath: filePath, contents: nil) {
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

