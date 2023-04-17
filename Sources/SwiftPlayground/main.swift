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

 We can use a simulated "data fetching" function that simulates fetching data from an external source, like a database,
 or an HTTP API. These types of data fetching operations are asynchronous. I want to use Swift's implementation of
 structured concurrency which basically just means that we'll use the 'async' and 'await' keywords.

 Also, I want to explore the common but sometimes perplexing problem of async-ifying synchronous APIs. Swift offer's
 something called "continuations" that can help us with this problem. But, I've found these inflexible and I've had
 better luck using futures and promises. In either case, I want to learn and explore this problem space.
 */

/// Simulate a blocking data fetch to an external source, like a database or an HTTP API.
///
/// It can be problematic to use this function directly from your main program logic in the case you want to do other
/// operations while waiting for the data to be fetched. For example, in a UI program, you need to update elements in
// the UI like a progress bar, and you can't do that if the main thread is blocked.
func dataFetchBlocking(_ description: String) -> String {
    log("Fetching '\(description)' data from an external source...")
    sleep(3)

    log("Data fetch of '\(description)' complete!")
    return "Fake data for '\(description)'"
}

/// This is an async version of the 'blockingDataFetch' function.
func dataFetchAsync(_ description: String) async -> String {
    await withCheckedContinuation({ continuation in
        let result = dataFetchBlocking(description)
        continuation.resume(returning: result)
    })
}

do {
    log("")
    log("Let's explore concurrency by way of executing multiple simulated 'data fetch' operations.")

    // Kick off all the fetch operations concurrently.
    let clock = ContinuousClock()
    let start = clock.now
    async let dataFetchInbox = dataFetchAsync("inbox")
    async let dataFetchPhotos = dataFetchAsync("photos")
    async let dataFetchNews = dataFetchAsync("news")

    // Await the results.
    log("Found \(await dataFetchInbox)");
    log("Found \(await dataFetchPhotos)");
    log("Found \(await dataFetchNews)");
    let end = clock.now
    log("All data fetches completed in \(end - start).")
}
