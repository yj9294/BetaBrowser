//
//  TextResultVC.swift
//  BetaBrowser
//
//  Created by yangjian on 2023/3/14.
//

import UIKit

class TextResultVC: BaseVC {
    
    var result: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Result"
    }
    
}

extension TextResultVC {
    
    override func setupUI() {
        super.setupUI()
        let contentView = UIScrollView()
        contentView.backgroundColor = UIColor(named: "#394468")
        contentView.showsHorizontalScrollIndicator = false
        contentView.showsVerticalScrollIndicator = false
        contentView.cornerRadius = 12
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(view.snp_topMargin).offset(20)
            make.left.equalTo(view).offset(16)
            make.right.equalTo(view).offset(-16)
            make.bottom.equalTo(view.snp_bottomMargin).offset(-20)
        }
        
        let sourceLabel = UILabel()
        sourceLabel.textColor = .white
        sourceLabel.font = UIFont.systemFont(ofSize: 16.0)
        sourceLabel.text = ProfileUtil.share.textSourceLanguage.language
        contentView.addSubview(sourceLabel)
        sourceLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(16)
            make.left.equalTo(contentView).offset(16)
        }
        
        let source = UILabel()
        source.textColor = .white
        source.numberOfLines = 0
        source.font = UIFont.systemFont(ofSize: 16)
        source.text = ProfileUtil.share.translateText
        contentView.addSubview(source)
        source.snp.makeConstraints { make in
            make.top.equalTo(sourceLabel.snp.bottom).offset(10)
            make.left.equalTo(contentView).offset(16)
            make.right.equalTo(contentView).offset(16)
        }
        
        let targetLabel = UILabel()
        targetLabel.textColor = .white
        targetLabel.font = UIFont.systemFont(ofSize: 16.0)
        targetLabel.text = ProfileUtil.share.textTargetLanguage.language
        contentView.addSubview(targetLabel)
        targetLabel.snp.makeConstraints { make in
            make.top.equalTo(source.snp.bottom).offset(42)
            make.left.equalTo(contentView).offset(16)
        }
        
        let target = UILabel()
        target.textColor = .white
        target.numberOfLines = 0
        target.font = UIFont.systemFont(ofSize: 16)
        target.text = result
        contentView.addSubview(target)
        target.snp.makeConstraints { make in
            make.top.equalTo(targetLabel.snp.bottom).offset(10)
            make.left.equalTo(contentView).offset(16)
            make.right.equalTo(contentView).offset(16)
            make.bottom.equalTo(contentView).offset(-20)
        }
    }
    
}
