//
//  ViewController.swift
//  BottomMenuView
//
//  Created by 1 on 2018/10/10.
//  Copyright © 2018年 sxm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func click1(_ sender: Any) {
        let action1 = BottomMenuAction(title: "确定", style: .default) {
            print("点击了确定")
        }
        let action2 = BottomMenuAction(title: "确定2", style: .cancel) {
            print("点击了确定2")
        }
//        BottomMenuView.show(title: "空测试", actions: [action1, action2]) {
//            self.test()
//            print("取消了取消了")
//        }
        
        BottomMenuView.show(title: "空测试", actions: [action1, action2])
    }
    
    @IBAction func click2(_ sender: Any) {
        let action1 = BottomMenuAction(title: "确定", style: .default) {
            print("点击了确定")
        }
        let action2 = BottomMenuAction(title: "确定1", style: .cancel) {
            print("点击了确定1")
        }
        BottomMenuView.show(title: "测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试", actions: [action1,action2,action2,action2,action2], cancelHandler: nil)
    }
    
    @IBAction func click3(_ sender: Any) {
        let action1 = BottomMenuAction(title: "确定", style: .default) {
            print("点击了确定")
        }
        let action2 = BottomMenuAction(title: "确定2", style: .cancel) {
            print("点击了确定2")
        }
        BottomMenuView.show(title: nil, actions: [action1,action2], cancelHandler: nil)
        
    }
    @IBAction func click4(_ sender: Any) {
        let action1 = BottomMenuAction(title: "确定", style: .destructive) {
            print("点击了确定")
        }
        let action2 = BottomMenuAction(title: "确定1", style: .cancel) {
            print("点击了确定1")
        }
        BottomMenuView.show(title: nil, actions: [action1,action2,action2,action2,action2], cancelHandler: nil)
    }
    
    func test() {
        print("test")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

