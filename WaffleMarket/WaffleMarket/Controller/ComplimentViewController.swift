//
//  ComplimentViewController.swift
//  WaffleMarket
//
//  Created by Chaemin Lee on 2022/01/24.
//

import UIKit
import RxSwift
import RxCocoa

class ComplimentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var userId: Int!
    let complimentLabel = UILabel()
    let complimentTableView = UITableView()
    let buttonView = UIView()
    let completeBtn = UIButton()
    
    let compliments: [String] = ["친절하고 매너가 좋아요.", "시간 약속을 잘 지켜요.", "응답이 빨라요."]
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.topItem?.title = "매너 칭찬 남기기"
        self.complimentTableView.dataSource = self
        self.complimentTableView.delegate = self
        self.complimentTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        view.addSubview(complimentLabel)
        setComplimentLabel()
        view.addSubview(complimentTableView)
        setComplimentTableView()
        view.addSubview(buttonView)
        setButtonView()
    }
    
    private func setComplimentLabel() {
        
        complimentLabel.translatesAutoresizingMaskIntoConstraints = false
        complimentLabel.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        complimentLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        complimentLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        complimentLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        complimentLabel.numberOfLines = 2
        complimentLabel.text = "남기고 싶은 칭찬을 선택해 주세요.\n(칭찬 인사를 남기면 상대방의 매너 온도가 올라갑니다)"
        complimentLabel.baselineAdjustment = .alignCenters
        
    }
    
    private func setComplimentTableView() {
        
        complimentTableView.translatesAutoresizingMaskIntoConstraints = false
        complimentTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        complimentTableView.topAnchor.constraint(equalTo: complimentLabel.bottomAnchor, constant: 20).isActive = true
        complimentTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        complimentTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -70).isActive = true
        
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
            if let row = self.complimentTableView.indexPathForSelectedRow?.row {
                ReviewAPI.updateManner(userId: self.userId, type: "good", mannerList: [self.compliments[row]]).subscribe { response in
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
        return self.compliments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = compliments[indexPath.row]
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
