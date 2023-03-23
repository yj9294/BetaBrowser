//
//  SettingView.swift
//  BetaBrowser
//
//  Created by yangjian on 2023/2/15.
//

import UIKit

class SettingView: UIView {
    
    var didSelect:((SettingItem)->Void)? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    var width: Double {
        return Double(window?.frame.width ?? 0.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        self.backgroundColor = AppUtil.shared.darkModel ? UIColor(white: 1, alpha: 0.5) : UIColor(white: 0, alpha: 0.5)
        let button = UIButton()
        button.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        addSubview(button)
        button.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self)
        }
        
        let contentView = UIView()
        contentView.backgroundColor = AppUtil.shared.darkModel ? .black : .white
        contentView.cornerRadius = 16
        self.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).offset(-16)
            make.bottom.equalTo(self).offset(-88)
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(SettingCell.classForCoder(), forCellWithReuseIdentifier: "SettingCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.layer.masksToBounds = false
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(24)
            make.left.equalTo(contentView).offset(0)
            make.right.equalTo(contentView).offset(0)
            make.bottom.equalTo(contentView).offset(-24)
            make.height.equalTo(228)
        }
    }
    
    @objc func dismiss() {
        self.removeFromSuperview()
    }

}

extension SettingView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SettingCell", for: indexPath)
        if let cell = cell as? SettingCell {
            let item = SettingItem.allCases[indexPath.row]
            cell.item = item
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SettingItem.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (width - 16*2 ) / 2.0 - 10
        return CGSize(width: width, height: 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = SettingItem.allCases[indexPath.row]
        didSelect?(item)
        self.removeFromSuperview()
    }
}

class SettingCell: UICollectionViewCell {
    
    private lazy var icon: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(named: "#333333")
        return label
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
        
        self.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(20)
            make.width.height.equalTo(32)
        }
        
        self.addSubview(title)
        title.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(14)
            make.centerY.equalTo(self)
        }
    }
    
    var item: SettingItem? = nil {
        didSet {
            if let image = item?.icon {
                icon.image = UIImage(named: AppUtil.shared.darkModel ? "\(image)_dark" : image)
            }
            title.text = item?.rawValue.localized()
            title.textColor = AppUtil.shared.darkModel ? .white : UIColor(named: "#333333")
        }
    }
}

enum SettingItem: String, CaseIterable {
    
    case new, share, copy, terms, rate, privacy, language, dark
    
    var icon: String {
        return "setting_\(self)"
    }
    
}
