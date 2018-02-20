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
import SwiftyJSON
import SwiftSpinner
import Foundation
import Alamofire
import AlamofireImage
import Kingfisher

class NewResourceViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TagListViewDelegate {
    
    var nameplaceHolder = NSMutableAttributedString()
    var descriptionplaceHolder = NSMutableAttributedString()
    var quantityplaceHolder = NSMutableAttributedString()
    var priceplaceHolder = NSMutableAttributedString()
    var rateplaceHolder = NSMutableAttributedString()
    var newResourceView = NewResourceView()
    var rate = [String]()
    var action = [String]()
    var imagesDictionary = [String : Any]()
    var images = [UIImage]()
    var imageStringArray = [String]()
    var reateSelected: String?
    var actionSelected: String?
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    let supportedCodeTypes = [AVMetadataObjectTypeQRCode]
    var subcategoryNames = [String]()
    var mainCategoryNames = [String]()
    var checkboxCheck: Bool = false
    var selectedTags = [String : Any]()
    let validator = Validator()
    var categories = [String : AnyObject]()
    var categoriesArray = NSMutableArray()
    var categoryArray:Array = [Dictionary<String, AnyObject>]()
    var img_Array:Array = [Dictionary<String, AnyObject>]()
    var imageArray = NSMutableArray()
    var location = [String : Any]()
    var base64Param = [String : Any]()
    var resource_rate: String?
    var image_url: String?
    var image: UIImage?
    var params = [String: AnyObject]()
    var imageNewDictionary = [String: AnyObject]()
    var  jsonDataa: NSData?
    var jsonString:String?
    var  json: Any?
    var stringParam:String?
    var categoriesString:String = ""
    var imgString:String = ""
    var img_url:String?
    var Name  = "Name of Resource"
    var descLabel  = "Description"
    var quantityLabel  = "Quantity"
    var priceLabel  = "Price"
    var rateLAbel  = "Rate"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUILayout()
        self.setupValidator()
        
        
       
        
        descriptionplaceHolder = NSMutableAttributedString(string:descLabel, attributes: [NSFontAttributeName:UIFont(name: "Helvetica", size: 15.0)!])
        quantityplaceHolder = NSMutableAttributedString(string:quantityLabel, attributes: [NSFontAttributeName:UIFont(name: "Helvetica", size: 15.0)!])
        priceplaceHolder = NSMutableAttributedString(string:priceLabel, attributes: [NSFontAttributeName:UIFont(name: "Helvetica", size: 15.0)!])
        rateplaceHolder = NSMutableAttributedString(string:rateLAbel, attributes: [NSFontAttributeName:UIFont(name: "Helvetica", size: 15.0)!])
        
        
        
        
        descriptionplaceHolder.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range:NSRange(location:0,length:descLabel.characters.count))
        quantityplaceHolder.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range:NSRange(location:0,length:quantityLabel.characters.count))
        priceplaceHolder.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range:NSRange(location:0,length:priceLabel.characters.count))
        rateplaceHolder.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range:NSRange(location:0,length:rateLAbel.characters.count))
        
        
        
    }
    
    func uploadImage(image: UIImage){
        
     let imgData = UIImagePNGRepresentation(image)!
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "fileset",fileName: "file.jpeg", mimeType: "image/jpg")
        },
                         to:"https://s3-ap-southeast-1.amazonaws.com/resourcestoshare/resources/static/uploads")
        { (result) in
            
            print("RESULT", result)
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print("SUCCESS",response.result.value)
                    //checkImage()
//                    self.saveImageToDictionary(imageString: "https://s3-ap-southeast-1.amazonaws.com/resourcestoshare/resources/static/uploads/file.jpeg")
                    
                }
                
            case .failure(let encodingError):
                print("FAILED",encodingError)
            }
        }
    }
    
    
