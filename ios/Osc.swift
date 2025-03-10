/*
Copyright (C) 2020 Luis Fernando Garcia Perez
contacto@luiscript.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/


import Foundation
import Network
import SwiftOSC
import os

@objc(Osc) class Osc : RCTEventEmitter, OSCDelegate {
        
    var client:OSCClient!
    var server:OSCServer!
    
    //////////////////////////////////////
    // CLIENT STUFF
    @objc(createClient:port:)
    func createClient(address: String, port: NSNumber) -> Void {
        client = OSCClient(host: address, port: port.uint16Value)
    }
    
    @objc(restartClient)
    func restartClient() -> Void {
        if client == nil {
            return
        }
        client.restart()
    }
    
    @objc(sendMessage:data:)
    func sendMessage(address: String, data: NSArray) -> Void {
        if client == nil {
            return
        }
        let message = OSCMessage(OSCAddressPattern(address)!)
        
        for value in data {
            switch value {
                case let someInt as Int:
                    message.add(someInt)
                case let someDouble as Double where someDouble > 0:
                    message.add(someDouble)
                case let someBool as Bool:
                    message.add(someBool)
                case let someString as String:
                    message.add(someString)
                default:
                    print("data not supported")
            }
        }
        client.send(message)
    }
    
    //////////////////////////////////////
    // SERVER STUFF
    @objc(createServer:bonjourName:)
    func createServer(port: NSNumber, bonjourName: String?) -> Void {
        server = OSCServer(port: port.uint16Value, bonjourName: bonjourName, delegate: self)
    }

    @objc(restartServer)
    func restartServer() -> Void {
        if server == nil {
            return
        }
        server.restart()
    }

    func didReceive(_ message: OSCMessage) {
        let response: NSMutableDictionary = [:]
        response["address"] = message.address.string
        response["data"] = message.arguments
        sendEvent(withName: "GotMessage", body: response)
    }
    func didReceive(_ message: OSCMessage, port: NWEndpoint.Port) {}
    func didReceive(_ data: Data) {}
    func didReceive(_ bundle: OSCBundle) {}
    func didReceive(_ bundle: OSCBundle, port: NWEndpoint.Port) {}
    
    override func supportedEvents() -> [String]! {
      return ["GotMessage"]
    }
    
    override class func requiresMainQueueSetup() -> Bool {
        return false
    }
}

