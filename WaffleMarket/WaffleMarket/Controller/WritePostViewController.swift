//
//  WritePostViewController.swift
//  WaffleMarket
//
//  Created by 안재우 on 2021/12/28.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxRelay
import YPImagePicker


class WritePostViewController: UIViewController {
    let textSize: CGFloat = 18
    let scrollView = UIScrollView()
    let scrollContentView = UIView()
    let stackView = UIStackView()
    let imageContainerView = UIStackView()
    let addImageBtn = UIButton()
    let selectedImageCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        
        
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return cv
    }()
    let countImageLabel = UILabel()
    
    let titleField = UITextField()
    let categoryPicker = UIPickerView()
    let categoryBtn = UIButton(type:.system)
    let priceField = UITextField()
    let contentField = UITextView()
    
    
    let selectedImages = BehaviorRelay<[UIImage]>(value: [])
    let maxImageNumber = 10
    var imageCount = 0
    
    
    let completeBtn = UIBarButtonItem()
    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(scrollView)
        setScrollView()
        
        stackView.addArrangedSubview(imageContainerView)
        divider()
        stackView.addArrangedSubview(titleField)
        divider()
        stackView.addArrangedSubview(categoryBtn)
        divider()
        stackView.addArrangedSubview(priceField)
        divider()
        stackView.addArrangedSubview(contentField)
        
        setImageContainerView()
        setSelectedImageCollectionView()
        setTitleField()
        setCategoryBtn()
        setPriceField()
        setContentField()
        
        setCompleteBtn()
        bindSelectedImages()
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
    private func setImageContainerView(){
        addImageBtn.rx.tap.bind{
            var config = YPImagePickerConfiguration()
            config.library.maxNumberOfItems = self.maxImageNumber - self.imageCount
            config.library.preSelectItemOnMultipleSelection = false
            config.library.defaultMultipleSelection = true
            config.library.mediaType = .photo
            config.library.isSquareByDefault = false
            config.onlySquareImagesFromCamera = false
            config.hidesCancelButton = false
            
            config.startOnScreen = .library
            
            let imagePicker = YPImagePicker(configuration: config)
            imagePicker.didFinishPicking{[unowned imagePicker] items, _ in
                var newImages:[UIImage] = []
                
                for item in items {
                    switch item{
                    case .photo(let photo):
                        newImages += [photo.image]
                    case .video:
                        print("video is not allowed")
                    }
                    
                }
                self.selectedImages.accept(self.selectedImages.value+newImages)
                imagePicker.dismiss(animated: true)
            }
            imagePicker.view.backgroundColor = .white
            self.present(imagePicker, animated: true)
        }.disposed(by: disposeBag)
        
        let btnImage = UIImageView()
        btnImage.isUserInteractionEnabled = false
        addImageBtn.translatesAutoresizingMaskIntoConstraints = false
        btnImage.translatesAutoresizingMaskIntoConstraints = false
        countImageLabel.translatesAutoresizingMaskIntoConstraints = false
        let btnContainerView = UIStackView()
        btnContainerView.isUserInteractionEnabled = false
        addImageBtn.addSubview(btnContainerView)
        NSLayoutConstraint.activate([
            addImageBtn.heightAnchor.constraint(equalToConstant: 60),
            addImageBtn.widthAnchor.constraint(equalToConstant: 60),
            btnContainerView.topAnchor.constraint(greaterThanOrEqualTo: addImageBtn.topAnchor),
            btnContainerView.bottomAnchor.constraint(lessThanOrEqualTo: addImageBtn.bottomAnchor),
            btnContainerView.leadingAnchor.constraint(equalTo: addImageBtn.leadingAnchor),
            btnContainerView.trailingAnchor.constraint(equalTo: addImageBtn.trailingAnchor),
            btnContainerView.centerYAnchor.constraint(equalTo: addImageBtn.centerYAnchor),
        ])
        btnContainerView.axis = .vertical
        btnContainerView.spacing = 1
        btnContainerView.translatesAutoresizingMaskIntoConstraints = false
        btnContainerView.alignment = .center
        btnContainerView.addArrangedSubview(btnImage)
        btnContainerView.addArrangedSubview(countImageLabel)
        
        
        addImageBtn.layer.borderColor = UIColor.gray.cgColor
        addImageBtn.layer.borderWidth = 0.2
        addImageBtn.layer.cornerRadius = 8
        btnImage.tintColor = .gray
        btnImage.image = UIImage(systemName: "camera.fill")
        btnImage.contentMode = .scaleAspectFit
        
        countImageLabel.isUserInteractionEnabled = false
        countImageLabel.textAlignment = .center
        countImageLabel.numberOfLines = 1
        
        countImageLabel.font = UIFont.systemFont(ofSize: 16)
        countImageLabel.textColor = .gray
        
        imageContainerView.axis = .horizontal
        imageContainerView.spacing = 10
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        imageContainerView.addArrangedSubview(addImageBtn)
        imageContainerView.addArrangedSubview(selectedImageCollectionView)
        imageContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        
    }
    
    private func setSelectedImageCollectionView(){
        selectedImageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
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
        priceField.keyboardType = .numberPad
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
    
    private func bindSelectedImages(){
        selectedImageCollectionView.register(SelectedImageCollectionViewCell.self, forCellWithReuseIdentifier: "imageCell")
        selectedImages.bind(to: selectedImageCollectionView.rx.items(cellIdentifier: "imageCell", cellType: SelectedImageCollectionViewCell.self)) { index, image, cell in
            cell.setData(image: image, index: index)
            cell.didPressDelete.bind{ index in
                var original = self.selectedImages.value
                original.remove(at: index)
                self.selectedImages.accept(original)
            }.disposed(by: self.disposeBag)
            
        }.disposed(by: disposeBag)
        selectedImages.bind{value in
            self.imageCount = value.count
            self.countImageLabel.text = "\(self.imageCount)/\(self.maxImageNumber)"
        }.disposed(by: disposeBag)
    }
}


