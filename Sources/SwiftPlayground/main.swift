import File
import Foundation
import Process
import _Concurrency

// Let's init the file logger
let logger = SimpleFileLogger()

do {
    let message = "Welcome to my 'swift-playground'! Let's write some Swift code."
    print(message)
    logger.log(message)
}

// Can we run regular commandline commands, like 'cat' or 'bat', from a Swift program?
//
// Note: it would be nice to find the absolute URL from the symlink.
//
// Let's do 'echo' first. It's an easy one.
runToCompletion(at: "file:///bin/echo", arguments: ["Hello", "'echo'", "command!", "Calling you from a", "Swift", "program."])
// This is cool. We can call "bat" and "bat" will colorize our README.md file. It just takes reading the man pages a bit
// to understand that you need to tell "bat" that we're not calling from an interactive shell, so disabling paging is
// required or else the process will just hang forever.
runToCompletion(at: "file:///opt/homebrew/bin/bat", arguments: [
    "/Users/davidgroomes/repos/personal/swift-playground/README.md",
    "--paging=never",
    "--color=always"
])

/*
 Let's explore concurrency.

 We can continue to use subprocesses as a way to explore concurrency. Let's kick off multiple 'sleep' subprocesses
 and see them race to completion. We'll give them random delays between 3 and 10 seconds.

 We'll use Swift's implementation of "structured concurrency", which means that we'll use the 'async' and 'await'
 keywords.
 */

/*
 Run the 'sleep' command as a subprocess and time how long it takes to complete.

 This function 'async-ifies' the 'Process' API. We like Swift's structured concurrency but it is not always available,
 especially in APIs that were created before async/await was introduced (Swift 5.5).

 This function returns a tuple of the task number and the duration it took to complete.
 */
func runSleepCommandAsync(taskNumber: Int) async throws -> (Int, Duration) {
    let delay = Int.random(in: 3...10)
    let process = Process()

    process.executableURL = URL(fileURLWithPath: "/bin/sleep")
    process.arguments = ["\(delay)"]

    let clock = ContinuousClock()
    let start: ContinuousClock.Instant = clock.now

    try await withCheckedThrowingContinuation({ continuation in
        process.terminationHandler = { _ in
            print("Task \(taskNumber) completed after \(delay) seconds")
            continuation.resume()
        }

        do {
            try process.run()
            print("Started task \(taskNumber)...")
        } catch {
            print("Error occurred while running task \(taskNumber): \(error)")
            continuation.resume(throwing: error)
        }
    })

    let end: ContinuousClock.Instant = clock.now
    let duration: ContinuousClock.Instant.Duration = end - start // operator overloading, interesting!
    return (taskNumber, duration)
}

// Start the race.
async let sleep1 = try runSleepCommandAsync(taskNumber: 1)
async let sleep2 = try runSleepCommandAsync(taskNumber: 2)
async let sleep3 = try runSleepCommandAsync(taskNumber: 3)

let results = try await [sleep1, sleep2, sleep3]

// Find the sleep subprocess that finished earlier.
// Note: I'm surprised by the cryptic ordinal notation here. Interesting.
let shortest = results.min(by: { $0.1 < $1.1 })!

print("The 'sleep' task #\(shortest.0) won the race!")
