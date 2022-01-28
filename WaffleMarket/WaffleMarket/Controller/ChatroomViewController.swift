//
//  ChatroomViewController.swift
//  WaffleMarket
//
//  Created by 안재우 on 2022/01/21.
//

import Foundation
import SwiftUI
import Combine
import RxSwift


final class KeyboardResponder: ObservableObject {
    private var notificationCenter: NotificationCenter
    @Published private(set) var currentHeight: CGFloat = 0

    init(center: NotificationCenter = .default) {
        notificationCenter = center
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        notificationCenter.removeObserver(self)
    }

    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            currentHeight = keyboardSize.height
        }
    }

    @objc func keyBoardWillHide(notification: Notification) {
        currentHeight = 0
    }
}

struct ChatMessage: Hashable {
    var id = UUID()
    var content: String
    var user: ChatUser
}

struct ChatUser: Hashable {
    var name: String
    var avatar: UIImage?
    var isCurrentUser: Bool = false
}

struct DataSource {
    let me: ChatUser
    let opponent: ChatUser
    var messages: [ChatMessage]
    var productImage: String
    

}

struct MessageContentView: View {
    var content: String
    var isCurrentUser: Bool
    var body: some View {
        Text(content)
            .padding(10)
            .foregroundColor(isCurrentUser ? Color.white : Color.black)
            .background(isCurrentUser ? .orange : Color(UIColor.systemGray6))
            .cornerRadius(10)
    }
}

struct MessageView: View {
    var currentMessage: ChatMessage
    var body: some View {
        HStack(alignment: .bottom, spacing: 15) {
            
            if !currentMessage.user.isCurrentUser {
                if currentMessage.user.avatar == nil {
                    Image("defaultProfileImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40, alignment: .center)
                        .cornerRadius(20)
                } else {
                    Image(uiImage: currentMessage.user.avatar!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40, alignment: .center)
                            .cornerRadius(20)
                }
                    
            } else {
                Spacer()
            }
            MessageContentView(content: currentMessage.content, isCurrentUser: currentMessage.user.isCurrentUser)
                .frame(minWidth: 10)
            if !currentMessage.user.isCurrentUser{
                Spacer()
            }
        }
    }
}


    
class ChatHelper: ObservableObject {
    let disposeBag = DisposeBag()
    let roomName: String
    var didChange = PassthroughSubject<Void, Never>()
    var dataSource: DataSource
    @Published var realTimeMessages: [ChatMessage]
    init(roomName: String, dataSource: DataSource) {
        self.roomName = roomName
        self.dataSource = dataSource
        realTimeMessages = self.dataSource.messages
        ChatCommunicator.shared.didReceive[roomName]?.bind(onNext: { content in
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([MessageResponse].self, from: content.data(using: .utf8)!) {
                for item in decoded {
                    
                    self.realTimeMessages.append(ChatMessage(content: item.content, user: item.is_sender ? dataSource.me : dataSource.opponent))
                }
                ChatCommunicator.shared.chatLog[self.roomName] = self.realTimeMessages
                    
            }
            
        }).disposed(by: disposeBag)
    }
    func sendMessage(_ msg: ChatMessage) {
        //realTimeMessages.append(msg)
        let sendable = ChatCommunicator.shared.sendMessage(roomName: roomName, content: msg.content) {
            print("sent!")
        }
        if !sendable {
            print("not sendable")
        }
        didChange.send(())
        
    }
}

struct ChatView: View {

    @State var typingMessage: String = ""
    @EnvironmentObject var chatHelper: ChatHelper
    @ObservedObject private var keyboard = KeyboardResponder()
    
    init() {
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().tableFooterView = UIView()
    }
    var body: some View {
        HStack(alignment: .center) {
            AsyncImage(
                url: URL(string: chatHelper.dataSource.productImage)!,
                content: { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 100, maxHeight: 100)
                    case .failure:
                        Image(systemName: "photo")
                    @unknown default:
                        EmptyView()
                    }
                    
                    
                }
            )
            
            
        }.frame(height: 100)
        VStack {
            ScrollViewReader { scrollView in
                ScrollView{
                    LazyVStack{
                        ForEach(chatHelper.realTimeMessages, id: \.self) { msg in
                            MessageView(currentMessage: msg).listRowSeparator(.hidden)
                        }
                    }.padding(.horizontal, 10)
                        .onAppear {
                            scrollView.scrollTo(chatHelper.realTimeMessages.last)
                        }
                }.onChange(of: chatHelper.realTimeMessages.count) { _ in
                    scrollView.scrollTo(chatHelper.realTimeMessages[chatHelper.realTimeMessages.endIndex-1])
                }
                
            }
            HStack {
                TextField("메시지를 입력하세요", text: $typingMessage)
                    .disableAutocorrection(true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minHeight: CGFloat(30))
                Button(action: sendMessage) {
                    Text("전송")
                }
            }.padding(.horizontal, 10)
                
        }.onTapGesture {
            self.endEditing(true)
        }
            .padding(.bottom, keyboard.currentHeight)
            .edgesIgnoringSafeArea(keyboard.currentHeight == 0.0 ? .leading : .bottom)
            
    }
    
    func sendMessage(){
        if typingMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return
        }
        chatHelper.sendMessage(ChatMessage(content: typingMessage, user: chatHelper.dataSource.me))
        typingMessage = ""
    }
}


//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView().environmentObject(ChatHelper(roomName: "11", dataSource: DataSource(me: ChatUser(name: "AJW", avatar: UIImage(named:"defaultProfileImage"), isCurrentUser: true), opponent: ChatUser(name:"Test", avatar: UIImage(named:"defaultProfileImage")), messages: [])))
//    }
//}
