//
//  ConcurrencyTestTests.swift
//  ConcurrencyTestTests
//


import XCTest
@testable import ConcurrencyTest

class ConcurrencyTests: XCTestCase {
    
    func testloadMessageOne() {
        
        let msgCaller = MessageCaller()
        let dispatchQ = DispatchGroup()
        
        dispatchQ.enter()
        
        var message1 = String()
        msgCaller.getMessage1{ (messageOne) in
            message1 = messageOne
            print("Message Receieved: \(message1)")
            dispatchQ.leave()

        }
        
        let result = dispatchQ.wait(timeout: DispatchTime.now() + 3)
        
        dispatchQ.notify(queue: .main)
        {
            if result == .success{
                XCTAssertEqual(message1, "Hello")
            }
        }

    }
    
    func testMessageTwo()
    {
        let msgCaller = MessageCaller()
              let dispatchQ = DispatchGroup()
              
              dispatchQ.enter()
              
              var message2 = String()
              msgCaller.getMessage2{ (messageTwo) in
                  message2 = messageTwo
                  print("Message Receieved: \(message2)")
                  dispatchQ.leave()

              }
              
              let result = dispatchQ.wait(timeout: DispatchTime.now() + 3)
              
              dispatchQ.notify(queue: .main)
              {
                  if result == .success{
                      XCTAssertEqual(message2, "world")
                  }
              }
    }
    
    func testCorrectOrder()
    {
        let dispatchG = DispatchGroup()
           let res: DispatchTimeoutResult
           
           let msgCaller = MessageCaller()

           var message1 = String()
           var message2 = String()
           
           dispatchG.enter()
           msgCaller.getMessage1{ (messageOne) in
               message1 = messageOne
               dispatchG.leave()
           }
           dispatchG.enter()
           
           msgCaller.getMessage2{ (messageTwo) in
            message2 = messageTwo
               dispatchG.leave()
           }
               
        res = dispatchG.wait(timeout: DispatchTime.now() + 2)
        dispatchG.notify(queue: .main)
        {
            if res == .success{

                XCTAssertEqual(message1 + message2, "Hello World")
            }
        }

    }
    
    func testLoadMessageTimeout() {
        let msgCaller = MessageCaller()
        let dispatchQ = DispatchGroup()
         
         dispatchQ.enter()
        let expectation = self.expectation(description: "completion")
        
        msgCaller.getMessage1 { (uMessage) in
            expectation.fulfill()
            dispatchQ.leave()
        }
        
        let result = dispatchQ.wait(timeout: DispatchTime.now() + 0)

        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(result, DispatchTimeoutResult.timedOut)
    }
    
    

}
