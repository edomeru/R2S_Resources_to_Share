//
//  NewResourceViewController.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 1/12/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import UIKit
import CZPicker
import AVFoundation
import Photos
import TagListView
import SwiftValidator
import SwiftSpinner
import Foundation

class NewResourceViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TagListViewDelegate {
    var newResourceView = NewResourceView()
    var rate = [String]()
    var action = [String]()
    var images = [UIImage]()
    var reateSelected: String?
    var actionSelected: String?
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    let supportedCodeTypes = [AVMetadataObjectTypeQRCode]
    var subcategoryNames = [String]()
    var mainCategoryNames = [String]()
    var checkboxCheck: Bool = false
    var selectedTags = [String : AnyObject]()
     let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUILayout()
        self.setupValidator()
        
      
    
    }
    
    func cameraFunction(){
        // Check if we have permission taking Camera
        if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) == AVAuthorizationStatus.authorized {
            // Already Authorized
            self.cameraPicker()
        } else {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted: Bool) -> Void in
                if granted {
                    self.cameraPicker()
                    
                    return
                } else {
                    self.showAlertforSettings(NSLocalizedString("camera_restricted", comment: ""))
                }
            })
        }
    }
    
    func cameraPicker() {
       // isFromTakingPhoto = true
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        
        self.present(cameraPicker, animated: true, completion: nil)
    }
    
    func openLibrary(){
    
        let status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized:
            photoPicker()
        case .denied:
            showAlertforSettings(NSLocalizedString("photo_restricted", comment: ""))
        case .notDetermined:
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({(status: PHAuthorizationStatus) -> Void in
                if status == .authorized {
                    self.photoPicker()
                }
            })
        case .restricted:
            // Restricted access - normally won't happen.
            showAlertforSettings(NSLocalizedString("photo_restricted", comment: ""))
        }
        
    
    }
    
    
    func photoPicker() {
        //isFromTakingPhoto = false
        let photoPicker = UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.sourceType = .photoLibrary
        
        self.present(photoPicker, animated: true, completion: nil)
    }
    
    func showAlertforSettings(_ message: String) {
        let action = [
            UIAlertAction(title: NSLocalizedString("settings", comment: ""), style: .default) { (action) in
                if let url = URL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(url)
                }
            },
            UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .cancel, handler: nil)
        ]
        
