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
            collectionView.reloadData()
        }
    }
    private var placehoders = ["省份/地区","城市","区/县","街道/镇"]
    
    func setDidSelected(_ block:@escaping ((_ row:Int,_ title:String?) -> Void)) {
        didSelected = block
    }
    
    private func setup() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        currentNumber = 1
    }
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 100, height:40)
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
            cell.titleLabel.text = placehoders[indexPath.row]
        }
        return cell
    }
    
}

extension AreaTitleView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
    }
}
