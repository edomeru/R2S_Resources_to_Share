//
//  HomeViewController.swift
//  R2S
//
//  Created by Earth Maniebo on 16/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    var homeView = HomeView()
    var featuredPageControl = UIPageControl()
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUILayout()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Private Functions
    private func initUILayout() {
        self.screenSize = UIScreen.main.bounds
        self.screenWidth = screenSize.width
        self.screenHeight = screenSize.height

        self.homeView = self.loadFromNibNamed(nibNamed: Constants.xib.homeView) as! HomeView
        self.view = self.homeView
        
        self.homeView.homeTableView.register(UINib(nibName: Constants.xib.featuredCell, bundle: nil), forCellReuseIdentifier: "FeaturedCell")
        self.homeView.homeTableView.delegate = self
        self.homeView.homeTableView.dataSource = self
    }
}

// UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            let computedWidth = screenWidth / 3.0
            let computedHeight = computedWidth
            return 180.0
        case 1:
            let computedWidth = screenWidth / 2.3
            let computedHeight = computedWidth + 53.0
            return computedHeight + 20.0
        default:
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

// UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.homeView.homeTableView {
            switch indexPath.section {
            case 0:
                let computedWidth = screenWidth / 3
                let computedHeight = CGFloat(180.0)
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "FeaturedCell", for: indexPath as IndexPath) as! FeaturedTableViewCell
                cell.preservesSuperviewLayoutMargins = false
                cell.separatorInset = UIEdgeInsets.zero
                cell.layoutMargins = UIEdgeInsets.zero
                let scrollViewWidth = cell.featuredCarouselScrollView.frame.width
                let scrollViewHeight = cell.featuredCarouselScrollView.frame.height
                cell.featuredCarouselScrollView.frame = CGRect(x: 0, y: 0, width: cell.featuredCarouselScrollView.frame.width, height: computedHeight + 6)
                cell.featuredCarouselScrollView.contentSize = CGSize(width: scrollViewWidth * 3, height: 1)
                
                let featuredCarouselView1 = loadFromNibNamed(nibNamed: Constants.xib.featuredCarouselItem) as! FeaturedCarouselItemView
                let featuredCarouselView2 = loadFromNibNamed(nibNamed: Constants.xib.featuredCarouselItem) as! FeaturedCarouselItemView
                let featuredCarouselView3 = loadFromNibNamed(nibNamed: Constants.xib.featuredCarouselItem) as! FeaturedCarouselItemView
                
                featuredCarouselView1.frame = CGRect(x: 0, y: 0, width: scrollViewWidth, height: scrollViewHeight)
                featuredCarouselView2.frame = CGRect(x: scrollViewWidth * CGFloat(1), y: 0, width: scrollViewWidth, height: scrollViewHeight)
                featuredCarouselView3.frame = CGRect(x: scrollViewWidth * CGFloat(2), y: 0, width: scrollViewWidth, height: scrollViewHeight)
                
                cell.featuredCarouselScrollView.addSubview(featuredCarouselView1)
                cell.featuredCarouselScrollView.addSubview(featuredCarouselView2)
                cell.featuredCarouselScrollView.addSubview(featuredCarouselView3)
                
                return cell
                
            default:
                return UITableViewCell()
            }
        }
        return UITableViewCell()
    }
}
