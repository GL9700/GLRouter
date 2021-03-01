//
//  PageBViewController.swift
//  SwiftDemo
//
//  Created by liguoliang on 2021/3/1.
//

import UIKit

class PageBViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSStringFromClass(PageBViewController.self)
        self.view.backgroundColor = .white
        self.label.center = self.view.center
    }
    
    lazy var label:UILabel = {
        let lab = UILabel()
        lab.text = self.title
        lab.textColor = .black
        lab.sizeToFit()
        self.view.addSubview(lab)
        return lab
    }()
}
