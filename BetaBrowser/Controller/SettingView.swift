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
        
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        let button = UIButton()
        button.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        addSubview(button)
        button.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self)
        }
        
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.cornerRadius = 16
        self.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).offset(-16)
            make.bottom.equalTo(self).offset(-88)
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = UIColor.white
        collectionView.register(SettingCell.classForCoder(), forCellWithReuseIdentifier: "SettingCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.layer.masksToBounds = false
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(40)
            make.left.equalTo(contentView).offset(36)
            make.right.equalTo(contentView).offset(-36)
            make.bottom.equalTo(contentView).offset(-40)
            make.height.equalTo(0)
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
        let width = (width - 16*2 - 36 * 2 - 60*2) / 3.0 - 5 + 23
        collectionView.snp.updateConstraints { make in
            make.height.equalTo(width * 2 + 28)
        }
        return SettingItem.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 28
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 60
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (width - 16*2 - 36 * 2 - 60*2) / 3.0 - 5
        return CGSize(width: width, height: width + 23)
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
        
        self.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }
        
        self.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).offset(8)
            make.centerX.equalTo(self)
        }
    }
    
    var item: SettingItem? = nil {
        didSet {
            if let image = item?.icon {
                icon.image = UIImage(named:image)
            }
            title.text = item?.title
        }
    }
}

enum SettingItem: String, CaseIterable {
    
    case new, share, copy, terms, contact, privacy
    
    var title: String {
        switch self {
        case .terms:
            return "Terms of Use"
        case .privacy:
            return "Privacy Policy"
        case .contact:
            return "Contact us"
        default:
            return self.rawValue.capitalized
        }
    }
    
    var icon: String {
        return "setting_\(self)"
    }
    
}
