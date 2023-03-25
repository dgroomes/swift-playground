import File
import Process

do {
    let message = "Welcome to my 'swift-playground'! Let's write some Swift code."
    print(message)
    log(message: message)
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
runToCompletion(at: "file:///usr/local/Cellar/bat/0.21.0/bin/bat", arguments: [
    "/Users/davidgroomes/repos/personal/swift-playground/README.md",
    "--paging=never",
    "--color=always"
])
