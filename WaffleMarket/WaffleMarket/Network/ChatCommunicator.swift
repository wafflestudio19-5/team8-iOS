//
//  ChatCommunicator.swift
//  WaffleMarket
//
//  Created by 안재우 on 2022/01/22.
//

import Foundation
import RxSwift
import Starscream
import Moya
import RxRelay
class ChatCommunicator: NSObject{
    private var sockets: [String: WebSocket] = [:]
    private var isConnected: [String: Bool] = [:]
    var didReceive: [String: PublishRelay<String>] = [:]
    var hasRoom: [String: Bool] = [:]
    public var chatLog: [String: [ChatMessage]] = [:]
    public static let shared = ChatCommunicator()
    private override init(){
        super.init()
    }
    func connect(roomName: String, latestMessage: Int? = nil){
        var request = URLRequest(url: URL(string: (APIConstants.WEBSOCKET_URL+"/chat/\(roomName)/" + (latestMessage == nil ? "?latest_message=0" : "?latest_message=\(latestMessage!)")))!)
        request.timeoutInterval = 10
        request.setValue("JWT "+AccountManager.token!, forHTTPHeaderField:  "Authorization")
        
        let sock = WebSocket(request: request)
        didReceive[roomName] = PublishRelay<String>()
        sock.onEvent = { event in
            switch event {
            case .connected(let headers):
                self.isConnected[roomName] = true
                print("WAFFLESOCK: connected to \(roomName): \(headers)")
            case .disconnected(let reason, let code):
                self.isConnected[roomName] = false
                self.didReceive[roomName] = nil
                print("WAFFLESOCK: disconnected with \(roomName): \(reason) with code \(code)")
            case .text(let string):
                print("WAFFLESOCK: received text on \(roomName): \(string)")
                self.didReceive[roomName]!.accept(string)
            case .binary(let data):
                print("WAFFLESOCK: received data on \(roomName): \(data.count)")
            case .ping(_):
                break
            case .pong(_):
                break
            case .viabilityChanged(_):
                break
            case .reconnectSuggested(_):
                break
            case .cancelled:
                self.isConnected[roomName] = false
                self.didReceive[roomName] = nil
            case .error(let error):
                self.isConnected[roomName] = false
                self.didReceive[roomName] = nil
                print("WAFFLESOCK: error \(roomName): \(String(describing: error!))")
            }
        }
        sock.connect()
        sockets[roomName] = sock

    }
    
    func disconnect(roomName: String){
        if let sock = sockets[roomName] {
            sock.disconnect()
        }
    }
    
    func checkConnection(roomName: String) -> Bool{
        return isConnected[roomName] ?? false
    }
    func sendMessage(roomName: String, content: String, completion: @escaping(()->Void)) -> Bool{
        if let sock = sockets[roomName] {
            let jsonDict: [String: String] = ["chat": content]
            let data = try! JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted)
            if isConnected[roomName] ?? false {
                sock.write(string: String(data: data, encoding: String.Encoding.utf8)!, completion: completion)
                return true
            } else {
                print("WAFFLESOCK: not connected to \(roomName)!")
                return false
            }
        } else {
            print("WAFFLESOCK: socket for \(roomName) does not exist!")
            return false
        }
    }
    
    
    /*
     
        {
            'chat': 'content'
        }
     
     */
}

struct MessageResponse: Decodable {
    var id: Int
    var content: String
    var is_sender: Bool
}