//    func saveImageToDictionary(imageString: String){
//    imagesDictionary["image"] = "https://s3-ap-southeast-1.amazonaws.com/resourcestoshare/resources/static/uploads/file.jpeg"
//    imagesDictionary["image_full"] = "https://s3-ap-southeast-1.amazonaws.com/resourcestoshare/resources/static/uploads/file.jpeg"
//    image_url = "https://s3-ap-southeast-1.amazonaws.com/resourcestoshare/resources/static/uploads/file.jpeg"
//        
//        print("saveImageToDictionary")
//    
//    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
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
        self.newResourceView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
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
        self.newResourceView.addPhotoUIImageView.isUserInteractionEnabled = true
        self.newResourceView.addPhotoUIImageView.addGestureRecognizer(tapGestureRecognizer)
        
        self.newResourceView.subCategoryUItextField.addTarget(self, action: Selector("subCatSearchTextField"), for: UIControlEvents.editingDidBegin)
        
        
        self.newResourceView.mainCategoryUISearchTextField.addTarget(self, action: Selector("mainSearchTextField"), for: UIControlEvents.editingDidBegin)
        
        
        self.newResourceView.CategoryTagListView.delegate = self
        
        
//        let remoteImageURL = URL(string: "https://s3-ap-southeast-1.amazonaws.com/resourcestoshare/resources/static/uploads/1514720765506_2_full.jpg")!
//        
//        // Use Alamofire to download the image
//        Alamofire.request(remoteImageURL).responseData { (response) in
//            if response.error == nil {
//                print("remotepic",response.result)
//                
//                // Show the downloaded image:
//                if let data = response.data {
//                    self.newResourceView.addPhotoUIImageView.image = UIImage(data: data)
//                }
//            }
//        }
        
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
            //self.newResourceView.subCategoryUItextField.text = item.title
            
