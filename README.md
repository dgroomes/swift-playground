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

## Making Sense of the Swift Package Manager

The [Swift Package Manager](https://www.swift.org/package-manager/) is really cool. I really like the `Package.swift`
file. It is similar to Gradle in the way that it's a project manifest descriptor but not written in a configuration
language but written in a full weight programming language: Swift for `Package.swift` and Groovy for `build.gradle` or
Kotlin for `build.gradle.kts`. Similarly to Gradle, it's on the higher side of complexity (please note: no build system
matches the gigantic feature set of Gradle). I'm trying to understand the following concepts which are listed in the
docs and how they relate to one another:

* *Modules*
* *Namespaces*
* *Programs*
* *Dependencies*
* *Packages*
* *Targets*
* *Products*
* *Libraries*
* *Executables*

Here are some notable quotes from those docs:

> Swift organizes code into *modules*.

> Each module specifies a namespace and enforces access controls on which parts of that code can be used outside of the
> module.

> A program may have all of its code in a single module, or it may import other modules as *dependencies*.

> A *package* consists of Swift source files and a manifest file.

> A package has one or more targets. Each target specifies a product and may declare one or more dependencies.

> A target may build either a library or an executable as its product.

> A *library* contains a module that can be imported by other Swift code.

> An *executable* is a program that can be run by the operating system.

> A target’s dependencies are modules that are required by code in the package.

> By convention, a target includes any source files located in the `Sources/<target-name>` directory.


## Wish List

General clean ups, TODOs and things I wish to implement for this project:

* [x] DONE (it turns out a Swift project has things like a `Package.swift` file) Structure the project in the way that the Swift *Package Manager* would. Swift has an impressive life outside of
  Apple. Just visit the [Swift website](https://www.swift.org/) to see extensive guides, reference, and community things
  and notice that this information is presented outside the context of Apple. (Of course Apple is still there but not in an overt way)
  This is pretty cool. Can I eject this project from Xcode (well, I'm using AppCode)?. Answer: no, this is not possible.
  [AppCode is not considered a lightweight IDE](https://intellij-support.jetbrains.com/hc/en-us/community/posts/360005062659-Can-I-get-Swift-code-completion-and-syntax-highlighting-in-IntelliJ-).
* [ ] Implement something just a bit more interesting than "hello world"
* [ ] IN PROGRESS How do you implement multi-module Swift projects? What does the directory layout look like? Where do I start?
* [ ] Implement something that starts another process, captures its output, and stops the process.


## Reference

* [Swift website](https://www.swift.org/)
* [The Swift Package Manager](https://www.swift.org/package-manager/)
  * This page is required reading. You'll have to read it a few times to grok packages, targets, products, libraries,
    executables, etc.
* [Apple Developer Docs: *Target*](https://developer.apple.com/documentation/packagedescription/target)
  * > You can vend targets to other packages by defining products that include the targets.
    > 
    > A target may depend on other targets within the same package and on products vended by the package’s dependencies. 
