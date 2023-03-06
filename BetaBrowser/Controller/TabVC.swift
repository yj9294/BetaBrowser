//
//  Tab.swift
//  BetaBrowser
//
//  Created by yangjian on 2023/2/15.
//

import UIKit

class TabVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FirebaseUtil.log(event: .tabShow)
    }
}

extension TabVC {
    
    override func setupUI() {
        super.setupUI()
        
        let bottomView = UIView()
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.bottom.equalTo(view.snp.bottomMargin)
            make.height.equalTo(65)
        }

        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.contentInset = UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16)
        collection.register(TabCell.classForCoder(), forCellWithReuseIdentifier: "TabCell")
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.clear
        collection.backgroundView?.backgroundColor = UIColor.clear
        view.addSubview(collection)
        collection.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.top.equalTo(view.snp.topMargin)
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        let addButton = UIButton()
        addButton.setImage(UIImage(named: "tab_add"), for: .normal)
        addButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        bottomView.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.center.equalTo(bottomView)
        }
        
        let backButton = UIButton()
        bottomView.addSubview(backButton)
        backButton.setTitle("back".localized(), for: .normal)
        backButton.setTitleColor(AppUtil.shared.darkModel ? .white : .black, for: .normal)
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(bottomView)
            make.right.equalTo(bottomView).offset(-16)
        }
        
    }
    
}

extension TabVC {
    
    @objc func addAction() {
        backAction()
        BrowserUtil.shared.add()
        FirebaseUtil.log(event: .tabNew, params: ["lig": "tab"])
    }
    
    @objc func selectAction(_ item: BrowserItem) {
        backAction()
        BrowserUtil.shared.select(item)
    }
    
}

extension TabVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return BrowserUtil.shared.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCell", for: indexPath)
        if let cell = cell as? TabCell {
            let item = BrowserUtil.shared.items[indexPath.row]
            cell.item = item
            cell.closeHandle = {
                BrowserUtil.shared.removeItem(item)
                collectionView.reloadData()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (width - 32 - 12) / 2.0 - 5
        let height = 204
        return CGSize(width: Double(width), height: Double(height))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = BrowserUtil.shared.items[indexPath.row]
        selectAction(item)
    }
    
}


class TabCell: UICollectionViewCell {
    
    var closeHandle:(()->Void)? = nil
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "#333333")
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "tab_close"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return closeButton
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        self.backgroundColor = .clear
        self.backgroundView?.backgroundColor = .clear
        
        let icon = UIImageView(image: UIImage(named: "launch_icon"))
        self.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
        
        self.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(self).offset(8)
            make.left.equalTo(self).offset(8)
            make.right.equalTo(self).offset(-20)
        }
        

        self.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.right.equalTo(self)
        }
    }
    
    @objc func closeAction() {
        closeHandle?()
    }
    
    var item: BrowserItem? = nil {
        didSet{
            self.title.text = item?.webView.url?.absoluteString
            if BrowserUtil.shared.items.count == 1 {
                closeButton.isHidden = true
            } else {
                closeButton.isHidden = false
            }
            
            if item?.isSelect == true {
                self.layer.borderColor = UIColor(named: "#6EEBC3")?.cgColor
            } else {
                self.layer.borderColor = UIColor.gray.cgColor
            }
            self.layer.borderWidth = 1
            self.layer.masksToBounds = true
            self.cornerRadius = 8
        }
    }
    
}
