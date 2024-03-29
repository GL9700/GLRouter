//
//  ViewController.swift
//  SwiftDemo
//
//  Created by liguoliang on 2021/3/1.
//

import UIKit
import GLRouter

class ViewController: UIViewController{
    
    let datas = [
        [
            ["title":"普通跳转","method":"pushNormal"],
            ["title":"普通跳转带参方式1","method":"pushParam1"],
            ["title":"普通跳转带参方式2","method":"pushParam2"],
            ["title":"从其他容器跳转","method":"pushFromOtherNav"],
            ["title":"条件跳转","method":"pushNeedTrue"]
        ],
        [
            ["title":"普通显示","method":"presentNormal"],
            ["title":"从其他容器跳转","method":"presentFromOtherContainer"],
            ["title":"条件跳转","method":"presentNeedTrue"]
        ],
        [
            ["title":"(Swift不支持)普通调用","method":""],
            ["title":"(Swift不支持)含有多参调用及空参调用","method":""],
            ["title":"(Swift不支持)获取返回值","method":""]
        ],
        [
            
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSStringFromClass(ViewController.self)
        self.mainTableView.frame = self.view.bounds
        GLRouterManager.failure { (error, str) in
            print("------")
            print("Error:\(String(describing: error)) | Output:\(String(describing: str))")
            print("------")
        }
    }
    
    lazy var mainTableView:UITableView = {
        let tv = UITableView(frame:self.view.bounds, style: .grouped)
        tv.delegate = self
        tv.dataSource = self
        self.view.addSubview(tv)
        return tv
    }()
}

/// PUSH
extension ViewController {
    
    @objc func pushNormal() {
        rto_dsp("GL://push/PageAViewController", nil)
    }
    
    @objc func pushParam1() {
        rto_dsp("GL://push/PageAViewController?msg=hello world!!", nil)
    }
    
    @objc func pushParam2() {
        rto_dsp("GL://push/PageAViewController", { (target) -> Bool in
            (target as! UIViewController).setValue("Hi World", forKey: "msg")   // KVC
            return true     // >> This line Detail in pushNeedTrue()
        })
    }
    
//    rto_dsp_clv("URL", 拦截器, 使用某个ViewController的Nav作为Container)
    @objc func pushFromOtherNav() {
        rto_dsp_clv("GL://push/PageAViewController", nil, nil)  // nil: current Container
    }
    
    @objc func pushNeedTrue() {
        rto_dsp("GL://push/PageAViewController") { (targetViewController) -> Bool in
            false    // `false`: cancel current Router Task  | `true` : normal to Launch
        }
    }
}

/// PRESENT
extension ViewController {
    @objc func presentNormal() {
        rto_dsp("GL://present/PageAViewController", nil)
    }
    @objc func presentFromOtherContainer() {
        rto_dsp("GL://present/PageAViewController?msg=hello world!!", nil)
    }
    @objc func presentNeedTrue() {
        rto_dsp("GL://present/PageAViewController") { (targetViewController) -> Bool in
            false    // `false`: cancel current Router Task  | `true` : normal to Launch
        }
    }
}

/// INVOKE
/*
extension ViewController {
    @objc func invokeMethod_NoParams() {
        rto_ivk("GL://invoke/Tools/sendMessage", nil)
    }

    @objc func invokeMethod_hasParams() {
    /* normal */
    //    rto_ivk("GL://invoke/Tools/sendMessage:from:to:?p1=Hello World!&p2=jerry&p3=tom", nil)
        
    /* the second params is <nil> */
        rto_ivk("GL://invoke/Tools/sendMessage?p1=Hello World!&p3=tom", nil)
    }

    @objc func invokeMethod_hasReturn() {
        rto_ivk("GL://invoke/Tools/sum?p1=12&p2=6", { (ret) in
            let sum:Int = (ret as! Int)
            print("结果是->\(sum)")
        })
    }

}
*/

/// UI & TableViewCell Selected Delegate
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell==nil { cell = UITableViewCell(style: .subtitle , reuseIdentifier: "cell") }
        cell?.textLabel?.text = self.datas[indexPath.section][indexPath.row]["title"]
        if let selname = self.datas[indexPath.section][indexPath.row]["method"], selname.count>0 {
            cell?.textLabel?.textColor = .black
            cell?.detailTextLabel?.text = "@selector(\(selname))"
        }else{
            cell?.textLabel?.textColor = .gray
            cell?.detailTextLabel?.text = "--"
        }
        
        cell?.detailTextLabel?.textColor = .lightGray
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sel:Selector = NSSelectorFromString(self.datas[indexPath.section][indexPath.row]["method"]!)
        if let selname = self.datas[indexPath.section][indexPath.row]["method"], selname.count>0 {
            self.perform(sel)
        }else{
            let ac = UIAlertController(title:nil , message: "Swift暂不支持此项", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "好的", style: .default, handler: nil))
            self.present(ac, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Push(跳转)"
        case 1:
            return "Present(弹出)"
        case 2:
            return "Invoke(动态调用)"
        default:
            return "Other(其他)"
        }
    }
}
