//
//  PageAViewController.swift
//  SwiftDemo
//
//  Created by liguoliang on 2021/3/1.
//

import UIKit

class PageAViewController: UIViewController {

    @objc var msg:String?
    
    // if Need Param in Router !!
    // <GLRouterProtocol> routerParams()
    override func routerParams(_ params: [AnyHashable : Any]!) {
        if let m = params["msg"]  {
            msg = m as? String
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSStringFromClass(PageAViewController.self)
        self.view.backgroundColor = .white
        label.center = self.view.center
        if let m = msg {
            label.text = m;
        }
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
