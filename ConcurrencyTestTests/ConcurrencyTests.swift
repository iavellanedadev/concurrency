//
//  ConcurrencyTestTests.swift
//  ConcurrencyTestTests
//


import XCTest
@testable import ConcurrencyTest

class ConcurrencyTests: XCTestCase {
    
    func testloadMessage() {
        
        let msgCaller = MessageCaller()
        let dispatchQ = DispatchGroup()
        
        dispatchQ.enter()
        
        var message1 = String()
        msgCaller.getMessage2{ (messageOne) in
            message1 = messageOne
            print("Message Receieved: \(message1)")
            dispatchQ.leave()

        }
        
        let result = dispatchQ.wait(timeout: DispatchTime.now() + 3)
        
        dispatchQ.notify(queue: .main)
        {
            if result == .success{
                XCTAssertEqual(message1, "world")
            }
        }

    }

}
