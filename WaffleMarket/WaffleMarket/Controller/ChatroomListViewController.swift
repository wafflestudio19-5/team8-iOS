//
//  ChatRoomListViewController.swift
//  WaffleMarket
//
//  Created by 안재우 on 2021/11/25.
//

import UIKit

import RxSwift
import RxRelay
import SwiftUI


struct Chatroom {
    var roomName: String
    var userName: String
    var profileImageUrl: String?
    var productImageUrl: String
    var lastChat: String
    
}
class ChatroomListViewController: UIViewController {
    var prevRoomNames: Set<String> = Set<String> ()
    let tableView = UITableView()
    let chatroomList = BehaviorRelay<[Chatroom]>(value: [])
    let disposeBag = DisposeBag()
    var poller: Observable<Int>?
    var subscription: Disposable?
    override func viewDidAppear(_ animated: Bool) {
        updateList()
        
        poller = Observable<Int>.interval(.seconds(3), scheduler: MainScheduler.instance)
        subscription = poller?.subscribe {_ in
            print("poll")
            self.updateList()
        } onError: { error in
            
        } onCompleted: {
            
        } onDisposed: {
            
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        subscription?.dispose()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(tableView)
        setTableView()
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        self.tableView.addGestureRecognizer(longPressGesture)
        
        
    
    }
    @objc func handleLongPress(longPressGesture: UILongPressGestureRecognizer) {
        let p = longPressGesture.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: p)
        if indexPath == nil {
            print("Long press on table view, not row.")
        } else if longPressGesture.state == UIGestureRecognizer.State.began {
            print("Long press on row, at \(indexPath!.row)")
            let chatroom = chatroomList.value[indexPath!.row]
            
            let alert = UIAlertController(title: chatroom.userName, message: "", preferredStyle: .actionSheet)
            let leave = UIAlertAction(title: "나가기", style: .destructive) { action in
                ChatAPI.leave(roomName: chatroom.roomName).subscribe { response in
                    print(String(decoding: response.data, as: UTF8.self ))
                    print(chatroom.roomName)
                    if response.statusCode / 100 == 2 {
                        self.updateList()
                        alert.dismiss(animated: true)
                    } else {
                        self.toast("오류가 발생했어요")
                    }
                    
                } onFailure: { error in
                    
                } onDisposed: {
                    
                }.disposed(by: self.disposeBag)

                
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel) { action in
                alert.dismiss(animated: true)
            }
            alert.addAction(leave)
            alert.addAction(cancel)
            self.present(alert, animated: true)
        }
    }
    private func setTableView(){
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.register(ChatroomListTableViewCell.self, forCellReuseIdentifier: ChatroomListTableViewCell.identifier)
        chatroomList.bind(to: tableView.rx.items(cellIdentifier: ChatroomListTableViewCell.identifier, cellType: ChatroomListTableViewCell.self)){ row, model, cell in
            cell.setData(userName: model.userName, profileImageUrl: model.profileImageUrl, lastChat: model.lastChat, productImageUrl: model.productImageUrl)
            
        }.disposed(by: disposeBag)
        tableView.rx.itemSelected.bind{indexPath in
            
            self.tableView.deselectRow(at: indexPath, animated: true)
            let chatroom = self.chatroomList.value[indexPath.item]
            let imageView = UIImageView()
        
            CachedImageLoader().load(path: chatroom.profileImageUrl, putOn: imageView) { imageView, usedCache in
                DispatchQueue.main.async{
                    
                    let chatView = ChatView()
                    
                    if !ChatCommunicator.shared.checkConnection(roomName: chatroom.roomName){
                        ChatCommunicator.shared.connect(roomName: chatroom.roomName)
                    }
                    let me = ChatUser(name: AccountManager.userProfile!.userName!, avatar: nil, isCurrentUser: true)
                    let opponent = ChatUser(name: chatroom.userName, avatar: imageView.image)
                    let dataSource = DataSource(me:me, opponent: opponent, messages: ChatCommunicator.shared.chatLog[chatroom.roomName] ?? [], productImage: chatroom.productImageUrl)
                    let chatHelper = ChatHelper(roomName: chatroom.roomName, dataSource: dataSource)
                    let vc = UIHostingController(rootView: chatView.environmentObject(chatHelper))
                    vc.navigationItem.title = chatroom.userName
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
            
        }.disposed(by: disposeBag)
    }
    private func updateList(){
        ChatAPI.listByUser().subscribe { response in
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ChatroomResponse].self, from: response.data) {
                var temp: [Chatroom] = []
                var roomNames = Set<String>()
                for item in decoded{
                    let lastChat = ChatCommunicator.shared.chatLog[item.roomname]?.last?.content ?? " "
                    roomNames.insert(item.roomname+lastChat)
                    temp.append(Chatroom(roomName: item.roomname, userName: item.username, profileImageUrl: item.profile_image, productImageUrl: item.product_image.thumbnail_url, lastChat: lastChat))
                }
                if roomNames != self.prevRoomNames {
                    self.chatroomList.accept(temp)
                    self.prevRoomNames = roomNames
                }
            } else {
                self.toast("채팅방 목록을 불러오는데 실패했어요")
                print(String(decoding: response.data, as: UTF8.self))
            }
        } onFailure: { error in
            
        } onDisposed: {
            
        }.disposed(by: disposeBag)

    }
}

extension ChatroomListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}
