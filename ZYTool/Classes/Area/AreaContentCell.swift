//
//  AreaContentCell.swift
//  Pods-ZYTool_Example
//
//  Created by Iann on 2021/12/1.
//

import Foundation
import SnapKit

class AreaContentCell: UICollectionViewCell,UITableViewDataSource,UITableViewDelegate {
    
    private var numberOfRows:((_ section:Int) -> Int)?
    
    private var titleOfRow:((_ section:Int,_ row:Int) -> String)?
    
    private var didSelected:((_ section:Int,_ row:Int,_ title:String) -> Void)?
    
    var selectedIndex:Int = -1
    var index:Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    func setNumberOfRows(_ block:((_ section:Int) -> Int)?) {
        numberOfRows = block
    }
    
    func setTitleOfRow(_ block:((_ section:Int,_ row:Int) -> String)?) {
        titleOfRow = block
    }
    
    func setDidSelected(_ block:((_ section:Int,_ row:Int,_ title:String) -> Void)?) {
        didSelected = block
    }
    
    private func setupViews() {
        contentView.addSubview(tableView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRows = numberOfRows else {
            return 0
        }
        let count = numberOfRows(index)
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AreaContentTableCell")
        if let cell = cell as? AreaContentTableCell {
            //            debugPrint(indexPath)
            cell.titleLabel.text = titleOfRow?(index,indexPath.row)
            let isHidden = !(selectedIndex == indexPath.row)
            cell.accessView.isHidden = isHidden
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? AreaContentTableCell
        let title =  cell?.titleLabel.text ?? ""
        didSelected?(index,indexPath.row,title)
        selectedIndex = indexPath.row
        tableView.reloadData()
    }
    
    lazy var tableView: UITableView = {
        $0.separatorStyle = .none
        $0.tableFooterView = UIView()
        $0.backgroundColor = .clear
        $0.delegate = self
        $0.dataSource = self
        $0.rowHeight = 50
        $0.register(AreaContentTableCell.self, forCellReuseIdentifier: "AreaContentTableCell")
        return $0
    }(UITableView())
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

class AreaContentTableCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        selectionStyle = .none
    }
    
    func setupViews() {
        contentView.addSubview(accessView)
        contentView.addSubview(titleLabel)
    }
    
    lazy var titleLabel: UILabel = {
        $0.font = AreaConfig.share.contentNormalFont
        $0.textColor = AreaConfig.share.contentNormalColor
        return $0
    }(UILabel())
    
    lazy var accessView: UILabel = {
        $0.textColor = AreaConfig.share.tintColor
        $0.text = "✓"
        return $0
    }(UILabel())
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 5, y: 0, width: bounds.width - 40, height: bounds.height)
        accessView.frame = CGRect(x: bounds.width - 35, y: (bounds.height - 30)/2, width: 30, height: 30)
    }
}
