//
//  PickerTests.swift
//  PickerTests
//
//  Created by Jeremy Tregunna on 2016-04-06.
//  Copyright © 2016 Jeremy Tregunna. All rights reserved.
//

import XCTest
@testable import Picker

struct PickerRecorder: PickerRecordable {
    let runner: Choice -> Void
    
    init(runner: Choice -> Void) {
        self.runner = runner
    }

    func pickerRecord(choice choice: Choice) {
        runner(choice)
    }
}

class PickerTests: XCTestCase {
    func testThrowsOnEmptyChoiceSet() {
        let choices = [String]()
        do {
            let _ = try Picker(choices: choices, recorder: nil)
        } catch(PickerError.EmptyChoiceSet) {
            // Good.
        } catch(let error) {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testPicksItemFromSingleItemSet() {
        do {
            let picker = try Picker(choices: ["foo"], recorder: nil)
            let choice = picker.choose()
            XCTAssertEqual(choice, "foo")
        } catch(let error) {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testPicksItemFromMultiItemSet() {
        let choices = ["foo", "bar"]
        do {
            let picker = try Picker(choices: choices, recorder: nil)
            let choice = picker.choose()
            XCTAssertNotNil(choices.indexOf(choice))
        } catch(let error) {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testRecordsChoice() {
        do {
            let exp = expectationWithDescription("called")
            let recorder = PickerRecorder(runner: { choice in
                XCTAssertEqual(choice.name, "foo")
                XCTAssert(choice.timesTried == 2)
                XCTAssert(choice.rewarded == 1)
                exp.fulfill()
            })

            let picker = try Picker(choices: ["foo"], recorder: recorder)
            let _ = picker.choose()
            waitForExpectationsWithTimeout(1) { err in
                XCTAssertNil(err)
            }
        } catch(let error) {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testRewardChosesToPickThatItemMoreThanTheOtherOver10Calls() {
        let choices = ["foo", "bar"]
        do {
            let picker = try Picker(choices: choices, recorder: nil)
            var test: [String: Int] = ["foo": 1, "bar": 1]
            // These two to set up the initial reward of bar, we want to artificially favour bar for testing purposes.
            picker.chooseSpecific("bar")
            picker.reward("bar")

            for _ in 1...10 {
                test[picker.choose()]! += 1
            }
            
            let data = (foo: test["foo"], bar: test["bar"])
            XCTAssert(data.foo < data.bar)
        } catch(let error) {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
