import SwiftPlaygroundLogging
import Foundation
import Process
import _Concurrency

/*
 Let's explore the Swift programming language by writing some example code. This file is a mashup of unrelated snippets
 of Swift code that help me "learn by doing".
 */

// I'm not sure what idiomatic logging looks like in Swift programs (or maybe more particularly, in macOS programs), but
// I've created a simple logger that writes to a file.
let fileLogger = SimpleFileLogger()

do {
    let message = "Welcome to my 'swift-playground'! Let's write some Swift code."
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

/*
 Let's explore concurrency.

 We use subprocesses as a way to explore concurrency. Let's kick off multiple 'sleep' subprocess and see them race to
 completion. We'll give them random delays between 3 and 10 seconds.

 We'll use Swift's implementation of "structured concurrency", which means that we'll use the 'async' and 'await'
 keywords.
 */

/// Run the 'sleep' command as a subprocess and time how long it takes to complete.
///
/// This function 'async-ifies' the 'Process' API. We like Swift's structured concurrency but it is not always available,
/// especially in APIs that were created before async/await was introduced (Swift 5.5).
///
/// This function returns a tuple of the task number and the duration it took to complete.
///
/// - Parameter taskNumber:
/// - Returns:
/// - Throws:
func runSleepCommandAsync(taskNumber: Int) async throws -> (Int, Duration) {
    let delay = Int.random(in: 3...10)
    let process = Process()

    process.executableURL = URL(fileURLWithPath: "/bin/sleep")
    process.arguments = ["\(delay)"]

    let clock = ContinuousClock()
    let start: ContinuousClock.Instant = clock.now

    try await withCheckedThrowingContinuation({ continuation in
        process.terminationHandler = { _ in
            log("Task \(taskNumber) completed after \(delay) seconds")
            continuation.resume()
        }

        do {
            try process.run()
            log("Started task \(taskNumber)...")
        } catch {
            log("Error occurred while running task \(taskNumber): \(error)")
            continuation.resume(throwing: error)
        }
    })

    let end: ContinuousClock.Instant = clock.now
    let duration: ContinuousClock.Instant.Duration = end - start // operator overloading, interesting!
    return (taskNumber, duration)
}

do {
    log("")
    log("Let's explore concurrency by way of executing multiple 'sleep' subprocesses")

    // Start the race.
    async let sleep1 = try runSleepCommandAsync(taskNumber: 1)
    async let sleep2 = try runSleepCommandAsync(taskNumber: 2)
    async let sleep3 = try runSleepCommandAsync(taskNumber: 3)

    let results = try await [sleep1, sleep2, sleep3]

    // Find the sleep subprocess that finished earlier.
    // Note: I'm surprised by the cryptic ordinal notation here. Interesting.
    let shortest = results.min(by: { $0.1 < $1.1 })!

    log("The 'sleep' task #\(shortest.0) won the race!")
}