//        Globals.showAlert(self, title: NSLocalizedString("error", comment: ""), message: message, animated: true, completion: nil, actions: action)
    }

    
    private func initUILayout() {
     
        
        self.newResourceView = self.loadFromNibNamed(nibNamed: Constants.xib.NewResourceView) as! NewResourceView
        self.view = self.newResourceView
         self.newResourceView.delegate = self
        
        self.newResourceView.imageCollectionView.register(UINib(nibName: "imageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "imageCollectionCell")
        self.newResourceView.imageCollectionView.delegate = self
        self.newResourceView.imageCollectionView.dataSource = self
      
        self.newResourceView.nameOfResourceUILable.delegate = self
        self.newResourceView.descriptionUILabel.delegate = self
        self.newResourceView.rateUITextField.delegate = self
        self.newResourceView.quantityUITextField.delegate = self
        self.newResourceView.priceUITextField.delegate = self
        
            rate = ["Per Quantity", "Per Hour", "Per Day"]
            action = ["Camera", "Photos", "Cancel"]
        self.newResourceView.rateUITextField.addTarget(self, action: #selector(NewResourceViewController.rateTapped), for: UIControlEvents.editingDidBegin)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        self.newResourceView.isUserInteractionEnabled = true
        self.newResourceView.addGestureRecognizer(tapGestureRecognizer)
        
        self.newResourceView.subCategoryUItextField.addTarget(self, action: Selector("subCatSearchTextField"), for: UIControlEvents.editingDidBegin)
       
        
        self.newResourceView.mainCategoryUISearchTextField.addTarget(self, action: Selector("mainSearchTextField"), for: UIControlEvents.editingDidBegin)
        
        
        self.newResourceView.CategoryTagListView.delegate = self
        
    }
    
    private func setupValidator() {
        self.validator.registerField(self.newResourceView.nameOfResourceUILable, rules: [RequiredRule()])
        self.validator.registerField(self.newResourceView.descriptionUILabel, rules: [RequiredRule()])
        self.validator.registerField(self.newResourceView.quantityUITextField, rules: [RequiredRule()])
        self.validator.registerField(self.newResourceView.priceUITextField, rules: [RequiredRule()])
        self.validator.registerField(self.newResourceView.rateUITextField, rules: [RequiredRule()])
    }
    
    
    
    func mainSearchTextField() {
        self.newResourceView.mainCategoryUISearchTextField.startVisibleWithoutInteraction = true
        
        self.newResourceView.mainCategoryUISearchTextField.theme.bgColor = UIColor.white
        
        // Show loading indicator
        self.newResourceView.mainCategoryUISearchTextField.showLoadingIndicator()
        
        let categoryNames = self.getAllCategoryNames()
        self.newResourceView.mainCategoryUISearchTextField.stopLoadingIndicator()
    self.newResourceView.mainCategoryUISearchTextField.filterStrings(categoryNames)
        
        self.newResourceView.mainCategoryUISearchTextField.itemSelectionHandler = { filteredResults, itemPosition in
            // Just in case you need the item position
            let item = filteredResults[itemPosition]
            print(" MAIN Item at position \(itemPosition): \(item.title)")
            
            self.newResourceView.mainCategoryUISearchTextField.tag = itemPosition + 1
            self.newResourceView.mainCategoryUISearchTextField.text = item.title
             self.newResourceView.subCategoryUItextField.text = ""
            self.subcategoryNames.removeAll()
            // Do whatever you want with the picked item
            //self.newResourceView.CategoryTagListView.addTag(item.title)
            
            
            // self.wishlistAdd.categorySearchTextField.addSubview(tagView)
            
            //self.wishlistAdd.CategoryTagListView.frame = self.wishlistAdd.categorySearchTextField.frame
            
            
        }
    }
    
    
    fileprivate func getAllCategoryNames() -> [String] {
     let categories =  CategoryService.getCategories()
        for category in categories {
            print("CATEGORIES IDS",category.id)
            print("CATEGORIES NAME",category.name)
            mainCategoryNames.append(category.name)
        }
        return mainCategoryNames
    
    }
    
    
    
    func subCatSearchTextField() {

  
        self.newResourceView.subCategoryUItextField.startVisibleWithoutInteraction = true

        self.newResourceView.subCategoryUItextField.theme.bgColor = UIColor.white
        
        
        
        // Show loading indicator
        self.newResourceView.subCategoryUItextField.showLoadingIndicator()
        
        let categoryTuples = self.getAllCscsid()
        print("categories configureSimpleSearchTextField", categoryTuples)
        
        
            self.newResourceView.subCategoryUItextField.filterStrings(categoryTuples)
            
            self.newResourceView.subCategoryUItextField.itemSelectionHandler = { filteredResults, itemPosition in
                // Just in case you need the item position
                let item = filteredResults[itemPosition]
                print("Item at position \(itemPosition): \(item.title)")
                 self.newResourceView.subCategoryUItextField.text = item.title
                self.newResourceView.CategoryTagListView.addTag(item.title)
                // Do whatever you want with the picked item
                //self.newResourceView.CategoryTagListView.addTag(item.title)
                
                
                // self.wishlistAdd.categorySearchTextField.addSubview(tagView)
                
                
                
                
            }
      
        self.newResourceView.subCategoryUItextField.stopLoadingIndicator()
        
 
        
        
        
        
    }
    
    
    fileprivate func getAllCscsid() -> [String] {
        

        print("MAIN TAG",self.newResourceView.mainCategoryUISearchTextField.tag)
            let subcategories =  CategoryService.getSubcategoriesBy(categoryId: self.newResourceView.mainCategoryUISearchTextField.tag)
            for subcategory in subcategories {
                print("SUBCATEGORIES" + "\(subcategory.name )" + "\(subcategory.id)" + " " + "\(subcategory.parentCategory?.name)" + "\(subcategory.parentCategory?.id)" )
                
               subcategoryNames.append(subcategory.name)

            }

        
        return subcategoryNames
    }
    
    
    
    
    
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        let pickerDialog = CZPickerView(headerTitle: "Complete action using", cancelButtonTitle: "Cancel", confirmButtonTitle: "Ok")
        pickerDialog?.delegate = self
        pickerDialog?.dataSource = self
        pickerDialog?.headerBackgroundColor = .blue
        pickerDialog?.confirmButtonBackgroundColor = .blue
        pickerDialog?.tag = 1001
        pickerDialog?.checkmarkColor = .blue
        pickerDialog?.needFooterView = false
        pickerDialog?.show()
    }
    
    func rateTapped(){
        let pickerDialog = CZPickerView(headerTitle: "Type of Alert", cancelButtonTitle: "Cancel", confirmButtonTitle: "Ok")
        pickerDialog?.delegate = self
        pickerDialog?.dataSource = self
        pickerDialog?.needFooterView = true
        pickerDialog?.headerBackgroundColor = .blue
        pickerDialog?.tag = 1000
        pickerDialog?.confirmButtonBackgroundColor = .blue
        pickerDialog?.checkmarkColor = .blue
        pickerDialog?.show()
    }
    
    
    // MARK: TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
        self.newResourceView.CategoryTagListView.removeTagView(tagView)
        
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
    }
    
    
    func performAction() {
        
        //self.newResourceView.CategoryTagListView.addTag(self.wishlistAdd.categoryUITextField.text!)
        
        
    }

    
    
}





