//
//  RootViewController.swift
//  WaffleMarket
//
//  Created by 안재우 on 2021/11/25.
//

import UIKit

class HomeRootViewController: UIViewController {
    var helloWorldLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        helloWorldLabel = UILabel()
        helloWorldLabel.text = "Home!"
        helloWorldLabel.textAlignment = .center
        self.view.addSubview(helloWorldLabel)
        setHelloWorldLabel()
    }
    
    private func setHelloWorldLabel(){
        helloWorldLabel.translatesAutoresizingMaskIntoConstraints = false
        helloWorldLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        helloWorldLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        helloWorldLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        helloWorldLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        helloWorldLabel.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
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
