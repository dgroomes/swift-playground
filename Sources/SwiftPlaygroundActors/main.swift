import Foundation

print("Let's implement something with actors and level up our Swift concurrency skills.\n")

/*
 To learn about actors, let's invent a sample domain. Let's have multiple tasks compete against one another other in a
 simulated "race to the finish line" competition. The first task to finish is the winner. We'll simulate each task's
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

    // Racer crosses the finish line and gets their finishing position.
    func crossTheFinishLine(name: String) -> Int {
        // This is safe for concurrent access, as actors protect their internal state from being accessed simultaneously
        // by different tasks.
        finishOrder.append(name)

        // Return the racer's finishing position.
        return finishOrder.count
    }
}

// Simulate the racing competition for an individual contestant. E.g. how long will it take them to look to run to the
// finish line?
func race(name: String, raceManager: RaceManager) async {
    // Generate a random sleep duration between 1 and 5 seconds.
    let sleepDuration = UInt64.random(in: 1_000_000_000...5_000_000_000)

    // Simulate the racer's race with Task.sleep. Task.sleep is a suspending function that does not block the thread.
    // It allows other tasks to make forward progress. Those tasks are likely designed to also "do some work, suspend".
    // This design has a lot of advantages: there can be many tasks running concurrently (but NOT in parallel), their
    // data access is safe thanks to actors, and only one OS thread is ever used. In this way, we are being good
    // stewards of system resources.
    try? await Task.sleep(nanoseconds: sleepDuration)

    // Call the crossTheFinishLine method on the race manager.
    // This method will return the racer's finishing position.
    let position = await raceManager.crossTheFinishLine(name: name)

    // Print the racer's finishing position.
    if position == 1 {
        print("\(name) 🏆 finished in position \(position). They are the winner!")
    } else {
        print("\(name) finished in position \(position).")
    }
}

func main() async {

    // Create a race manager to manage the shared state.
    let raceManager = RaceManager()

    // Start the racing tasks concurrently.
    let racers = ["Lightning", "Bolt", "Flash", "Speedster", "Blaze"]
    print("📢 Welcome to the 42nd annual Swift Track & Field competition.")
    print("We have \(racers.count) contestants running in the event. Let's see who is the fastest runner.")
    print("... and they're off and running!\n")
    
    await withTaskGroup(of: Void.self) { group in
        for racer in racers {
            group.addTask {
                await race(name: racer, raceManager: raceManager)
            }
        }
    }
}

await main()

