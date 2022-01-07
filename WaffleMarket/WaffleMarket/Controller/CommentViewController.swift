//
//  CommentViewController.swift
//  WaffleMarket
//
//  Created by Chaemin Lee on 2022/01/08.
//

import UIKit
import RxSwift

class CommentViewController: UIViewController {

    let textSize: CGFloat = 16

    let commentTableView: UITableView = UITableView()
    let bottomView = UIView()
    let writeCommentBtn = UIButton(type:.custom)
    let commentField = UITextField()
    let disposeBag = DisposeBag()
    
    var originalViewY: CGFloat = 0
    @objc func keyboardWillShow(notification: NSNotification) {
        print("kwillshow")
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }
        
      // move the root view up by the distance of keyboard height
        let delta = keyboardSize.origin.y
        if delta > 0 {
            self.bottomView.frame.origin.y = self.bottomView.frame.origin.y - delta
        }
        
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        print("kwillhide")
      
      // move the root view up by the distance of keyboard height
        
        self.bottomView.frame.origin.y = originalViewY
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
        originalViewY = self.bottomView.frame.origin.y
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

       //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addSubview(commentTableView)
        setCommentTableView()
        view.addSubview(bottomView)
        setBottomView()
        // Do any additional setup after loading the view.
    }
    
    private func setCommentTableView() {
        
        commentTableView.translatesAutoresizingMaskIntoConstraints = false
        commentTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        commentTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        commentTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        commentTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -80).isActive = true
        
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
        
        commentField.backgroundColor = .lightGray
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
        
        writeCommentBtn.setTitle("⬆️", for: .normal)
        writeCommentBtn.backgroundColor = .clear
        writeCommentBtn.titleLabel?.font = .systemFont(ofSize: 25)
        
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
