//
//  SearchViewController.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 29/1/18.
//  Copyright © 2018 Total Integrated Resources. All rights reserved.
//

import UIKit
import RealmSwift
import Foundation
import Realm

class SearchViewController: BaseViewController, UISearchBarDelegate {
        let realm = try! Realm()
    var searchView = SearchView()
    var searchBar = UISearchBar()
    var resources:Results<Resource>!
    var filteredArray = [String]()
    var shouldShowSearchResults = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
          createSearchBar()
          fetchData()
        
    }

    func createSearchBar(){
        searchBar.placeholder = "Search Resources"
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        self.navigationItem.titleView = searchBar
      
    }
    
    func  fetchData() {
  
        
        
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0)
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.center = self.view.center
        activityIndicator.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.startAnimating()
        ResourceService.get{ (statusCode, message) in
            if statusCode == 200 {
                
                   self.resources = ResourceDao.getResourcesNotByUser(userId: UserHelper.getId()!)
                print("Resource",self.resources)

                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    activityIndicator.stopAnimating()
                    
                    
                    
                    
                    
                     self.initUILayout()
                    
                    
                    
                    
                })
            } else {
                
                Utility.showAlert(title: "Error", message: message!, targetController: self)
            }
        }
        
        
        
        
        
        
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        searchBar.endEditing(true)
        self.searchView.searchTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//       
//        filteredArray = resources.filter({ (data: String) -> Bool in
//            
//             let data = realm.objects(Resource).filter("name CONTAINS %@", searchText)
//             return data != nil
//        })
//    }
    // MARK: - Private Functions
    private func initUILayout () {
        
        
        self.searchView = self.loadFromNibNamed(nibNamed: Constants.xib.searchView) as! SearchView
        self.searchView.frame = CGRect(x: 0, y: Constants.navbarHeight, width: self.view.frame.width, height: self.view.frame.height)
        
        self.view.addSubview(self.searchView)
        
       
        
        self.searchView.searchTableView.register(UINib(nibName: Constants.xib.SearchTableViewCell, bundle:nil), forCellReuseIdentifier: "SearchTableViewCell")
        self.searchView.searchTableView.delegate = self
        self.searchView.searchTableView.dataSource = self
        self.searchView.searchTableView.reloadData()

    
       
    }
    

    

}


// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 330
    }
    
}
// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDataSource{
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchView.searchTableView {
            
            if shouldShowSearchResults {
            return self.filteredArray.count
            }else {
            return self.resources.count
            }
            
        
            return self.resources.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        
        if shouldShowSearchResults {
        
         cell.titleUILabel.text =  filteredArray[indexPath.row]
        }
        
        cell.titleUILabel.text =  resources[indexPath.row].name

        cell.dateUILabel.text = resources[indexPath.row].createdDate
        cell.priceUILabel.text = "$ \(resources[indexPath.row].price).00"
        cell.infoUILabel.text = resources[indexPath.row].descriptionText
        
        for img in resources[indexPath.row].image {
            
            cell.imageUIImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
            cell.imageUIImageView.contentMode = .scaleAspectFit // OR .scaleAspectFill
            cell.imageUIImageView.clipsToBounds = true
            cell.imageUIImageView.kf.setImage(with:  URL(string: img.image))
            
        }
     
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let resource = resources[indexPath.item]
//        if let cell = tableView.cellForRow(at: indexPath) {
        
            //         let favIcon = cell.viewWithTag(1000) as! UIImageView
            //            if  favoriteOrNot {
            //
            //
            //            }
            
            //selectedResourceId  = resource.id
            // print (resource.id)
            performSegue(withIdentifier: Constants.segue.browseToResourceSegue, sender: self)
        //}
    }
}
