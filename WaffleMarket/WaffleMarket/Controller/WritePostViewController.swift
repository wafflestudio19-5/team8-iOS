//
//  WritePostViewController.swift
//  WaffleMarket
//
//  Created by 안재우 on 2021/12/28.
//

import Foundation
import UIKit
import RxSwift
class WritePostViewController: UIViewController {
    let textSize: CGFloat = 18
    let scrollView = UIScrollView()
    let scrollContentView = UIView()
    let stackView = UIStackView()
    let addPhotoBtn = UIButton()
    let countPhotoLabel = UILabel()
    
    let titleField = UITextField()
    let categoryPicker = UIPickerView()
    let categoryBtn = UIButton(type:.system)
    let priceField = UITextField()
    let contentField = UITextView()
    
    let completeBtn = UIBarButtonItem()
    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(scrollView)
        setScrollView()
        
        stackView.addArrangedSubview(addPhotoBtn)
        divider()
        stackView.addArrangedSubview(titleField)
        divider()
        stackView.addArrangedSubview(categoryBtn)
        divider()
        stackView.addArrangedSubview(priceField)
        divider()
        stackView.addArrangedSubview(contentField)
        
        setAddPhotoBtn()
        setTitleField()
        setCategoryBtn()
        setPriceField()
        setContentField()
        
        setCompleteBtn()
        self.navigationItem.rightBarButtonItem = completeBtn
    }
    private func divider(){
        if stackView.arrangedSubviews.count > 0 {
            let separator = UIView()
            separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
            separator.backgroundColor = .separator
            stackView.addArrangedSubview(separator)
            separator.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        }
    }
    private func setScrollView(){
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(stackView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        scrollContentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -20).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: 20).isActive = true
        stackView.heightAnchor.constraint(equalTo: scrollContentView.heightAnchor).isActive = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.alignment = .leading
    }
    private func setAddPhotoBtn(){
        addPhotoBtn.rx.tap.bind{
            print("add photo")
        }.disposed(by: disposeBag)
        
        let btnImage = UIImageView()
        btnImage.isUserInteractionEnabled = false
        addPhotoBtn.translatesAutoresizingMaskIntoConstraints = false
        btnImage.translatesAutoresizingMaskIntoConstraints = false
        countPhotoLabel.translatesAutoresizingMaskIntoConstraints = false
        let containerView = UIStackView()
        containerView.isUserInteractionEnabled = false
        addPhotoBtn.addSubview(containerView)
        NSLayoutConstraint.activate([
            addPhotoBtn.heightAnchor.constraint(equalToConstant: 60),
            addPhotoBtn.widthAnchor.constraint(equalToConstant: 60),
            containerView.topAnchor.constraint(greaterThanOrEqualTo: addPhotoBtn.topAnchor),
            containerView.bottomAnchor.constraint(lessThanOrEqualTo: addPhotoBtn.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: addPhotoBtn.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: addPhotoBtn.trailingAnchor),
            containerView.centerYAnchor.constraint(equalTo: addPhotoBtn.centerYAnchor),
        ])
        
        
        containerView.axis = .vertical
        containerView.spacing = 1
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.alignment = .center
        
        containerView.alignment = .center
        containerView.addArrangedSubview(btnImage)
        containerView.addArrangedSubview(countPhotoLabel)
        
        
        addPhotoBtn.layer.borderColor = UIColor.gray.cgColor
        addPhotoBtn.layer.borderWidth = 0.2
        addPhotoBtn.layer.cornerRadius = 8
        btnImage.tintColor = .gray
        btnImage.image = UIImage(systemName: "camera.fill")
        btnImage.contentMode = .scaleAspectFit
        
        countPhotoLabel.isUserInteractionEnabled = false
        countPhotoLabel.textAlignment = .center
        countPhotoLabel.numberOfLines = 1
        countPhotoLabel.text="0/10"
        countPhotoLabel.font = UIFont.systemFont(ofSize: 16)
        countPhotoLabel.textColor = .gray
    }
    
    private func setTitleField(){
        titleField.translatesAutoresizingMaskIntoConstraints = false
        titleField.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        titleField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        titleField.placeholder = "제목"
        titleField.font = UIFont.systemFont(ofSize: textSize)
    }
    
    
    private func setCategoryBtn(){
        categoryBtn.translatesAutoresizingMaskIntoConstraints = false
        categoryBtn.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        categoryBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        categoryBtn.contentHorizontalAlignment = .left
        if let titleLabel = categoryBtn.titleLabel {
            titleLabel.font = UIFont.systemFont(ofSize: textSize)
        }
        categoryBtn.setTitleColor(.black, for: .normal)
        categoryBtn.setTitle("카테고리", for: .normal)
        
        // MARK: show picker view
        Observable.just(["디지털기기", "생활가전", "가구/인테리어", "유아동", "생활/가공식품", "유아도서", "스포츠/레저", "여성잡화", "여성의류", "남성패션/잡화", "게임/취미", "뷰티/미용", "반려동물용품", "도서/티켓/음반", "식물", "기타 중고물품", "삽니다"]).bind(to: categoryPicker.rx.itemTitles) {
            _, item in
            return "\(item)"
        }.disposed(by: disposeBag)
    }
    
    private func setPriceField(){
        priceField.translatesAutoresizingMaskIntoConstraints = false
        priceField.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        priceField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        priceField.placeholder = "가격"
        priceField.font = UIFont.systemFont(ofSize: textSize)
    }
    
    private func setContentField(){
        contentField.translatesAutoresizingMaskIntoConstraints = false
        
        contentField.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        contentField.setContentHuggingPriority(.defaultLow, for: .vertical)
        contentField.isScrollEnabled = false
        contentField.textContainer.lineFragmentPadding = 0
        contentField.isEditable = true
        contentField.textContainerInset = .zero
        contentField.font = UIFont.systemFont(ofSize: textSize)
        
    }
    
    private func setCompleteBtn(){
        completeBtn.title = "완료"
        completeBtn.rx.tap.bind{
            let title = self.titleField.text ?? ""
            let price = self.priceField.text ?? ""
            let content = self.contentField.text ?? ""
            // MARK: request to backend
            
        }.disposed(by: disposeBag)
    }
}
