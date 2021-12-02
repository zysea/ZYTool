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

    let arr = ["北京市","天津市"]
    let arr1 = [["北京市"],["天津市"]]
    var subs = [String]()
    let arr2 = ["朝阳区","海淀区"]
    let arr3 = ["红桥区","北辰区"]
    let picker = AreaPicker()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(picker)
        
        picker.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        picker.dataSource = self
        picker.delegate = self
//        picker.backgroundColor = .yellow
//        picker.delegate = self
      // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: AreaPickerDataSource {
    func numberOfSections(_ areaPicker: AreaPicker) -> Int {
        return 2
    }
    
    func numberOfRowsAtSection(_ areaPicker: AreaPicker, section: Int) -> Int {
        if section == 0 {
            return arr.count
        }
        return subs.count
    }
    
    func titleOfIndexPath(_ areaPicker: AreaPicker, indexPath: IndexPath) -> String {
        if indexPath.section == 0 {
            return arr[indexPath.row]
        }
        return subs[indexPath.row]
    }
    
}


extension ViewController: AreaPickerDelegate {
    func didSelected(_ areaPicker: AreaPicker, indexPath: IndexPath) {
        if indexPath.section == 0 {
            subs = arr1[indexPath.row]
            picker.reloadData()
        }
    }

}
