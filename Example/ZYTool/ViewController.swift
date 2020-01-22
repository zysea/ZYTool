//
//  ViewController.swift
//  ZYTool
//
//  Created by zysea on 01/21/2020.
//  Copyright (c) 2020 zysea. All rights reserved.
//

import UIKit
import ZYTool

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var str = "aaaa"
        str = str.append(path: "")
        print(str)
        str = str.md5
        print(str)
        str = "12340123321"
        print(str)
        if str.isPhone {
            print("is phone")
        }
        str = "zhan@sina.cn"
        print(str)
        if str.isEmail {
            print("is email")
        }
        str = "{\"a\":\"b\"}"
        print(str.jsonObject() ?? "json is nil")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

