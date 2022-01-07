//
//  CheckBox.swift
//  WaffleMarket
//
//  Created by 안재우 on 2022/01/07.
//

import Foundation
import UIKit
import RxRelay
import RxSwift
class CheckBoxView: UIView {
    var didChange = BehaviorRelay<Bool>(value: false)
    var didTap = PublishSubject<Void>()
    var changeOnTap = false
    var isChecked = false
    let checkView = UIImageView()
    let checkLabel = UILabel()
    let disposeBag = DisposeBag()
    var uncheckedImage = UIImage(systemName: "checkmark.circle")
    var checkedImage = UIImage(systemName: "checkmark.circle.fill")
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    private func initialize(){
        self.addSubview(checkView)
        self.addSubview(checkLabel)
        checkView.translatesAutoresizingMaskIntoConstraints = false
        checkView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        checkView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        checkView.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
        checkView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
        checkLabel.translatesAutoresizingMaskIntoConstraints = false
        checkLabel.leadingAnchor.constraint(lessThanOrEqualTo: checkView.trailingAnchor, constant: 5).isActive = true
        checkLabel.leadingAnchor.constraint(greaterThanOrEqualTo: checkView.trailingAnchor).isActive = true
        checkLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        checkLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        checkLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.checkBoxClicked(_:))))
        
        checkView.image = uncheckedImage
        checkView.tintColor = .orange
        didChange.bind{ value in
            if value {
                self.checkView.image = self.checkedImage
            } else {
                self.checkView.image = self.uncheckedImage
            }
        }.disposed(by: disposeBag)
    }
    func setText(_ value: String){
        checkLabel.text = value
    }
    func setChecked(_ value: Bool){
        isChecked = value
        didChange.accept(isChecked)
    }
    func abortChange(){
        isChecked = !isChecked
    }
    @objc func checkBoxClicked(_ sender: Any) {
        if changeOnTap {
            isChecked = !isChecked
            didChange.accept(isChecked)
        }
        didTap.onNext(())
    }
    
}
