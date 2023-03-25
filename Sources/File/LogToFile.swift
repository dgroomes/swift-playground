import Foundation

// Let's explore how to write to a file from Swift. Let's consider the common use case of "writing log messages to a file".
// For simplicity, we will hardcode an absolute file path. On macOS, the "/usr/local/var/log" path should be a reasonable
// fit. No special permissions are needed and I see that at least a few other tools have logged there, like Redis, Kafka,
// and Zookeeper.

private let filePath = "/usr/local/var/log/swift-playground.log"
private let fileURL = URL(fileURLWithPath: filePath)
private let newline = "\n".data(using: .utf8)!

// Note: this is interesting. Swift doesn't have an init block but this is an idiom for accomplishing the same effect.
private let loggerTimeFormatter = {
    let it = DateFormatter()
    it.dateFormat = "HH:mm:ss"
    return it
}()

/**
 Write a message to the log file. The message will be formatted with a timestamp and a trailing newline.
 */
public func log(message: String) {

    // Create the file if it does not already exist.
    //
    // Note: this is a naive implementation of a logger, but we're just here for learning Swift.
    if !FileManager.default.fileExists(atPath: filePath) {
        // Create empty file
        if !FileManager.default.createFile(atPath: filePath, contents: nil) {
            print("Error creating the log file.")
        }
    }

    // Append to the log file.
    do {
        let fileHandle = try FileHandle(forWritingTo: fileURL)
        fileHandle.seekToEndOfFile()
        let currentDateTime : String = loggerTimeFormatter.string(from: Date())
        let line : String = "\(currentDateTime): \(message)\n"
        let data = line.data(using: .utf8)!
        fileHandle.write(data)
        fileHandle.closeFile()
    } catch {
        print("Error appending to the log file: \(error)")
    }
}
