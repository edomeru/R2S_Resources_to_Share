//
//  NewResourceViewController.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 1/12/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import UIKit
import CZPicker


class NewResourceViewController: BaseViewController {
    var newResourceView = NewResourceView()
    var rate = [String]()
    var reateSelected: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        initUILayout()
        
    
    }
    
    
    private func initUILayout() {
     
        
        self.newResourceView = self.loadFromNibNamed(nibNamed: Constants.xib.NewResourceView) as! NewResourceView
        self.view = self.newResourceView
        
      
            rate = ["Per Quantity", "Per Hour", "Per Day"]
        self.newResourceView.rateUITextField.addTarget(self, action: #selector(NewResourceViewController.rateTapped), for: UIControlEvents.editingDidBegin)

        
    }
    
    func rateTapped(){
        let pickerDialog = CZPickerView(headerTitle: "Type of Alert", cancelButtonTitle: "Cancel", confirmButtonTitle: "Ok")
        pickerDialog?.delegate = self
        pickerDialog?.dataSource = self
        pickerDialog?.needFooterView = true
        pickerDialog?.headerBackgroundColor = .blue
        pickerDialog?.confirmButtonBackgroundColor = .blue
        pickerDialog?.checkmarkColor = .blue
        pickerDialog?.show()
    }
    
    
    
}



extension NewResourceViewController: NewResourceViewDelegate {
    
    func submitButtonPressed(sender: AnyObject) {}

}

extension NewResourceViewController: CZPickerViewDelegate, CZPickerViewDataSource {
    
    public func numberOfRows(in pickerView: CZPickerView!) -> Int {
        
            print("picker 1 count", pickerView.tag)
            return rate.count
            
        
    }
    
    func czpickerView(_ pickerView: CZPickerView!, imageForRow row: Int) -> UIImage! {
       
//            if pickerView == pickerWithImage {
//                return rate[row]
//            }
            //        if pickerView == alertPickerWithImage {
            //          return 0
            //        }
        
        return nil
    }
    
    func numberOfRowsInPickerView(pickerView: CZPickerView!) -> Int {
       
            print("picker 1 count", pickerView.tag)
            return rate.count
        
        
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        
        
        
        
        
            print("picker 1 count", pickerView.tag)
            return rate[row]
        
        
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int){
        
        
        
        
      
            print("FRUITS didConfirmWithItemAtRow", rate[row])
            self.newResourceView.rateUITextField.text = rate[row]
            reateSelected = rate[row]
            print(rate[row])
            
        
        
        
        
    }
    
    func czpickerViewDidClickCancelButton(_ pickerView: CZPickerView!) {
        
    }
    
    
}

