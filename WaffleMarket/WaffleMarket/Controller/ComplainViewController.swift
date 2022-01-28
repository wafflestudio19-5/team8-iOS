//
//  ComplainViewController.swift
//  WaffleMarket
//
//  Created by Chaemin Lee on 2022/01/24.
//

import UIKit
import RxSwift
import RxCocoa

class ComplainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var userId: Int!
    let complainLabel = UILabel()
    let complainTableView = UITableView()
    let buttonView = UIView()
    let completeBtn = UIButton()
    
    let complains: [String] = ["반말을 사용해요.", "불친절해요."]
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.topItem?.title = "비매너 평가하기"
        self.complainTableView.dataSource = self
        self.complainTableView.delegate = self
        self.complainTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        view.addSubview(complainLabel)
        setComplimentLabel()
        view.addSubview(complainTableView)
        setComplimentTableView()
        view.addSubview(buttonView)
        setButtonView()
    }
    
    private func setComplimentLabel() {
        
        complainLabel.translatesAutoresizingMaskIntoConstraints = false
        complainLabel.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        complainLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        complainLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        complainLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        
        complainLabel.text = "불편했던 점을 선택해 주세요.\n(불편사항을 제출하면 상대방의 매너온도가 떨어집니다)"
        complainLabel.baselineAdjustment = .alignCenters
        
    }
    
    private func setComplimentTableView() {
        
        complainTableView.translatesAutoresizingMaskIntoConstraints = false
        complainTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        complainTableView.topAnchor.constraint(equalTo: complainLabel.bottomAnchor, constant: 20).isActive = true
        complainTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        complainTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -70).isActive = true
        
    }
    
    private func setButtonView() {
        
        view.addSubview(completeBtn)

        completeBtn.translatesAutoresizingMaskIntoConstraints = false
        completeBtn.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        
        completeBtn.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        completeBtn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        completeBtn.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        completeBtn.backgroundColor = .orange
        completeBtn.setTitle("평가완료", for: .normal)
        
        completeBtn.rx.tap.bind{
            print("완료")
            if let row = self.complainTableView.indexPathForSelectedRow?.row {
                ReviewAPI.updateManner(userId: self.userId, type: "bad", mannerList: [self.complains[row]]).subscribe { response in
                    print(String(decoding: response.data, as: UTF8.self))
                    if response.statusCode / 100 == 2 {
                        self.dismiss(animated: true)
                    }
                } onFailure: { error in
                    
                } onDisposed: {
                    
                }.disposed(by: self.disposeBag)

                
            }
        }.disposed(by: disposeBag)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.complains.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = complains[indexPath.row]
        return cell
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
