//
//  AreaTitleView.swift
//  Pods-ZYTool_Example
//
//  Created by Iann on 2021/12/1.
//

import Foundation
import SnapKit

class AreaTitleView: UIView {
    
    private var didSelected:((_ row:Int,_ title:String?) -> Void)?
    
    convenience init() {
        self.init(frame: .zero)
        setup()
    }
    
    var max:Int = 0
    
    var selectedIndex:Int = 0 {
        didSet {
            collectionView.reloadData()
            if selectedIndex != oldValue {
                var title:String? = nil
                if selectedIndex < titles.count && selectedIndex > 0 {
                    title = titles[selectedIndex]
                }
                didSelected?(selectedIndex, title)
            }
        }
    }
    
    var currentNumber:Int = 0
    
    var titles:[String] = [String]() {
        didSet {
            debugPrint(titles)
            collectionView.reloadData()
        }
    }
    private var placehoders = ["省份/地区","城市","区/县","街道/镇"]
    
    func setDidSelected(_ block:@escaping ((_ row:Int,_ title:String?) -> Void)) {
        didSelected = block
    }
    
    private func setup() {
        addSubview(collectionView)
        currentNumber = 1
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 40)
//        layout.estimatedItemSize = CGSize(width: 100, height:40)
        layout.minimumInteritemSpacing = AreaConfig.share.titleSpace
        layout.minimumLineSpacing = AreaConfig.share.titleSpace
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        view.register(AreaTitleCell.self, forCellWithReuseIdentifier: "AreaTitleCell")
        view.register(AreaTitlePlacehoderCell.self, forCellWithReuseIdentifier: "AreaTitlePlacehoderCell")
        return view
    }()
}

extension AreaTitleView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < titles.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AreaTitleCell", for: indexPath)
            if let cell = cell as? AreaTitleCell {
                let text = titles[indexPath.row]
                debugPrint("title",text)
                cell.titleLabel.text = titles[indexPath.row]
                if selectedIndex == indexPath.row {
                    cell.titleLabel.textColor = AreaConfig.share.titleSelectedColor
                    cell.titleLabel.font = AreaConfig.share.titleSelectedFont
                } else {
                    cell.titleLabel.textColor = AreaConfig.share.titleNormalColor
                    cell.titleLabel.font = AreaConfig.share.titleNormalFont
                }
            }
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AreaTitlePlacehoderCell", for: indexPath)
        if let cell = cell as? AreaTitlePlacehoderCell {
            let text = placehoders[indexPath.row]
            debugPrint("title",text)
            cell.titleLabel.text = text
        }
        return cell
    }
    
}

extension AreaTitleView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var title = placehoders[indexPath.row]
        debugPrint("title",title)
        if indexPath.row < titles.count {
            title = titles[indexPath.row]
        }
        let font = selectedIndex == indexPath.row ? AreaConfig.share.titleSelectedFont : AreaConfig.share.titleNormalFont
        let label = UILabel()
        label.font = font
        label.text = title
        label.sizeToFit()
        return label.bounds.size
    }
}
