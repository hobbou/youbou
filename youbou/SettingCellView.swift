//
//  CellSettingView.swift
//  youbou
//
//  Created by Hans Yonathan on 16/10/2016.
//  Copyright © 2016 Hans Yonathan. All rights reserved.
//

import UIKit

class SettingCell: BaseCell{
    
    override var isHighlighted: Bool{
        didSet{
            backgroundColor = isHighlighted ? UIColor.darkGray : UIColor.blue
        }
    }

    override var isSelected: Bool{
        didSet{
            backgroundColor = isSelected ? UIColor.darkGray : UIColor.blue
        }
    }
    
    var setting: Setting?{
        didSet{
            nameLabel.text = setting?.name.rawValue
            //iconImage.image = setting?.imageName
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        return label
    }()
    
    let iconImage: UIImageView = {
        let iconImage = UIImageView()
        iconImage.backgroundColor = UIColor.green
        iconImage.layer.cornerRadius = 15
        iconImage.layer.masksToBounds = true
        iconImage.contentMode = .scaleAspectFill
        return iconImage
    }()
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = UIColor.blue
        addSubview(nameLabel)
        addSubview(iconImage)
        addConstraintsWithFormat(format: "H:|-16-[v0(30)]-8-[v1]|", views: iconImage,nameLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: nameLabel)
        addConstraintsWithFormat(format: "V:[v0(30)]", views: iconImage)
        addConstraint(NSLayoutConstraint(item: iconImage, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
}
