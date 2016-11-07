//
//  MenuBarView.swift
//  youbou
//
//  Created by Hans Yonathan on 9/10/2016.
//  Copyright © 2016 Hans Yonathan. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame:CGRect){
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews(){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.red
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let cellId = "cellId"
    
    let menuNames = ["Home", "Trending", "Subscription", "Account"]
    
    var homeController: HomeController?
    
    override init(frame:CGRect){
        super.init(frame: frame)
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        let selectedIndexPath = NSIndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: UICollectionViewScrollPosition(rawValue: UInt(GL_NONE)))
        
        setupHorizontalBar()
        
    }
    
    var horizontalBarViewLeftAnchorConstraint: NSLayoutConstraint?
    
    func setupHorizontalBar(){
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = UIColor.white
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)
        
        //oldschool to set the bottom bar
        //horizontalBarView.frame = CGRect(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
        
        //new school begin on ios9
        horizontalBarViewLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarViewLeftAnchorConstraint?.isActive = true
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /*let x = CGFloat(indexPath.item) * frame.width / 4
        horizontalBarViewLeftAnchorConstraint?.constant = x
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }) { (completed: Bool) in
            
        }*/
        
        homeController?.scrollToMenuIndex(menuIndex: indexPath.item)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        cell.titleLabel.text = menuNames[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width/4, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MenuCell: BaseCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "home")
        return iv
    }()
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Home"
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        //label.backgroundColor = UIColor.blue
        return label
    }()
    
    override var isHighlighted: Bool {
        didSet{
            print(123)
            titleLabel.textColor = isHighlighted ? UIColor.white: UIColor.darkGray
        }
    }
    
    override var isSelected: Bool {
        didSet{
            print(456)
            titleLabel.textColor = isSelected ? UIColor.white: UIColor.darkGray
        }
    }
    
    override func setupViews(){
        super.setupViews()
        addSubview(titleLabel)
        addConstraintsWithFormat(format: "H:[v0(94)]", views: titleLabel)
        addConstraintsWithFormat(format: "V:[v0(28)]", views: titleLabel)
        
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
}