extension NewResourceViewController: CZPickerViewDelegate, CZPickerViewDataSource {
    
    public func numberOfRows(in pickerView: CZPickerView!) -> Int {
        
        if (pickerView.tag == 1000){
            print("picker 1 count", pickerView.tag)
            return rate.count
        }else{
            print("picker 2 count", pickerView.tag)
            return action.count
        }
            
        
    }
    
    func czpickerView(_ pickerView: CZPickerView!, imageForRow row: Int) -> UIImage! {
       
        
        return nil
    }
    
    func numberOfRowsInPickerView(pickerView: CZPickerView!) -> Int {
       
        
        if (pickerView.tag == 1000){
            print("picker 1 count", pickerView.tag)
            return rate.count
        }else{
            print("picker 2 count", pickerView.tag)
            return action.count
        }
        
        
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        
        
        if (pickerView.tag == 1000){
            print("picker 1 count", pickerView.tag)
            return rate[row]
        }else{
            print("picker 2 count", pickerView.tag)
            return action[row]
        }
        
        
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int){
        
        
        
        
      
        
            
        if (pickerView.tag == 1000){
            print("FRUITS didConfirmWithItemAtRow", rate[row])
            self.newResourceView.rateUITextField.text = rate[row]
            reateSelected = rate[row]
            print(rate[row])
            
        }else{
            
             actionSelected = action[row]
             print(action[row])
            
            if actionSelected == "Camera" {
            
                cameraFunction()
                
            }else if actionSelected == "Photos" {
            
            openLibrary()
                
            }else{
            
                
            
            }
        }
        
        
        
    }
    
    func czpickerViewDidClickCancelButton(_ pickerView: CZPickerView!) {
        
    }
    
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let size = CGSize(width: 500, height: 500)
        let image = resizeImage((info[UIImagePickerControllerOriginalImage] as? UIImage)!, targetSize: size)
        

            UIImageWriteToSavedPhotosAlbum((info[UIImagePickerControllerOriginalImage] as? UIImage)!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    
        images.append(image)
        print("FETCHED image", image)

        self.newResourceView.imageCollectionView.reloadData()
        self.dismiss(animated: false, completion: nil)
       
    }
    
    func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let _ = error {
            // we got back an error!
            print("Error Saving Photo in Photo Album")
        } else {
            print("Success Saving Photo in Photo Album")
        }
    }
    
    
}

// MARK: - UITableViewDelegate
extension NewResourceViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 530
    }
}


