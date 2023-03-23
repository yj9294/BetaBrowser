//
//  CountryListVC.swift
//  BetaBrowser
//
//  Created by yangjian on 2023/3/14.
//

import UIKit

class CountryListVC: BaseVC {
    
    var completion: ((Language)->Void)? = nil
    
    var datasource: [Language] = []
    
    var language: Language? = nil
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(CountryListCell.classForCoder(), forCellReuseIdentifier: "CountryListCell")
        tableView.delegate = self
        tableView.backgroundColor = UIColor(named: "#394468")
        tableView.cornerRadius = 12
        tableView.dataSource = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension CountryListVC {
    
    override func setupUI() {
        super.setupUI()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.snp_topMargin).offset(20)
            make.left.equalTo(view).offset(16)
            make.right.equalTo(view).offset(-16)
            make.bottom.equalTo(view.snp_bottomMargin).offset(-20)
        }
    }
    
}

extension CountryListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryListCell", for: indexPath)
        if let cell = cell as? CountryListCell {
            cell.isSelect = datasource[indexPath.row].code == self.language?.code
            cell.text = datasource[indexPath.row].language
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  52.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let select = datasource[indexPath.row]
        completion?(select)
        self.navigationController?.popViewController(animated: true)
    }
    
}

class CountryListCell: UITableViewCell {
    
    
    let title: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let icon: UIImageView = {
        let view = UIImageView(image: UIImage(named: "translate_select"))
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.backgroundView?.backgroundColor = .clear
        
        addSubview(title)
        title.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(33)
        }
        
        addSubview(icon)
        icon.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-32)
        }
    }
    
    var isSelect: Bool = false {
        didSet {
            icon.image = UIImage(named: isSelect ? "translate_selected": "translate_select")
        }
    }
    
    var text: String? = nil {
        didSet {
            title.text = text
        }
    }
    
}
