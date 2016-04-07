//
//  Picker.swift
//  Rize
//
//  Created by Jeremy Tregunna on 2016-04-06.
//  Copyright © 2016 Jeremy Tregunna. All rights reserved.
//

import Foundation

public enum PickerError: ErrorType {
    case EmptyChoiceSet
}

public protocol PickerRecordable {
    func pickerRecord(choice choice: Choice)
}

public extension PickerRecordable {
    func pickerRecord(choice choice: Choice) {}
}

public struct Choice {
    public let name: String
    public var timesTried: UInt
    public var rewarded: UInt
}

internal extension Array {
    func mapWithIndex<T> (f: (Int, Element) -> T) -> [T] {
        return zip((self.startIndex ..< self.endIndex), self).map(f)
    }
}

public class Picker {
    private var choices: [Choice]
    private var recorder: PickerRecordable?

    public init(choices: [String], recorder: PickerRecordable?) throws {
        guard choices.count > 0 else { throw PickerError.EmptyChoiceSet }

        self.recorder    = recorder
        self.choices     = [Choice]()
        for choice in choices {
            let c = Choice(name: choice, timesTried: 0, rewarded: 0)
            self.choices.append(c)
        }
    }
    
    deinit {
        self.recorder = nil
    }

    public func choose() -> String {
        guard arc4random_uniform(100) > 10 else {
            let elemIndex      = Int(arc4random_uniform(UInt32(choices.count)))
            var choice         = choices[elemIndex]
            choice.timesTried += 1
            choices[elemIndex] = choice
            recorder?.pickerRecord(choice: choices[elemIndex])

            return choice.name
        }

        let expectations = choices.mapWithIndex { (idx, choice) -> (choice: Choice, expectation: Double, index: Int) in
            let e = self.expectation(choice.rewarded, trials: choice.timesTried)
            return (choice: choice, expectation: e, index: idx)
        }
        let highest = expectations.sort({ $1.expectation < $0.expectation }).first! // init guarantees our choices are > 0
        
        var c = highest.choice
        c.timesTried += 1
        choices[highest.index] = c

        recorder?.pickerRecord(choice: choices[highest.index])

        return highest.choice.name
    }
    
    public func chooseSpecific(choice: String) -> String {
        let index = choices.indexOf({ $0.name == choice })!
        var c = choices[index]
        c.timesTried += 1
        choices[index] = c
        return choice
    }
    
    public func reward(choice: String) {
        return reward(choice, amount: 1)
    }

    public func reward(choice: String, amount: UInt) {
        let idx = choices.indexOf { return $0.name == choice }
        if let idx = idx {
            var c = choices[idx]
            c.rewarded += amount
            choices[idx] = c
        }
    }

    private func expectation(rewarded: UInt, trials: UInt) -> Double {
        return Double(rewarded) / Double(trials)
    }
}