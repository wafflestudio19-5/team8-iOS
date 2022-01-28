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
    let tableView = UITableView()
    let chatroomList = BehaviorRelay<[Chatroom]>(value: [])
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(tableView)
        setTableView()
        updateList()
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
            let chatroom = self.chatroomList.value[indexPath.item]
            self.tableView.deselectRow(at: indexPath, animated: true)
            let chatView = ChatView()
            if !ChatCommunicator.shared.checkConnection(roomName: chatroom.roomName){
                ChatCommunicator.shared.connect(roomName: chatroom.roomName)
            }
            let me = ChatUser(name: AccountManager.userProfile!.userName!, avatar: AccountManager.userProfile!.profileImageUrl!, isCurrentUser: true)
            let opponent = ChatUser(name: chatroom.userName, avatar: chatroom.profileImageUrl)
            let dataSource = DataSource(me:me, opponent: opponent, messages:[])
            let chatHelper = ChatHelper(roomName: chatroom.roomName, dataSource: dataSource)
            
            let vc = UIHostingController(rootView: chatView.environmentObject(chatHelper))
            self.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
    }
    private func updateList(){
        ChatAPI.listByUser().subscribe { response in
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ChatroomResponse].self, from: response.data) {
                var temp: [Chatroom] = []
                for item in decoded{
                    temp.append(Chatroom(roomName: item.roomname, userName: item.username, profileImageUrl: item.profile_image, productImageUrl: item.product_image.thumbnail_url, lastChat: "sample"))
                }
                self.chatroomList.accept(temp)
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