//            self.newResourceView.subCategoryUItextField.leftViewMode = UITextFieldViewMode.always
//            let view = TagListView(frame: CGRect(x: self.newResourceView.CategoryTagListView.frame.width, y: 0, width: 90, height: 20))
//            //let image = UIImage(named: imageName)
//             self.newResourceView.CategoryTagListView = view
//            self.newResourceView.subCategoryUItextField.leftView = view
//            
//            
//            self.newResourceView.CategoryTagListView.tagBackgroundColor = UIColor(hexString: Constants.color.primaryDark)!
//           
//           self.newResourceView.CategoryTagListView.layer.borderWidth = 2
        
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
    
    func unescapeString(string: String) -> String {
        return string.replacingOccurrences(of: "\\\"", with: "\"")
    }
    
    func unescapeString2(string: String) -> String {
       var str1 = string.replacingOccurrences(of: "\"{", with: "{")
       var str2 = str1.replacingOccurrences(of: "}\"", with: "}")
        
        
        return str2
    }
    
   
    
    func jsonToString(json: AnyObject){
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            print(convertedString ?? "defaultvalue")
        } catch let myJSONError {
            print(myJSONError)
        }
        
    }
    
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let size = CGSize(width: 500, height: 500)
         image = resizeImage((info[UIImagePickerControllerOriginalImage] as? UIImage)!, targetSize: size)
        
        
        UIImageWriteToSavedPhotosAlbum((info[UIImagePickerControllerOriginalImage] as? UIImage)!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
        images.append(image!)
        
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        let fullImageBase64 = convert_from_image_to_jpeg_to_Base64(image: image!)
        print("FETCHED_fullImageBase64", fullImageBase64)
        
        
        let croppedImageBase64 = crop(image: image!,  withWidth: 400, andHeight: 850)
        let croppedbase64String = convert_from_image_to_jpeg_to_Base64(image: croppedImageBase64!)
        
        let dataImg = "data:image/jpg;base64,"
        base64Param["image_full"] =   dataImg + fullImageBase64
        base64Param["image"] =  dataImg + croppedbase64String
        print("FETCHED_image", JSON(base64Param))
        
         SystemService.upload(params:base64Param) { (statusCode, jsonData) in
            print("SATUSCODE_UPLOAD",statusCode)
            print("JSON_UPLOAD",jsonData)
             if statusCode == 201 {
            print("SUCCEESFUL_UPLOAD", jsonData!)
                
                  //self.jsonToString(json: jsonData! as AnyObject)
              
                self.imageNewDictionary["image_full"] = jsonData!["image_url_full"].stringValue as AnyObject
                self.imageNewDictionary["image"] = jsonData!["image_url"].stringValue as AnyObject
                self.imageStringArray.append(jsonData!["image_url"].stringValue)
                self.img_Array.append(self.imageNewDictionary)
                
                print("IMAGE_ARRAY", self.img_Array)
               
                self.imgString = self.imageNewDictionary.description
                self.imgString.remove(at: self.imgString.startIndex)
                self.imgString.remove(at: self.imgString.index(before: self.imgString.endIndex))
                
                self.imgString = "{" + self.imgString + "}"
                
                let jsonImg = self.imgString.replacingOccurrences(of: "(", with: "[")
                
                
                self.imageArray.add(jsonImg)
                
                
            
            self.imgString = "[" + self.imageArray.componentsJoined(by: ",") + "]"
            
            
             
                let dict_imageString = self.convertToDictionary(text: self.imgString)
                print("IMAGEString",dict_imageString)
              
           self.img_url =  jsonData!["image_url_full"].stringValue
                
                }
            }
        //self.saveImageToDictionary()
        self.newResourceView.imageCollectionView.reloadData()
        self.dismiss(animated: false, completion: nil)
        
    }
    
    func checkIfEmpty(){
        
        if ( self.images.isEmpty) {
            
 Utility.showSnackBAr(messege: "Please add atleast one resource image", bgcolor: UIColor(hexString: Constants.color.redSnackBar)!)
            
            
        }else{
            self.newResourceView.endEditing(true)
            self.validator.validate(self)
        
        }
    }

    
   
    
    func convert_from_image_to_jpeg_to_Base64(image: UIImage)-> String {
        
        if let jpegDatacropped = UIImageJPEGRepresentation(image, 80) {
            
            let strBase64 = jpegDatacropped.base64EncodedString(options: .endLineWithLineFeed)
            
            return strBase64
        }
        return ""
    }
    
    
    func crop(image: UIImage, withWidth width: Double, andHeight height: Double) -> UIImage? {
        
        if let cgImage = image.cgImage {
            
            let contextImage: UIImage = UIImage(cgImage: cgImage)
            
            let contextSize: CGSize = contextImage.size
            
            var posX: CGFloat = 0.0
            var posY: CGFloat = 0.0
            var cgwidth: CGFloat = CGFloat(width)
            var cgheight: CGFloat = CGFloat(height)
            
            // See what size is longer and create the center off of that
            if contextSize.width > contextSize.height {
                posX = ((contextSize.width - contextSize.height) / 2)
                posY = 0
                cgwidth = contextSize.height
                cgheight = contextSize.height
            } else {
                posX = 0
                posY = ((contextSize.height - contextSize.width) / 2)
                cgwidth = contextSize.width
                cgheight = contextSize.width
            }
            
            let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
            
            // Create bitmap image from context using the rect
            var croppedContextImage: CGImage? = nil
            if let contextImage = contextImage.cgImage {
                if let croppedImage = contextImage.cropping(to: rect) {
                    croppedContextImage = croppedImage
                }
            }
            
            // Create a new image based on the imageRef and rotate back to the original orientation
            if let croppedImage:CGImage = croppedContextImage {
                let image: UIImage = UIImage(cgImage: croppedImage, scale: image.scale, orientation: image.imageOrientation)
                return image
            }
            
        }
        
        return nil
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
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
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionCell", for: indexPath) as! ImageResourcesCollectionViewCell
        
        
//        let processor = RoundCornerImageProcessor(cornerRadius: 20)
//        cell.ImageResource.kf.setImage(with:  URL(string: imageStringArray[indexPath.item]), placeholder: nil, options: [.processor(processor)])
        print("dvdvvvdd",imageStringArray.count)
        print("wvwwrvgrg",images[indexPath.item])
        
    
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
        
         checkIfEmpty()
        
        
        
        
    }
    
}