// MARK: - UICollectionViewDataSource
extension NewResourceViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.newResourceView.imageCollectionView {
            return images.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       // if collectionView == self.newResourceView.imageCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionCell", for: indexPath) as! ImageResourcesCollectionViewCell
       
           cell.ImageResource.image = images[indexPath.item]
            return cell
       
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension NewResourceViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.newResourceView.imageCollectionView {
            collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
            //CategoryService.clearSelectedSubcategories(self.subcategories)
            //print(self.subcategories[indexPath.item].id)
            //print("PRINT1",subcategories.count)
            //let resourcesByCategorySelected = ResourceService.getBySubCategory(id: self.subcategories[indexPath.item].id)
            
            //print("PRINT",resourcesByCategorySelected?.count)
            
           // resources = resourcesByCategorySelected
            
//            CategoryService.selectSubategory(self.subcategories[indexPath.item])
//            self.newResourceView.imageCollectionView.reloadData()
            
            
        }
    }
}


extension NewResourceViewController: NewResourceViewDelegate {
    
    func submitButtonPressed
        (sender: AnyObject){
        
        print("HELLLLOOOOOOOOO")
        self.newResourceView.endEditing(true)
        self.validator.validate(self)
        
        
    }
    
}


//MARK - ValidationDelegate
extension NewResourceViewController: ValidationDelegate {
    func validationSuccessful() {
        if Reachability.isConnectedToNetwork() {
            SwiftSpinner.show("Please wait...")
            let name = self.newResourceView.nameOfResourceUILable.text!
            let description = self.newResourceView.descriptionUILabel.text!
            let rate = self.newResourceView.rateUITextField.text!
            let quantity = self.newResourceView.quantityUITextField.text!
            let price = self.newResourceView.priceUITextField.text!
            
            print(name)
            print(description)
            print(rate)
            print(quantity)
            print(price)
            
            
            
        } else {
            Utility.showAlert(title: "", message: "No internet connection.", targetController: self)
        }
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (field, _) in errors {
            if let field =  field as? UITextField {
                switch field {
                case self.newResourceView.nameOfResourceUILable:
                    self.newResourceView.nameOfResourceUILable.backgroundColor = UIColor.red
                case self.newResourceView.descriptionUILabel:
                    self.newResourceView.descriptionUILabel.backgroundColor = UIColor.red
                case self.newResourceView.rateUITextField:
                    self.newResourceView.rateUITextField.backgroundColor = UIColor.red
                case self.newResourceView.priceUITextField:
                    self.newResourceView.priceUITextField.backgroundColor = UIColor.red
                case self.newResourceView.quantityUITextField:
                    self.newResourceView.quantityUITextField.backgroundColor = UIColor.red
                default:
                    print("default")
                }
            }
        }
    }
}


// MARK: - UITextFieldDelegate
extension NewResourceViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.newResourceView.nameOfResourceUILable:
            self.newResourceView.nameOfResourceUILable.backgroundColor = UIColor(hex: Constants.color.grayUnderline)
            self.newResourceView.nameOfResourceUILable.backgroundColor = UIColor.white
        case self.newResourceView.descriptionUILabel:
            self.newResourceView.descriptionUILabel.backgroundColor = UIColor(hex: Constants.color.grayUnderline)
            self.newResourceView.descriptionUILabel.backgroundColor = UIColor.white
            
        case self.newResourceView.rateUITextField:
            self.newResourceView.rateUITextField.backgroundColor = UIColor(hex: Constants.color.grayUnderline)
            self.newResourceView.rateUITextField.backgroundColor = UIColor.white
            
        case self.newResourceView.priceUITextField:
            self.newResourceView.priceUITextField.backgroundColor = UIColor(hex: Constants.color.grayUnderline)
            self.newResourceView.priceUITextField.backgroundColor = UIColor.white
            
        case self.newResourceView.quantityUITextField:
            self.newResourceView.quantityUITextField.backgroundColor = UIColor(hex: Constants.color.grayUnderline)
            self.newResourceView.quantityUITextField.backgroundColor = UIColor.white
            
        default:
            print("default")
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        print("textFieldShouldReturn")
        performAction()
        textField.resignFirstResponder()
        return true
    }
}


