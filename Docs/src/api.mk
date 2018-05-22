---
title: API
---

:insert toc

---

You can add Janus to your application as a dependency using the Swift Package Manager. The repository url is:

    https://github.com/dmulholland/janus-swift.git

Alternatively, you can add the single public-domain `Janus.swift` file directly to your application's source.

Janus is written in Swift 4.



## Basic Usage

Initialize an argument parser, optionally specifying the application's help text and version:

::: swift

    ArgParser(helptext: String? = nil, version: String? = nil)

Supplying help text activates an automatic `--help` flag; supplying a version string activates an automatic `--version` flag. (Automatic `-h` and `-v` shortcuts are also activated unless registered by other options.)

You can now register your application's options and commands on the parser using the registration methods described below. Once the required options and commands have been registered, call the parser's `parse()` method to process the application's command line arguments:

::: swift

    parser.parse()

Parsed option values can be retrieved from the parser instance itself.



## Register Options

Janus supports long-form options, `--foo`, with single-character shortcuts, `-f`.

An option can have an unlimited number of long and short-form aliases. Aliases are specified via the `name` parameter which accepts a string of space-separated alternatives, e.g. `"foo f"`.

Option values can be separated on the command line by either a space, `--foo 123`, or an equals symbol, `--foo=123`.


||  `func newFlag(_ name: String)`  ||

    Register a flag (a boolean option) with a default value of `false`. Flag options take no arguments but are either present (`true`) or absent (`false`).


||  `func newDouble(_ name: String, fallback: Double = 0.0)`  ||

    Register a floating-point option, optionally specifying a default value.


||  `func newInt(_ name: String, fallback: Int = 0)`  ||

    Register an integer option, optionally specifying a default value.


||  `func newString(_ name: String, fallback: String = "")`  ||

    Register a string option, optionally specifying a default value.



## Retrieve A Single Value

An option's value can be retrieved from the parser instance using any of its registered aliases.

Each option maintains an internal array of values --- the value of the option is the final value in the array or the fallback value if the array is empty.


||  `func found(_ name: String) -> Bool`  ||

    Returns true if the specified option was found while parsing.


||  `func getFlag(_ name: String) -> Bool`  ||

    Returns the value of the specified boolean option.


||  `func getDouble(_ name: String) -> Double`  ||

    Returns the value of the specified floating-point option.


||  `func getInt(_ name: String) -> Int`  ||

    Returns the value of the specified integer option.


||  `func getString(_ name: String) -> String`  ||

    Returns the value of the specified string option.



## Retrieve Multiple Values

An option's internal array of values can be retrieved from the parser instance using any of its registered aliases.


||  `func getDoubleList(_ name: String) -> [Double]`  ||

    Returns the specified option's list of values.


||  `func getIntList(_ name: String) -> [Int]`  ||

    Returns the specified option's list of values.


||  `func getStringList(_ name: String) -> [String]`  ||

    Returns the specified option's list of values.


||  `func lenList(_ name: String) -> Int`  ||

    Returns the length of the specified option's list of values.



## Retrieve Positional Arguments

Options can be preceded, followed, or interspaced with positional arguments.


||  `func getArgs() -> [String]`  ||

    Returns the positional arguments as an array of strings.


||  `func getArgsAsDoubles() -> [Double]`  ||

    Attempts to parse and return the positional arguments as an array of doubles. Exits with an error message on failure.


||  `func getArgsAsInts() -> [Int]`  ||

    Attempts to parse and return the positional arguments as an array of integers. Exits with an error message on failure.


||  `func hasArgs() -> Bool`  ||

    Returns true if at least one positional argument has been found.


||  `func numArgs() -> Int`  ||

    Returns the number of positional arguments.



## Commands

Janus supports git-style command interfaces with arbitrarily-nested commands. Register a command on a parser instance using the `newCmd()` method:

::: swift

    func newCmd(_ name: String, helptext: String, callback: (ArgParser) -> Void) -> ArgParser

This method returns a new `ArgParser` instance associated with the command. You can register the command's flags and options on this sub-parser using the standard methods listed above. (Note that you never need to call `parse()` on a command parser --- if a command is found, its arguments are parsed automatically.)

* Like options, commands can have an unlimited number of aliases specified via the `name` string.

* Commands support an automatic `--help` flag and an automatic `help <name>` command using the specified help text.

* The specified callback function will be called if the command is found. The callback should accept the command's `ArgParser` instance as its sole argument.

The following `ArgParser` methods are also available for processing commands manually:


||  `func getCmd() -> String?`  ||

    Returns the command name, if the parser has found a command.


||  `func getCmdParser() -> ArgParser?`  ||

    Returns the command's parser instance, if the parser has found a command.


||  `func getParent() -> ArgParser?`  ||

    Returns a command parser's parent parser.


||  `func hasCmd() -> Bool`  ||

    Returns true if the parser has found a command.