//MARK - ValidationDelegate
extension NewResourceViewController: ValidationDelegate {
    func validationSuccessful() {
        if Reachability.isConnectedToNetwork() {
            SwiftSpinner.show("Please wait...")
            
            print("IMAGESS", images)

            
            let name = self.newResourceView.nameOfResourceUILable.text!
            let description = self.newResourceView.descriptionUILabel.text!
            let rate = self.newResourceView.rateUITextField.text!
            let quantity = Int(self.newResourceView.quantityUITextField.text!)
            let price = Int(self.newResourceView.priceUITextField.text!)
            
            
            switch (rate) {
            case "Per Quantity":
                resource_rate = "QTY"
                break
            
            case "Per Hour":
                 resource_rate = "HOUR"
                break
                
            case "Per Day":
                resource_rate = "DAY"
                break
                
            default:
                
                break
            
            }
            
            
            
//            print(name)
//            print(description)
//            print(resource_rate!)
//            //print(quantity)
//            print(price)
            
            
            //print("dmclicoisbncoasbcoiah",self.newResourceView.CategoryTagListView.tagViews.count)
            
            for tags in self.newResourceView.CategoryTagListView.tagViews {
                let category = SubcategoryDao.getAllBySubCategoryName(categoryId: self.newResourceView.mainCategoryUISearchTextField.tag, subCategoryName: (tags.titleLabel?.text)!)
                
                for cat in category {
                    
                    if let cat_id = cat.parentCategory?.id {
                        
                        categories["main_category_id"] =  cat_id as AnyObject
                        print(cat_id)
                        
                    }
                    
                    if let cat_name = cat.parentCategory?.name {
                        
                        //categories["main_category_name"] =  cat_name as AnyObject
                        print(cat_name)
                        
                    }
                    
                    categories["subcategory_id"] = cat.id as AnyObject
                    //categories["subcategory_name"] = cat.name as AnyObject
                    
                    print(cat.id)
                    print(cat.name)
                    categoryArray.append(categories)
                    
                }
               
                categoriesString = categories.description
                categoriesString.remove(at: categoriesString.startIndex)
                categoriesString.remove(at: categoriesString.index(before: categoriesString.endIndex))
                
                categoriesString = "{" + categoriesString + "}"
                
              let c = categoriesString.replacingOccurrences(of: "(", with: "[")
                
                
                categoriesArray.add(c)
                
                
            }
            
            
             print("JSONCAT",categoryArray)
            
            
            categoriesString = "[" + categoriesArray.componentsJoined(by: ",") + "]"
             let dict_categoryString = convertToDictionary(text: categoriesString)
             print("categoriesString",categoriesString)
    
           location["city"] =   self.newResourceView.cityUITextField.text!
           location["state"] = self.newResourceView.stateUITextField.text!
           location["street"] =  self.newResourceView.streetUITextField.text!
           location["zipcode"] =  self.newResourceView.zipcodeUITextField.text! 
            
            
            
            
            params["categories"] = categoryArray as AnyObject
            params["images"] = self.img_Array as AnyObject
            
            
            
         
            
            
            
            
           
            
            
            var locationString = location.description
            locationString.remove(at: locationString.startIndex)
            locationString.remove(at: locationString.index(before: locationString.endIndex))
            
            locationString = "{" + locationString + "}"
             let dict_locationString = convertToDictionary(text: locationString)
            print("locationString",dict_locationString)
            
            
            let data = self.img_url?.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            
            
         
            
            
            params["location"] = locationString as AnyObject
            params["name"] = name as AnyObject
            params["description"] = description as AnyObject
            params["price"] = price as AnyObject
            params["quantity"] = quantity as AnyObject
            params["resource_rate"] = resource_rate! as AnyObject
            params["image_url"] = self.img_url as AnyObject
            
            
            var jsonString = params.description
            jsonString.remove(at: jsonString.startIndex)
            jsonString.remove(at: jsonString.index(before: jsonString.endIndex))
            
            jsonString = "{" + jsonString + "}"

            jsonString = jsonString.replacingOccurrences(of: "\"[", with: "[").replacingOccurrences(of: "]\"", with: "]")

           let noBackslash = unescapeString(string: jsonString)
            let noDoublequoteAndslash = unescapeString2(string: noBackslash)
           print("noBAckslash", noDoublequoteAndslash)
           let converted = convertToDictionary(text: noDoublequoteAndslash)
             //print("converted", converted!)
            
            print("DICTIONARIESLOC",dict_locationString!)
             print("CATEGORY_DICTIONARY",categories)
            print("LOCATION_OBJECT",location)
            print("PARAMS",params)
            print("IMAGE",img_Array)
           
            
           // let params:NSMutableDictionary? = ["foo": "bar"];
            let ulr =  NSURL(string:"http://api.r2s.tirsolutions.com/resources-to-share/api/users/2/resources" as String)
            var request = URLRequest(url: ulr! as URL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            let data1 = try! JSONSerialization.data(withJSONObject: self.params, options: JSONSerialization.WritingOptions.prettyPrinted)
//            
//            let json = NSString(data: data1, encoding: String.Encoding.utf8.rawValue)
//            if let json = json {
//                print(json)
//            }
//            request.httpBody = (noDoublequoteAndslash).data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue));
//            
//            
//            Alamofire.request(request as! URLRequestConvertible)
//                .responseJSON { response in
//                    // do whatever you want here
//                    print(response.request)
//                    print(response.response)
//                    print(response.data)
//                    print(response.result)
//                    
//            }   
        //}
            
            
            
            ResourceService.createResource(id: UserHelper.getId()! , params: params) { (statusCode, message) in
                SwiftSpinner.hide()
                print("STATUS CODE",statusCode)
                print("MESSAGE2", message)
                if statusCode == 201 {
                     Utility.showSnackBAr(messege: "Your resource has been submitted for review. It should be posted within 48 hours once verified", bgcolor: UIColor(hexString: Constants.color.greenSnackBar)!)
                } else {
                    Utility.showAlert(title: "Error", message: message!, targetController: self)
                }
            }
            
            
        } else {
            Utility.showAlert(title: "", message: "No internet connection.", targetController: self)
        }
    
            
        
        
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (field, _) in errors {
            if let field =  field as? UITextField {
                switch field {
  
                case self.newResourceView.nameOfResourceUILable:
                    nameplaceHolder = NSMutableAttributedString(string:Name, attributes: [NSFontAttributeName:UIFont(name: "Helvetica", size: 15.0)!])
                    nameplaceHolder.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range:NSRange(location:0,length:Name.characters.count))
                    self.newResourceView.nameOfResourceUILable.attributedPlaceholder = nameplaceHolder
                    self.newResourceView.nameErrorLine.isHidden = false
                case self.newResourceView.descriptionUILabel:
                    self.newResourceView.descriptionUILabel.attributedPlaceholder = descriptionplaceHolder
                    self.newResourceView.descErrorLine.isHidden = false
                case self.newResourceView.rateUITextField:
                    self.newResourceView.rateUITextField.attributedPlaceholder = rateplaceHolder
                    self.newResourceView.rateErrorLine.isHidden = false
                case self.newResourceView.priceUITextField:
                    self.newResourceView.priceUITextField.attributedPlaceholder = priceplaceHolder
                    self.newResourceView.priceErrorLine.isHidden = false
                case self.newResourceView.quantityUITextField:
                    self.newResourceView.quantityUITextField.attributedPlaceholder = quantityplaceHolder
                    self.newResourceView.quantityErrorLine.isHidden = false
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
            self.newResourceView.nameErrorLine.isHidden = true
           
        case self.newResourceView.descriptionUILabel:
            self.newResourceView.descErrorLine.isHidden = true
            descriptionplaceHolder.addAttribute(NSForegroundColorAttributeName, value: Constants.color.grayUnderline, range:NSRange(location:0,length:descLabel.characters.count))
            
        case self.newResourceView.rateUITextField:
            self.newResourceView.rateErrorLine.isHidden = true
            rateplaceHolder.addAttribute(NSForegroundColorAttributeName, value: Constants.color.grayUnderline, range:NSRange(location:0,length:rateLAbel.characters.count))
        case self.newResourceView.priceUITextField:
           self.newResourceView.priceErrorLine.isHidden = true
             priceplaceHolder.addAttribute(NSForegroundColorAttributeName, value: Constants.color.grayUnderline, range:NSRange(location:0,length:priceLabel.characters.count))
        case self.newResourceView.quantityUITextField:
          self.newResourceView.quantityErrorLine.isHidden = true
             quantityplaceHolder.addAttribute(NSForegroundColorAttributeName, value: Constants.color.grayUnderline, range:NSRange(location:0,length:quantityLabel.characters.count))
            
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


