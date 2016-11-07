//
//  ViewController.swift
//  youbou
//
//  Created by Hans Yonathan on 9/10/2016.
//  Copyright © 2016 Hans Yonathan. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "Home"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        
        setupCollectionView()
        setupMenuBar()
        setupNavBarButtons()
        
    }

    let cellId = "cellId"
    let trendingCellId = "trendingCellId"
    let subscriptionCellId = "subscriptionCellId"
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        return mb
    }()

    let titles = [
        "Home",
        "Treding",
        "Subscriptions",
        "Account"
    ]

    func setupCollectionView(){
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout{
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(TrendingCell.self, forCellWithReuseIdentifier: trendingCellId)
        collectionView?.register(SubscriptionCell.self, forCellWithReuseIdentifier: subscriptionCellId)
        collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView?.isPagingEnabled = true
    }
    
    private func setupMenuBar(){
        navigationController?.hidesBarsOnSwipe = true
        
        let redView = UIView()
        redView.backgroundColor = UIColor.red
        view.addSubview(redView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: redView)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: redView)
        
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format:"H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format:"V:[v0(50)]", views: menuBar)
        
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    private func setupNavBarButtons(){
        let searchBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(handleSearch))
        let moreBarButtonItem = UIBarButtonItem(title: "More", style: .plain, target: self, action: #selector(handleMore))
        searchBarButtonItem.tintColor = UIColor.white
        moreBarButtonItem.tintColor = UIColor.white
        navigationItem.rightBarButtonItems = [moreBarButtonItem, searchBarButtonItem]
        
    }
    
    func handleSearch(){
        print("search")
    }
    
    func scrollToMenuIndex(menuIndex: Int){
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .init(rawValue: 0), animated: true)
        setTitle(index: menuIndex)
    }

    private func setTitle(index: Int){
        if let titleLabel = navigationItem.titleView as? UILabel{
            titleLabel.text = " \(titles[index])"
        }
    }
    
    lazy var settingLauncher: SettingLauncher = {
        let launcher = SettingLauncher()
        launcher.homeController = self
        return launcher
    }()
    
    func handleMore(){
        settingLauncher.showSettings()
    }
    
    func showControllerForSetting(setting: Setting){
        let dummySettingViewController = UIViewController()
        dummySettingViewController.navigationItem.title = setting.name.rawValue
        dummySettingViewController.view.backgroundColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.pushViewController(dummySettingViewController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.x)
        menuBar.horizontalBarViewLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init(rawValue: 0))
        //print(targetContentOffset.pointee.x)
        setTitle(index: Int(index))

    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier: String
        
        if indexPath.item == 1 {
            identifier = trendingCellId
        } else if indexPath.item == 2 {
            identifier = subscriptionCellId
        }else{
            identifier = cellId
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        //let colors: [UIColor] = [.blue, .black, .orange, .red]
        //cell.backgroundColor = colors[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 50)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


