//
//  Concurrency.swift


import Foundation

protocol MessageRetriever
{
    func getMessage1(completion: @escaping (String) -> Void)
    func getMessage2(completion: @escaping (String) -> Void)
}

func loadMessage(completion: @escaping (String) -> Void) {

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
    
    if res == .success {
        completion("\(message1) \(message2)")
    } else {
        completion("Unable to load message - Time out exceeded")
    }

}

class MessageCaller: MessageRetriever
{
    func getMessage1(completion: @escaping (String) -> Void) {
        fetchMessageOne { (messageOne) in
            completion(messageOne)
        }
    }
    
    func getMessage2(completion: @escaping (String) -> Void) {
        fetchMessageTwo { (messageTwo) in
            completion(messageTwo)
        }
    }
    
    
}

