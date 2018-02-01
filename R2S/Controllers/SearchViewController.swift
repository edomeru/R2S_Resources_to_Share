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
import CZPicker
import SwiftSpinner

class SearchViewController: BaseViewController, UISearchBarDelegate {
        let realm = try! Realm()
    var searchView = SearchView()
    var searchBar = UISearchBar()
    var resources:Results<Resource>!
    var filteredArray = [String]()
    var shouldShowSearchResults = false
    var settings = [String]()
    var setingsSelected: String?
    var selectedResourceId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
          createSearchBar()
          fetchData()
        settings = ["Highest to lowest price", "Lowest to highest price"]
        
    }

    func createSearchBar(){
        searchBar.placeholder = "Search Resources"
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        self.navigationItem.titleView = searchBar
      
    }
    
    func sortTapped() {
        let pickerDialog = CZPickerView(headerTitle: "Sort by:", cancelButtonTitle: "Cancel", confirmButtonTitle: "Ok")
        pickerDialog?.delegate = self
        pickerDialog?.dataSource = self
        pickerDialog?.headerBackgroundColor = UIColor(hexString: Constants.color.primary)
        pickerDialog?.tag = 1000
        pickerDialog?.confirmButtonBackgroundColor = UIColor(hexString: Constants.color.primary)
        pickerDialog?.checkmarkColor = .blue
        pickerDialog?.needFooterView = false
        pickerDialog?.show()
        
    }
    
    func lowestToHighest () {
    SwiftSpinner.show("Please wait...")
        self.resources = ResourceDao.getResourcesNotByUserAscending(userId: UserHelper.getId()!)
        SwiftSpinner.hide()
        self.searchView.searchTableView.reloadData()
        checkIfEmpty()
        
    }
    
    
    
    func highestToLowest () {
        SwiftSpinner.show("Please wait...")
        self.resources = ResourceDao.getResourcesNotByUserADescending(userId: UserHelper.getId()!)
        SwiftSpinner.hide()
        self.searchView.searchTableView.reloadData()
        checkIfEmpty()
        
    }
    
    func checkIfEmpty(){
        
        if ( self.resources?.isEmpty)! {
            self.searchView.searchTableView.reloadData()

            self.searchView.noResourcesFoundUILabel.isHidden = false
            self.searchView.searchTableView.isHidden = true
            print("NO VALUE")
            
            
        } else {
            
            //print("HAVE VALUES",  self.resources)
           self.searchView.searchTableView.reloadData()
           
            self.searchView.noResourcesFoundUILabel.isHidden = true
            self.searchView.searchTableView.isHidden = false
        }
    }
    
    func showMoreFilters() {
    
        let alertController = UIAlertController(title: "", message: "Enter minimum and maximum price", preferredStyle: UIAlertControllerStyle.alert)
        
        let saveAction = UIAlertAction(title: "Filter", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            let secondTextField = alertController.textFields![1] as UITextField

             SwiftSpinner.show("Please wait...")
           self.resources = ResourceDao.getResourcesMinimumMaximum(min:Int(firstTextField.text!)!,max:Int(secondTextField.text!)!)
            self.searchView.searchTableView.reloadData()
            self.checkIfEmpty()
            SwiftSpinner.hide()
           

        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter minimum price"
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Maximum price"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    
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
               

                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    activityIndicator.stopAnimating()
                    
                    
                    
                    
                    
                     self.initUILayout()
                     self.checkIfEmpty()
                    
                    
                    
                })
            } else {
                
                Utility.showAlert(title: "Error", message: message!, targetController: self)
            }
        }

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ResourceViewController
        destinationVC.selectedResourceId = selectedResourceId
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
        self.searchView.delegate = self
       
        
        self.searchView.searchTableView.register(UINib(nibName: Constants.xib.SearchTableViewCell, bundle:nil), forCellReuseIdentifier: "SearchTableViewCell")
        self.searchView.searchTableView.delegate = self
        self.searchView.searchTableView.dataSource = self
        self.searchView.searchTableView.reloadData()

     print("Resourcesadd",self.resources)
       
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
            cell.imageUIImageView.kf.indicatorType = .activity
            cell.imageUIImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
            cell.imageUIImageView.contentMode = .scaleAspectFit // OR .scaleAspectFill
            cell.imageUIImageView.clipsToBounds = true
            cell.imageUIImageView.kf.setImage(with:  URL(string: img.image))
            
        }
     
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let resource = resources[indexPath.item]
        if let cell = tableView.cellForRow(at: indexPath) {
            
            //         let favIcon = cell.viewWithTag(1000) as! UIImageView
            //            if  favoriteOrNot {
            //
            //
            //            }
            
            selectedResourceId  = resource.id
            // print (resource.id)
            performSegue(withIdentifier: Constants.segue.SearchToResourceSegue, sender: self)
        }
    }

}

extension SearchViewController: CZPickerViewDelegate, CZPickerViewDataSource {
    
    public func numberOfRows(in pickerView: CZPickerView!) -> Int {
        
        
        print("picker 1 count", pickerView.tag)
        return settings.count
        
        
        
    }
    
    func czpickerView(_ pickerView: CZPickerView!, imageForRow row: Int) -> UIImage! {
        
        
        return nil
    }
    
    func numberOfRowsInPickerView(pickerView: CZPickerView!) -> Int {
        
        
        
        print("picker 1 count", pickerView.tag)
        return settings.count
        
        
        
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        
        
        
        print("picker 1 count", pickerView.tag)
        return settings[row]
        
        
        
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int){
        
        
        
        
        
        
        
        
        print("FRUITS didConfirmWithItemAtRow", settings[row])
        
        setingsSelected = settings[row]
        print(settings[row])
        
        setingsSelected = settings[row]
        
        
        
        
        if setingsSelected == "Highest to lowest price" {
            
            highestToLowest ()
            
        }else if setingsSelected == "Lowest to highest price" {
           
           lowestToHighest ()
            
            
        }
        
        
        
        
    }
    
    func czpickerViewDidClickCancelButton(_ pickerView: CZPickerView!) {
        
    }
    
}

// MARK: - LoginViewDelegate
extension SearchViewController: SearchViewDelegate {
    func sortButtonPressed(sender: AnyObject) {
        sortTapped()
    }
    
    func moreFilterButtonPressed(sender: AnyObject) {
        showMoreFilters()
    }
}
