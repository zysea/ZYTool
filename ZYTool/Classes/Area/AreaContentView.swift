//
//  AreaContentView.swift
//  ZYTool
//
//  Created by Iann on 2021/12/2.
//

import Foundation

class AreaContentView: UIView,UITableViewDataSource,UITableViewDelegate {
    
    private var numberOfRows:((_ section:Int) -> Int)?
    
    private var titleOfRow:((_ section:Int,_ row:Int) -> String)?
    
    private var didSelected:((_ section:Int,_ row:Int,_ title:String) -> Void)?
        
    var selectedIndex:Int = -1
    
    var page:Int = 0
    
    convenience init() {
        self.init(frame: .zero)
    }
    
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
        addSubview(tableView)
        tableView.frame = bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRows = numberOfRows else {
            return 0
        }
        let count = numberOfRows(page)
        debugPrint("areaTitleView",page,count)

        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AreaContentTableCell")
        if let cell = cell as? AreaContentTableCell {
            debugPrint("AreaContentTableCell cell",page,indexPath.row)
            cell.titleLabel.text = titleOfRow?(page, indexPath.row)
            let isHidden = !(selectedIndex == indexPath.row)
            cell.accessView.isHidden = isHidden
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        let cell = tableView.cellForRow(at: indexPath) as? AreaContentTableCell
        let title =  cell?.titleLabel.text ?? ""
        didSelected?(page,indexPath.row,title)
        tableView.reloadData()
    }
    
    lazy var tableView: UITableView = {
        $0.delegate = self
        $0.dataSource = self
        $0.register(AreaContentTableCell.self, forCellReuseIdentifier: "AreaContentTableCell")
        return $0
    }(UITableView())
}
