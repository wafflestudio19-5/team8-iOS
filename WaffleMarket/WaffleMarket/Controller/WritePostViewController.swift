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
    let progressView: UIProgressView = {
        let view = UIProgressView()
        view.trackTintColor = .white
        view.progressTintColor = .orange
        view.progress = 0
        return view
    }()
    let scrollView = UIScrollView()
    let scrollContentView = UIView()
    let stackView = UIStackView()
    let imageContainerView = UIStackView()
    let priceContainerView = UIView()
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
    
    let categoryBtn = UIButton(type:.system)
    var selectedCategory: String?
    let priceField = UITextField()
    let contentField = UITextView()
    
    let selectedImages = BehaviorRelay<[UIImage]>(value: [])
    let maxImageNumber = 10
    var imageCount = 0
    
    
    let completeBtn = UIBarButtonItem()
    var originalViewHeight: CGFloat = 0
    let disposeBag = DisposeBag()
    @objc func keyboardWillShow(notification: NSNotification) {
        print("kwillshow")
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }
        
      
      // move the root view up by the distance of keyboard height
        self.view.frame.size.height = originalViewHeight - ((self.view.frame.origin.y + originalViewHeight) - keyboardSize.origin.y)
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: (self.view.frame.origin.y + self.view.frame.size.height) - keyboardSize.origin.y, right: 0)
        print(self.view.frame.size.height)
        
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        print("kwillhide")
      
      // move the root view up by the distance of keyboard height
        
        self.view.frame.size.height = originalViewHeight
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        print(self.view.frame.size.height)
    }
    private func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    private func removeObserver(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
        self.view.backgroundColor = .white
        originalViewHeight = self.view.frame.size.height
        
        self.view.addSubview(progressView)
        setProgressView()
        self.view.addSubview(scrollView)
        
        setScrollView()
        
        stackView.addArrangedSubview(imageContainerView)
        divider()
        stackView.addArrangedSubview(titleField)
        divider()
        stackView.addArrangedSubview(categoryBtn)
        divider()
        stackView.addArrangedSubview(priceContainerView)
        divider()
        stackView.addArrangedSubview(contentField)
        
        setImageContainerView()
        setSelectedImageCollectionView()
        setTitleField()
        setCategoryBtn()
        setPriceContainerView()
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
    private func setProgressView(){
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        progressView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
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
        
        categoryBtn.rx.tap.bind{
            let vc = CategoryPickerModalViewController()
            weak var didSelect = vc.didSelect
            didSelect?.bind(onNext: { value in
                self.selectedCategory = value
                self.categoryBtn.setTitle(value, for: .normal)
            }).disposed(by: self.disposeBag)
            self.present(vc, animated: true)
        }.disposed(by: disposeBag)
        
        
    }
    
    private func setPriceContainerView(){
        let currencyField = UITextField()
        
        priceContainerView.translatesAutoresizingMaskIntoConstraints = false
        priceContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        priceContainerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        priceContainerView.addSubview(currencyField)
        priceContainerView.addSubview(priceField)
        
        
        currencyField.translatesAutoresizingMaskIntoConstraints = false
        currencyField.widthAnchor.constraint(equalToConstant: 15).isActive = true
        currencyField.topAnchor.constraint(equalTo: priceContainerView.topAnchor).isActive = true
        currencyField.bottomAnchor.constraint(equalTo: priceContainerView.bottomAnchor).isActive = true
        currencyField.leadingAnchor.constraint(equalTo: priceContainerView.leadingAnchor).isActive = true
        currencyField.placeholder = "₩"
        priceField.translatesAutoresizingMaskIntoConstraints = false
        priceField.topAnchor.constraint(equalTo:priceContainerView.topAnchor).isActive = true
        priceField.bottomAnchor.constraint(equalTo: priceContainerView.bottomAnchor).isActive = true
        priceField.leadingAnchor.constraint(equalTo: currencyField.trailingAnchor, constant: 5).isActive = true
        priceField.trailingAnchor.constraint(equalTo: priceContainerView.trailingAnchor).isActive = true
        priceField.placeholder = "가격 (선택사항)"
        priceField.font = UIFont.systemFont(ofSize: textSize)
        priceField.keyboardType = .numberPad
        
        priceField.rx.text.orEmpty.bind { _ in
            currencyField.textColor = .black
            self.priceField.textColor = .black
            self.priceField.text = self.priceField.text?.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789").inverted)
            
            let value = self.priceField.text ?? ""
            if value.isEmpty {
                currencyField.text = ""
                currencyField.placeholder = "₩"
            } else {
                currencyField.placeholder = ""
                currencyField.text = "₩"
                let number = Double(value) ?? 0
                if number == 0{
                    self.priceField.text = "0"
                    currencyField.textColor = .orange
                    self.priceField.textColor = .orange
                } else if value.starts(with: "0") && value.count >= 2{
                    self.priceField.text = String(value.dropFirst())
                }
            }
            
            
        }.disposed(by: disposeBag)
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
        contentField.textColor = .lightGray
        contentField.text = "내용을 입력해주세요"
        contentField.rx.didBeginEditing.bind{
            if self.contentField.textColor == .lightGray {
                self.contentField.text = nil
                self.contentField.textColor = .black
            }
        }.disposed(by: disposeBag)
        contentField.rx.didEndEditing.bind{
            if self.contentField.text.isEmpty {
                self.contentField.text = "내용을 입력해주세요"
                self.contentField.textColor = .lightGray
            }
        }.disposed(by: disposeBag)
        //MARK: 충분히 개선 후 사용할 것
//        contentField.rx.didChangeSelection.bind{
//            print("changesel")
//            guard let selRange = self.contentField.selectedTextRange else { return }
//            let caret = self.contentField.caretRect(for: selRange.start)
//            print(self.scrollView.contentOffset.y)
//            var caretY = caret.origin.y
//            if caretY.isInfinite {
//                caretY = self.contentField.frame.origin.y + self.contentField.frame.size.height
//            } else {
//                caretY = self.contentField.frame.origin.y + caret.origin.y
//            }
//            self.scrollView.scrollRectToVisible(CGRect(x: 0, y: caretY, width: 10, height: 80), animated: true)
//        }.disposed(by: disposeBag)
        
    }
    
    private func setCompleteBtn(){
        completeBtn.title = "완료"
        completeBtn.rx.tap.bind{
            if self.imageCount == 0 {
                self.toast("제품 사진을 첨부하세요", y: 50)
                return
            }
            
            let title = self.titleField.text ?? ""
            let price = self.priceField.text ?? ""
            let content = self.contentField.text ?? ""
            let category = self.selectedCategory ?? ""
            
            if title.isEmpty {
                self.toast("제목을 입력하세요", y: 50)
                return
            }
            if category.isEmpty {
                self.toast("카테고리를 선택하세요", y: 50)
                return
            }
            if content.isEmpty || self.contentField.textColor == .lightGray {
                self.toast("내용을 입력하세요", y: 50)
                return
            }
            
            ArticleAPI.create(title: title, price: price, content: content, category: category, productImages: self.selectedImages.value).subscribe { progressResponse in
                self.progressView.progress = Float(progressResponse.progress)
                if progressResponse.completed {
                    print(String(decoding: progressResponse.response!.data, as: UTF8.self))
                    if progressResponse.response!.statusCode/100 == 2 {
                        self.navigationController?.popViewController(animated: true)
                    } else if progressResponse.response!.statusCode == 413 {
                        self.toast("이미지 용량이 너무 커요", y: 50)
                    } else {
                        self.toast("오류가 발생했어요", y: 50)
                    }
                    self.progressView.progress = 0
                }
            } onError: { error in
                self.progressView.progress = 0
                self.toast("오류가 발생했어요", y: 50)
            }.disposed(by: self.disposeBag)
            

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


class CategoryPickerModalViewController: UIViewController {
    deinit{
        print("deinit!")
    }
    var includeAll = false
    let categoryPicker = UIPickerView()
    let disposeBag = DisposeBag()
    let confirmBtn = UIButton(type: .system)
    let navigationBar = UINavigationBar()
    let didSelect = PublishRelay<String>()
    var items = CategoryConstants.categories
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        if includeAll {
            items = ["전체"] + items
        }
        
        Observable.just(items).bind(to: categoryPicker.rx.itemTitles) {
            _, item in
            return "\(item)"
        }.disposed(by: disposeBag)
        self.view.addSubview(navigationBar)
        self.view.addSubview(categoryPicker)
        self.view.addSubview(confirmBtn)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        navigationBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        navigationBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        navigationBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        confirmBtn.translatesAutoresizingMaskIntoConstraints = false
        confirmBtn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        confirmBtn.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        confirmBtn.widthAnchor.constraint(equalToConstant: 200).isActive = true
        confirmBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        categoryPicker.translatesAutoresizingMaskIntoConstraints = false
        categoryPicker.topAnchor.constraint(equalTo: self.navigationBar.bottomAnchor).isActive = true
        categoryPicker.bottomAnchor.constraint(equalTo: self.confirmBtn.topAnchor).isActive = true
        categoryPicker.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        categoryPicker.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        categoryPicker.frame = self.view.frame
        
        
        confirmBtn.backgroundColor = .orange
        confirmBtn.setTitleColor(.white, for: .normal)
        confirmBtn.layer.cornerRadius = 10
        confirmBtn.setTitle("완료", for: .normal)
        confirmBtn.rx.tap.bind{
            self.dismiss(animated: true)
        }.disposed(by: disposeBag)

        let navigationItem = UINavigationItem()
        navigationItem.title = "카테고리 선택"
        navigationBar.items = [navigationItem]
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        print(items[categoryPicker.selectedRow(inComponent: 0)])
        didSelect.accept(items[categoryPicker.selectedRow(inComponent: 0)])
    }
}
