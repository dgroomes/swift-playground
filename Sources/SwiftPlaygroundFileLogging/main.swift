import Foundation
import _Concurrency

/*
 Let's explore how to create and write to files from Swift. Let's consider the common use case of "writing log messages
 to a file". To do this, I've implemented a mini logging system in the 'FileLogger' module.
 */


let fileLogger = SimpleFileLogger()

do {
    let message = "Welcome to my 'swift-playground'! Let's write some Swift code that writes to a file."
    print(message)
    fileLogger.log(message)

    // I know it's not very popular, but I really like to take advantage of block-scope. In this case, the 'message'
    // local variable is only available within the scope of the 'do' block. Standalone blocks are great!
}

/// Conveniently log a message to the console and to the file logger.
///
/// The '_' is a Swift feature that allows you to omit the parameter name when calling the function.
func log(_ message: String) {
    print(message)
    fileLogger.log(message)
}

log("The 'log' function is convenient. Calling code can use 'log' and the message gets printed to the screen and written to the log file.")
