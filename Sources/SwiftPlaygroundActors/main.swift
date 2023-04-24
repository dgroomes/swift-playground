import Foundation

/// Print a message but also the current thread. This should help us understand the threading model of Swift and specifically of Swift features like tasks, actors, and
/// async/await.
func log(_ message: String) {
    print("[\(Thread.current.description)] \(message)")
}

log("Let's implement something with actors and level up our Swift concurrency skills.")
log("")

/*
 To learn about actors, let's invent a sample domain. Let's have multiple tasks compete against one another other in a
 simulated "race to the finish line" competition. The first task to finish is tƒhe winner. We'll simulate each task's
 racing behavior (from start to finish) with the 'sleep' function over a random duration. When the first task completes,
 it will reference some "finishOrder" shared mutable state and declare itself the winner for finishing first. The
 other tasks will see, from the "finishOrder" state, that they did not finish first.
 
 It's important that the "finishOrder" state is implemented in a way that is safe for concurrent data access. For
 example, consider if task A and task B finish in the same microsecond, will they both simultaneously read the
 "finishOrder" state and mistakenly think that they are both the first to finish? There can't be two winners. We need
 to write the program correctly. Let's explore how to do that with actors.
 
 A Track & Field racing example is especially apt because in programming, we use the term "race condition" to describe
 the general problem of programming errors related to improperly handling all cases for concurrent tasks, leading to
 wrong/undefined behavior.
 */

actor RaceManager {
    // Use an array to hold the finishing order of the racers. This is mutable ('var'). In other programming languages,
    // we would have to carefully "code our way around" a correct/semantic data access to this shared mutable state,
    // but with Swift and the actor model, the compiler helps us out.
    private var finishOrder: [String] = []
    
    private var isStopped = false
    private let clock : ContinuousClock = ContinuousClock()
    private let start : ContinuousClock.Instant
    
    init() {
        start = clock.now
    }

    // Racer crosses the finish line and gets their finishing position.
    func crossTheFinishLine(_ name: String) {
        // We need to check 'isStopped' here in case the racer crossed the finish line after the race was already
        // called off.
        //
        // Really? Yes. Some tasks are likely to be scheduled on different processor cores, and thus we've invited a
        // "race condition". I think there should be a way to design this code better so that we don't have to do this
        // check... but this makes for a good example of a race condition.
        //
        // The screenshot in the README shows what happens when this check doesn't exist.
        if (isStopped) {
            walkOffTheTrack(name)
            return
        }
        
        let end = clock.now
        let duration = end - start

        // This is safe for concurrent access, as actors protect their internal state from being accessed simultaneously
        // by different tasks.
        finishOrder.append(name)

        let position = finishOrder.count
        if position == 1 {
            log("\(name) 🏆 finished in position \(position) with a time of \(duration). They are the winner!")
        } else {
            log("\(name) finished in position \(position) with a time of \(duration). [isStopped: \(isStopped)]")
        }
    }
    
    func stopRace(_ raceTask: Task<(), Never>, reason: String) -> Void {
        let end = clock.now
        let duration = end - start

        isStopped = true
        raceTask.cancel()

        log("")
        log(reason)
        log("The race went on for \(duration).")
        log("")
    }
    
    func walkOffTheTrack(_ name: String) {
        let end = clock.now
        let duration = end - start

        log("\(name) made a good attempt, but did not finish the race. They ran for \(duration).")
    }
}

// Simulate the racing competition for an individual contestant. E.g. how long will it take them to look to run to the
// finish line?
func race(name: String, raceManager: RaceManager) async {
    // Generate a random sleep duration between 1 and 8 seconds.
    let sleepDuration = UInt64.random(in: 1_000_000_000...8_000_000_000)

    // Simulate the racer's race with Task.sleep. Task.sleep is a suspending function that does not block the thread.
    // It allows other tasks to make forward progress. Those tasks are likely designed to also "do some work, suspend".
    // This design has a lot of advantages: there can be many tasks running concurrently (but NOT in parallel), their
    // data access is safe thanks to actors, and only one OS thread is ever used. In this way, we are being good
    // stewards of system resources.
    do {
        try await Task.sleep(nanoseconds: sleepDuration)
    } catch {
        // If the sleep throws an error, it is a CancellationError. The race is forecefully ended after 5 seconds and
        // any racers who haven't finished must stop and what off the track.
        await raceManager.walkOffTheTrack(name)
        return
    }

    // The racers has completed the race!
    await raceManager.crossTheFinishLine(name)
}

func main() async {

    // Create a race manager to manage the shared state.
    let raceManager = RaceManager()

    // Start the racing tasks concurrently.
    let racers = ["Zoom", "Bolt", "Flash", "Speedster", "Blaze"]
    log("📢 Welcome to the 42nd annual Swift Track & Field competition.")
    log("We have \(racers.count) contestants running in the event. Let's see who is the fastest runner.")
    log("... and they're off and running!")
    log("")
    
    // Structured concurrency is a wrapping-heavy feature of Swift. The APIs tend to be 'async' functions which has the
    // unfortunate effect that the return value of the function is not an actual representation of the task, but of the
    // task result. This means you don't have an object (like a "promise", or "task", or "completable future" or
    // whatever you can relate this to in the programming languages that you personally know). You can do 'async let' but
    // that variable is only awaitable, not cancellable. So, the solution is to wrap the withTaskGroup (awaitable
    // function call) in a 'Task'. We can cancel this 'Task' at our leisure.
    let raceTask = Task {
        await withTaskGroup(of: Void.self) { group in
            for racer in racers {
                group.addTask {
                    await race(name: racer, raceManager: raceManager)
                }
            }
        }
    }
    
    // Simulate a lightning storm after 5 seconds and stop the race.
    do {
        try await Task.sleep(nanoseconds: 5_000_000_000)
        // Because we used a task group, and we wrapped it in a Task (raceTask), we can conveniently cancel this
        // wrapper-task which propagates the cancellation to all the children tasks. Alternatively, if we had a reference
        // to the list of the individual racer tasks, we could await all of them. That would work.
        await raceManager.stopRace(raceTask, reason: "⚡️ Lightning was spotted! The race is stopped due to severe weather.")
    
        // Remember, when we called 'raceTask.cancel', that didn't actually "stop the execution" of those tasks like
        // you might think it does (by contrast, think about the Unix 'kill' command which you can use to force kill
        // a process). The 'raceTask.cancel' is more like a signal. When we do 'await raceTask.value', this function
        // suspends which frees up the backing thread to actually execute the racing tasks. The racing tasks have a
        // chance to execute some "cancellation reaction" code, which is usually where you would have clean up
        // operations or the like.
        await raceTask.value
    } catch {
        log("Unexpected. The cancellation task was itself cancelled.")
    }
}

await main()

