# swift-playground

📚 Learning and exploring the Swift programming language.

> Swift. The powerful programming language that is also easy to learn.
>
> -- <cite>https://developer.apple.com/swift</cite>


## Description

**NOTE**: This project was developed on macOS. It is for my own personal use.

I'm interested in learning general OS-level things on macOS like how to start, stop and control processes. To learn
those concepts, it's effective to write sample scripts and code that does that. And to do that, it's probably most
effective to do that from the macOS SDK, which means I need to write a program in Swift or Objective-C. In 2022, Swift
is the natural choice. So, this playground repository is me learning Swift.


## Instructions

Follow these instructions to build and run a demo Swift program:

1. Use Swift 5.5
2. Build and run the program:
   * ```shell
     swift run
     ```
   * It should look something like this:
     ```text
     $ swift run
     Building for debugging...
     [1/1] Linking basic
     Build complete! (0.25s)
     Hello, World!
     ```


## Wish List

General clean ups, TODOs and things I wish to implement for this project:

* [x] DONE (it turns out a Swift project has things like a `Package.swift` file) Structure the project in the way that the Swift *Package Manager* would. Swift has an impressive life outside of
  Apple. Just visit the [Swift website](https://www.swift.org/) to see extensive guides, reference, and community things
  and notice that this information is presented outside the context of Apple. (Of course Apple is still there but not in an overt way)
  This is pretty cool. Can I eject this project from Xcode (well, I'm using AppCode)?. Answer: no, this is not possible.
  [AppCode is not considered a lightweight IDE](https://intellij-support.jetbrains.com/hc/en-us/community/posts/360005062659-Can-I-get-Swift-code-completion-and-syntax-highlighting-in-IntelliJ-).
* [ ] Implement something just a bit more interesting than "hello world"
* [ ] How do you implement multi-module Swift projects? What does the directory layout look like? Where do I start?
* [ ] Implement something that starts another process, captures its output, and stops the process.


## Reference

* [Swift website](https://www.swift.org/)
* [The Swift Package Manager](https://www.swift.org/package-manager/)
