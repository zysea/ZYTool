//
//  AreaTitleCell.swift
//  Pods-ZYTool_Example
//
//  Created by Iann on 2021/12/1.
//

import Foundation
import SnapKit

class AreaTitleCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    func setupViews() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
    }
    
    
    lazy var titleLabel: UILabel = {
        $0.font = AreaConfig.share.contentNormalFont
        $0.textColor = AreaConfig.share.titleNormalColor
        return $0
    }(UILabel())
}

class AreaTitlePlacehoderCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    func setupViews() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
    }
    
    lazy var titleLabel: UILabel = {
        $0.font = AreaConfig.share.contentNormalFont
        $0.textColor = AreaConfig.share.titlePlacehoderColor
        return $0
    }(UILabel())
}
