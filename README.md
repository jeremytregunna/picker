# Picker

![Travis CI](https://travis-ci.org/jeremytregunna/picker.svg?branch=master "Travis CI")

Picker is a different kind of A/B testing library. It doesn't feature a fancy
algorithm, it's not limited to just a small handfull of choices. It also doesn't
require constant tuning. What good is it then? Well, it's a library you can set
and forget. It'll always pick the current best thing to do. It's also self
adjusting, so you don't need to babysit it. Finally, it can take an arbitrary
number of choices and give you a good choice back.

## Installation

You can use CocoaPods, or anything else you like. For CocoaPods, point at this
repository.

```
pod 'Picker', '~> 1.0.0'
```

## Usage

```swift
// Keep a reference to this
let picker = Picker(["orange", "blue", "green"], recorder: self)

// …

// Where you want to make the choice
let choice = picker.choose()
// …use the choice to display or do whatever it is you want.

// …
// User did the thing you want, tell the picker
picker.reward("orange")
```

That's it, you're done. You will probably want to record the decisions made
somewhere, to do that, you'll want to implement the `pickerRecord(choice:)`
method. For instance:

```swift
struct Recorder: PickerRecordable {
    func pickerRecord(choice choice: Choice) {
        saveChoice(choice)
    }
}

// Somewhere, wherever you create the picker, do it like this:
let picker = Picker(["orange", "blue", "green"], recorder: yourRecorderInstance)
```

The picker will take ownership of that instance, so you don't need to keep your
own around. If you keep a reference to the picker on `yourRecorderInstance`,
then you'll want to ensure you break the reference manually.

## License

See the `LICENSE.md` file for more information.

