//
//  AreaPicker.swift
//  ZYTool
//
//  Created by Iann on 2021/12/1.
//

import Foundation
import SnapKit
import UIKit

public enum AreaPickerSource:Int {
    case province
    case city
    case county
    case town
}

public struct AreaItem {
    let source:AreaPickerDataSource
    let index:Int
}

public protocol AreaPickerDataSource {
    func numberOfSections(_ areaPicker:AreaPicker) -> Int
    func numberOfRowsAtSection(_ areaPicker:AreaPicker,section:Int) -> Int
    func titleOfIndexPath(_ areaPicker:AreaPicker,indexPath:IndexPath) -> String
}

public protocol AreaPickerDelegate {
    func didSelected(_ areaPicker:AreaPicker,indexPath:IndexPath)
}

public class AreaPicker: UIView {
    
    private var views = [String:AreaContentView]()
    private var titles:[String] = [String]() {
        didSet {
            titleView.titles = titles
        }
    }
    
    private var selectedIndexs = [String:Int]()
    
    private var _count:Int = 0 {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public var count:Int {
        return _count
    }
    
    private var numbers:Int = 1
    
    convenience init() {
        self.init(frame: .zero)
        setup()
    }
    
    public func reloadData() {
        _count = dataSource?.numberOfSections(self) ?? 0
        titleView.max = _count
    }
    
    func setup() {
        addSubview(titleView)
        titleView.setDidSelected { [weak self] (row, title) in
            guard let self = self else {return}
            self.collectionView.scrollToItem(at: IndexPath(row: row, section: 0), at: .centeredHorizontally, animated: true)
        }
       addSubview(collectionView)
    }
    
    
    func insert(_ title:String,at index:Int) {
        titles.insert(title, at: index)
        let count = titles.count + 1
        numbers = count < _count ? count : _count
        collectionView.reloadData()
        titleView.currentNumber = numbers
        titleView.selectedIndex = titles.count < (_count - 1) ? titles.count : (_count - 1)
    }
    
    func replace(_ title:String,at index:Int) {
        if title.isEmpty {
            return
        }
        debugPrint("title",title)
        if index < titles.count {
            if titles[index] == title {
                titles.remove(at: index)
                insert(title, at: index)
                return
            }
            titles.removeLast()
        }
        if index >= titles.count {
            insert(title, at: index)
        } else {
            replace(title, at: index)
        }
    }
    
//    func setBlock(_ target:AreaContentView,section:Int) {
//        target.page = section
//
//        target.setNumberOfRows {[weak self]  page in
//            debugPrint("setNumberOfRows",page)
//            guard let self = self,let dataSourse = self.dataSource else { return 0}
//            let count = dataSourse.numberOfRowsAtSection(self, section: page)
//            return count
//        }
//
//        target.setTitleOfRow { [weak self] (page,row) in
//            guard let self = self,let dataSourse = self.dataSource else { return ""}
//            debugPrint("setTitleOfRow",page)
//            return dataSourse.titleOfIndexPath(self, indexPath: IndexPath(item: row, section: page))
//        }
//
//        target.setDidSelected {[weak self] (page,row,title) in
//            guard let self = self else { return}
//            let newIndexPath = IndexPath(item: row, section: page)
//            self.replace(title, at: section)
//
//            if let delegate = self.delegate  {
//                delegate.didSelected(self, indexPath: newIndexPath)
//            }
//        }
//        target.tableView.reloadData()
//    }
    
    lazy var titleView: AreaTitleView = {
        $0.backgroundColor = .white
        return $0
    }(AreaTitleView())
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        titleView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 40)
        collectionView.frame = CGRect(x: 0, y: 40, width: bounds.width, height: bounds.height - 40)
    }
    
    public var dataSource:AreaPickerDataSource? {
        didSet {
            reloadData()
        }
    }
    
    public var delegate:AreaPickerDelegate?
    
    public var selectedIndex:Int  = 0
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 200)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        view.register(AreaContentCell.self, forCellWithReuseIdentifier: "AreaContentCell")
        view.isPagingEnabled = true
        return view
    }()
    
    lazy var scrollView: UIScrollView = {
        $0.isPagingEnabled = true
        $0.delegate = self
        return $0
    }(UIScrollView())
}

extension AreaPicker: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AreaContentCell", for: indexPath)
        if let cell = cell as? AreaContentCell {
            cell.index = indexPath.row
            cell.selectedIndex = selectedIndexs["\(indexPath.row)"] ?? -1
            cell.setNumberOfRows { [weak self] section in
                guard let self = self,let dataSourse = self.dataSource else { return 0}
                let count = dataSourse.numberOfRowsAtSection(self, section: section)
                return count
            }
            
            cell.setTitleOfRow { [weak self] (section,row) in
                guard let self = self,let dataSourse = self.dataSource else { return ""}
                return dataSourse.titleOfIndexPath(self, indexPath: IndexPath(item: row, section: section))
            }
            
            cell.setDidSelected {[weak self] (section,row,title) in
                guard let self = self else { return}
                let newIndexPath = IndexPath(item: row, section: section)
                self.replace(title, at: section)
                if self.titles.count < self.selectedIndexs.count {
                    for i in self.titles.count..<self.selectedIndexs.count {
                        self.selectedIndexs["\(i)"] = -1
                    }
                }
                self.selectedIndexs["\(section)"] = row
                if let delegate = self.delegate  {
                    delegate.didSelected(self, indexPath: newIndexPath)
                }
                collectionView.reloadData()
            }
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? AreaContentCell {
            cell.tableView.reloadData()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        debugPrint(indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.width
        let offSet = scrollView.contentOffset.x
        let index = Int(offSet / width)
        titleView.selectedIndex = index
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = bounds.size
        return CGSize(width: size.width, height: size.height - 40)
    }
}
