import Foundation

// Run an executable to completion in a sub-process
//
// The executable is found at the absolute path given by the 'executablePath' parameter.
// For example: file:///bin/echo
public func runToCompletion(at executablePath: String, arguments: [String]) {

    guard let url = URL(string: executablePath) else {
        print("A file was not found at \(executablePath)")
        return
    }

    let process = Process()
    process.executableURL = url
    process.arguments = arguments

    do {
        try
        process.run()
        process.waitUntilExit()
    } catch {
        print("Unexpected error while running the executable '\(executablePath)': \(error)")
    }
}
