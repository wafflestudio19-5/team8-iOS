//
//  CommentViewController.swift
//  WaffleMarket
//
//  Created by Chaemin Lee on 2022/01/08.
//

import UIKit
import RxSwift
import RxRelay

class CommentViewController: UIViewController {

    let textSize: CGFloat = 16

    let commentTableView: UITableView = UITableView()
    let bottomView = UIView()
    let writeCommentBtn = UIButton(type:.custom)
    let commentField = UITextField()
    let disposeBag = DisposeBag()

    let comments = BehaviorRelay<[Comment]>(value:[])
    var articleId = 0
    var isReplyMode = false
    var replyCommentId = 0

    
    var originalViewHeight: CGFloat = 0
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }
        
      
      // move the root view up by the distance of keyboard height
        self.view.frame.size.height = originalViewHeight - ((self.view.frame.origin.y + originalViewHeight) - keyboardSize.origin.y)
        self.commentTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: (self.view.frame.origin.y + self.view.frame.size.height) - keyboardSize.origin.y, right: 0)
        
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        print("kwillhide")
      
      // move the root view up by the distance of keyboard height
        
        self.view.frame.size.height = originalViewHeight
        self.commentTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    private func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeObserver(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

       //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addSubview(commentTableView)
        setCommentTableView()
        view.addSubview(bottomView)
        setBottomView()
        getComments()
        originalViewHeight = self.view.frame.size.height
        
        //test_fetchDummyData()
        // Do any additional setup after loading the view.
    }
    private func getComments(){
        print("getcomments ", articleId)
        ArticleAPI.getComments(articleId: articleId).subscribe { response in
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([CommentResponse].self, from: response.data) {
                var comments: [Comment] = []
                var addedIds: Set<Int> = Set<Int>()
                
                for commentResponse in decoded {
                    if addedIds.contains(commentResponse.id) {
                        continue
                    }
                    if commentResponse.deleted_at != nil {
                        continue
                    }
        
                    let comment = Comment(id: commentResponse.id, username: commentResponse.commenter.username, profile_image: commentResponse.commenter.profile_image ?? "default", timestamp: commentResponse.created_at, content: commentResponse.content, isReply: false, deletable: commentResponse.delete_enable, commenter_id: commentResponse.commenter.id ?? -1)
                    addedIds.update(with: commentResponse.id)
                    comments.append(comment)
                    for reply in commentResponse.replies ?? [] {
                        if addedIds.contains(reply.id) {
                            continue
                        }
                        if reply.deleted_at != nil {
                            continue
                        }
    
                        let comment2 = Comment(id: reply.id, username: reply.commenter.username, profile_image: reply.commenter.profile_image ?? "default", timestamp: reply.created_at, content: reply.content, isReply: true, deletable: reply.delete_enable, commenter_id: reply.commenter.id ?? -1)
                        addedIds.update(with: reply.id)
                        comments.append(comment2)
                    }
                    
                    
                }
                self.comments.accept(comments)
                self.commentTableView.reloadData()
            } else {
                print("failed to parse comments")
            }
        } onFailure: { error in
            
        } onDisposed: {
            
        }.disposed(by: disposeBag)

    }

    private func setCommentTableView() {
        
        commentTableView.translatesAutoresizingMaskIntoConstraints = false
        commentTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        commentTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        commentTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        commentTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -80).isActive = true
        commentTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        commentTableView.rx.setDelegate(self).disposed(by: disposeBag)
        comments.bind(to: commentTableView.rx.items(cellIdentifier: CommentTableViewCell.identifier, cellType: CommentTableViewCell.self)){ row, item, cell in
            cell.setData(isReply: item.isReply, username: item.username, profile_image: item.profile_image, content: item.content, timestamp: item.timestamp)
            
        }.disposed(by: disposeBag)
        commentTableView.rx.itemSelected.bind{ indexPath in
            let alert = UIAlertController(title: "작업 선택", message: "", preferredStyle: .actionSheet)
            let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { action in
                ArticleAPI.deleteComment(articleId: self.articleId, commentId: self.comments.value[indexPath.item].id).subscribe { response in
                    print(String(decoding: response.data, as: UTF8.self))
                    self.getComments()
                } onFailure: { error in
                    
                } onDisposed: {
                    
                }.disposed(by: self.disposeBag)

                alert.dismiss(animated: true)
            }
            let replyAction = UIAlertAction(title: "답글 달기", style: .default) { action in
                self.isReplyMode = true
                self.replyCommentId = self.comments.value[indexPath.item].id
                alert.dismiss(animated: true)
            }
            let sellAction = UIAlertAction(title: "판매 완료", style: .default) { action in
                self.commentTableView.deselectRow(at: indexPath, animated: true)
                ArticleAPI.registerBuyer(articleId: self.articleId, buyer_id: self.comments.value[indexPath.item].commenter_id).subscribe { response in
                    print(String(decoding: response.data, as: UTF8.self))
                    self.navigationController?.popViewController(animated: true)
                } onFailure: { error in
                    
                } onDisposed: {
                    
                }.disposed(by: self.disposeBag)
                alert.dismiss(animated: true)
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel) { action in
                self.commentTableView.deselectRow(at: indexPath, animated: true)
                alert.dismiss(animated: true)
            }
            if self.comments.value[indexPath.item].deletable {
                alert.addAction(deleteAction)
            }
            alert.addAction(replyAction)
            alert.addAction(sellAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true)
        }.disposed(by: disposeBag)
    }
    
    private func setBottomView() {
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        bottomView.topAnchor.constraint(equalTo: commentTableView.bottomAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        bottomView.addSubview(commentField)
        setCommentField()
        bottomView.addSubview(writeCommentBtn)
        setCommentBtn()
        
    }
    
    private func setCommentField() {
        
        commentField.translatesAutoresizingMaskIntoConstraints = false
        commentField.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 20).isActive = true
        commentField.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 15).isActive = true
        commentField.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -80).isActive = true
        commentField.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -15).isActive = true
        
        commentField.backgroundColor = .clear
        commentField.layer.cornerRadius = 10
        commentField.placeholder = "  댓글을 작성하세요"
        commentField.autocapitalizationType = .none
        commentField.autocorrectionType = .no
        
    }
    
    private func setCommentBtn() {
        
        writeCommentBtn.translatesAutoresizingMaskIntoConstraints = false
        writeCommentBtn.leadingAnchor.constraint(equalTo: commentField.trailingAnchor, constant: 10).isActive = true
        writeCommentBtn.topAnchor.constraint(equalTo: commentField.topAnchor).isActive = true
        writeCommentBtn.bottomAnchor.constraint(equalTo: commentField.bottomAnchor).isActive = true
        writeCommentBtn.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -20).isActive = true
        
        writeCommentBtn.setTitle("확인", for: .normal)
        writeCommentBtn.backgroundColor = .orange
        writeCommentBtn.layer.cornerRadius = 8
        writeCommentBtn.titleLabel?.font = .systemFont(ofSize: 14)
        writeCommentBtn.rx.tap.bind{
            print("click")
            guard let content = self.commentField.text else {
                self.toast("내용을 입력하세요", y: 50)
                return
            }
            if self.isReplyMode {
                self.isReplyMode = false
                ArticleAPI.postReply(articleId: self.articleId, commentId: self.replyCommentId, content: content).subscribe { response in
                    self.commentField.text = ""
                    print("afterpostreply", String(decoding: response.data, as: UTF8.self))
                    self.getComments()
                } onFailure: { error in
                    
                } onDisposed: {
                    
                }.disposed(by: self.disposeBag)
                
            } else {
                ArticleAPI.postComment(articleId: self.articleId, content: content).subscribe { response in
                    self.commentField.text = ""
                    print("afterpostcomment", String(decoding: response.data, as: UTF8.self))
                    self.getComments()
                } onFailure: { error in
                    
                } onDisposed: {
                    
                }.disposed(by: self.disposeBag)
            }
        }.disposed(by: disposeBag)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CommentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return comments.value[indexPath.item].content.getEstimatedFrame(with: .systemFont(ofSize: 12)).size.height + 90
    }
}
