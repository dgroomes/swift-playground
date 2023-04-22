import Foundation
import _Concurrency

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
    print("Fetching '\(description)' data from an external source...")
    sleep(3)

    print("Data fetch of '\(description)' complete!")
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
    print("")
    print("Let's explore concurrency by way of executing multiple simulated 'data fetch' operations.")

    // Kick off all the fetch operations concurrently.
    let clock = ContinuousClock()
    let start = clock.now
    async let dataFetchInbox = dataFetchAsync("inbox")
    async let dataFetchPhotos = dataFetchAsync("photos")
    async let dataFetchNews = dataFetchAsync("news")

    // Await the results.
    print("Found \(await dataFetchInbox)");
    print("Found \(await dataFetchPhotos)");
    print("Found \(await dataFetchNews)");
    let end = clock.now
    print("All data fetches completed in \(end - start).")
}
