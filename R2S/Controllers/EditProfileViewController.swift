//
//  EditProfileViewController.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 9/1/18.
//  Copyright © 2018 Total Integrated Resources. All rights reserved.
//

import UIKit
import Foundation
import Kingfisher
import SwiftSpinner
import CZPicker
import AVFoundation
import Photos
import SwiftyJSON
import SwiftDate
import DatePickerDialog

class EditProfileViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var editProfileView = EditProfileView()
    var user:User?
    var params = [String: Any]()
    var imageAction = [String]()
    var actionSelected: String?
    var base64Param = [String : Any]()
    var image: UIImage?
    var img_url:String?
    var newDate:String?
    var  startDate: Date?
    var startDateString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        
        self.title = "Edit Profile"
        
        
    }
    
    private func fetchData() {
        
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0)
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.center = self.view.center
        activityIndicator.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.startAnimating()
        user = UserDao.getOneBy(id: UserHelper.getId()!)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            activityIndicator.stopAnimating()
            
            self.initUILayout()
            
        })
        
    }
    
    
    private func initUILayout() {
        
        self.editProfileView = self.loadFromNibNamed(nibNamed: Constants.xib.EditProfile) as! EditProfileView
        self.editProfileView.frame = CGRect(x: 0, y: Constants.navbarHeight, width: self.view.frame.width, height: self.view.frame.height)
        
        self.view.addSubview(self.editProfileView)
        self.editProfileView.delegate = self
        
        self.editProfileView.firstNameUITextField.text = user?.firstName
        self.editProfileView.lastNameUITextField.text = user?.lastName
        self.editProfileView.companyUITextField.text = user?.company?.name
        self.editProfileView.birthdayUITextField.text = user?.birthDate
        self.editProfileView.mobileUITextField.text = user?.mobileNumber
        self.editProfileView.landlineUITextField.text = user?.landlineNumber
        self.editProfileView.designationUITextField.text = user?.designation
        self.editProfileView.bioUITextView.text = user?.descriptionText
        
        if user?.imageUrl != "" {
            let processor = RoundCornerImageProcessor(cornerRadius: 2500)
            self.editProfileView.profPicUIImageView.kf.setImage(with:  URL(string: (user?.imageUrl)!), placeholder: nil, options: [.processor(processor)])
        }
        imageAction = ["Camera", "Photos", "Cancel"]
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        editProfileView.profPicUIImageView.isUserInteractionEnabled = true
        editProfileView.profPicUIImageView.addGestureRecognizer(tapGestureRecognizer)
        
        self.editProfileView.birthdayUITextField.addTarget(self, action: Selector("datePickerBdate"), for: UIControlEvents.editingDidBegin)
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let size = CGSize(width: 500, height: 500)
        image = resizeImage((info[UIImagePickerControllerOriginalImage] as? UIImage)!, targetSize: size)
        
        
        UIImageWriteToSavedPhotosAlbum((info[UIImagePickerControllerOriginalImage] as? UIImage)!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
        //images.append(image!)
        
        self.editProfileView.profPicUIImageView.kf.indicatorType = .activity
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
                self.editProfileView.profPicUIImageView.kf.indicatorType = .activity
                self.img_url =  jsonData!["image_url_full"].stringValue
                let processor = RoundCornerImageProcessor(cornerRadius: 2500)
                self.editProfileView.profPicUIImageView.kf.setImage(with:  URL(string: (self.img_url)!), placeholder: nil, options: [.processor(processor)])
                
            }
        }
        
        // self.newResourceView.imageCollectionView.reloadData()
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
    
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
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
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let _ = error {
            // we got back an error!
            print("Error Saving Photo in Photo Album")
        } else {
            print("Success Saving Photo in Photo Album")
        }
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
    
    func datePickerBdate() {
        let currentDate = Date()
        
        
        let datePicker = DatePickerDialog(textColor: UIColor(hexString: Constants.color.primary)!,
                                          buttonColor: UIColor(hexString: Constants.color.primaryDark)!,
                                          font: UIFont.boldSystemFont(ofSize: 15),
                                          showCancelButton: true)
        datePicker.show("Start Date",
                        doneButtonTitle: "Done",
                        cancelButtonTitle: "Cancel",
                        maximumDate: currentDate,
                        datePickerMode: .date) { (date) in
                            if let dt = date {
                                let formatter = DateFormatter()
                                let singaporeFormatter = DateFormatter()
                                let gregorian = Calendar(identifier: .gregorian)
                                
                                var piStartcComponents = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dt)
                                piStartcComponents.hour = 0
                                piStartcComponents.minute = 0
                                piStartcComponents.second = 0
                                
                                self.startDate = gregorian.date(from: piStartcComponents)!
                                
                                formatter.dateFormat = "YYYY-MM-dd"
                                singaporeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                                self.editProfileView.birthdayUITextField.text = formatter.string(from: self.startDate!)
                                self.startDateString = singaporeFormatter.string(from: self.startDate!)
                                print("DATE OUTPUT",self.editProfileView.birthdayUITextField.text)
                                print("STARTDATEE",self.startDate )
                            }
        }
        
    }
    
    func saveToLocal() -> User {
        let updatedUser = User()
        updatedUser.accountId = (user?.accountId)!
        updatedUser.id = (user?.id)!
        updatedUser.firstName = self.editProfileView.firstNameUITextField.text!
        updatedUser.lastName = self.editProfileView.lastNameUITextField.text!
        updatedUser.email = (user?.email)!
        
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ" //Your date format
        dateFormatter1.timeZone = TimeZone(abbreviation: "GMT+4:00") //Current time zone
        let date1 = dateFormatter1.date(from: newDate!) //according to date format your date string
        print("date",date1)
        
        dateFormatter1.dateFormat = "yyyy-mm-dd"
        let singaporeFormat1 =  dateFormatter1.string(from: date1!)
        
        
        
        
        updatedUser.birthDate = singaporeFormat1
        updatedUser.mobileNumber = self.editProfileView.mobileUITextField.text!
        updatedUser.landlineNumber = self.editProfileView.landlineUITextField.text!
        updatedUser.designation = self.editProfileView.designationUITextField.text!
        updatedUser.descriptionText = self.editProfileView.designationUITextField.text!
        updatedUser.password = UserDefaults.standard.value(forKey: "password") as! String
        
        if self.img_url != nil {
            updatedUser.imageUrl = self.img_url!
        }else{
            updatedUser.imageUrl = (user?.imageUrl)!
        }
        
        updatedUser.status = (user?.status)!
        updatedUser.isSubscribed = (user?.isSubscribed)!
        updatedUser.createdDate = (user?.createdDate)!
        updatedUser.updatedDate = (user?.updatedDate)!
        updatedUser.deletedDate = (user?.deletedDate)!
        
        //Account
        let cmpy = user?.company
        let company = Company()
        company.name = (cmpy?.name)!
        updatedUser.company = company
        print("DAOUSER",updatedUser)
        UserDao.add(updatedUser)
        
        
        let defaults = UserDefaults.standard
        defaults.setValue(user?.accountId, forKey: "accountId")
        defaults.setValue(user?.id, forKey: "id")
        defaults.setValue(self.editProfileView.firstNameUITextField.text!, forKey: "firstName")
        defaults.setValue(self.editProfileView.lastNameUITextField.text!, forKey: "lastName")
        defaults.setValue(UserDefaults.standard.value(forKey: "password"), forKey: "password")
        defaults.setValue(user?.email, forKey: "email")
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ" //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+4:00") //Current time zone
        let date = dateFormatter.date(from: newDate!) //according to date format your date string
        print("date",date)
        
        dateFormatter.dateFormat = "yyyy-mm-dd"
        let singaporeFormat =  dateFormatter.string(from: date!)
        print("newDate",singaporeFormat)
        print("self.editProfileView.birthdayUITextField.text!",self.editProfileView.birthdayUITextField.text!)
        
        
        
        
        
        
        
        defaults.setValue(singaporeFormat, forKey: "birthDate")
        defaults.setValue(self.editProfileView.mobileUITextField.text!, forKey: "mobileNumber")
        defaults.setValue(self.editProfileView.landlineUITextField.text!, forKey: "landlineNumber")
        defaults.setValue(user?.isSubscribed, forKey: "isSubscribed")
        
        if self.img_url != nil {
            defaults.setValue(self.img_url!, forKey: "imageUrl")
        }else{
            defaults.setValue(user?.imageUrl, forKey: "imageUrl")
        }
        
        defaults.setValue(user?.createdDate, forKey: "createdDate")
        defaults.setValue(user?.updatedDate, forKey: "updatedDate")
        defaults.setValue(true, forKey: "isLoggedIn")
        
        return updatedUser
        
    }
    
}

// MARK: - LoginViewDelegate
extension EditProfileViewController: EditProfileViewDelegate {
    func submitButtonPressed(sender: AnyObject) {
        //        self.loginView.endEditing(true)
        //        self.validator.validate(self)
        
        print("IMG_URL", self.img_url)
        
        if self.img_url != nil {
            params["image_url"] = self.img_url
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd" //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+4:00") //Current time zone
        let date = dateFormatter.date(from: self.editProfileView.birthdayUITextField.text!) //according to date format your date string
        print("date",date)
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        newDate =  dateFormatter.string(from: date!)
        print("newDate",newDate)
        print("self.editProfileView.birthdayUITextField.text!",self.editProfileView.birthdayUITextField.text!)
        
        //        let rome = Region(tz: TimeZoneName.asiaSingapore, cal: CalendarName.current, loc: )
        //
        //        let date1 = DateInRegion(string: self.editProfileView.birthdayUITextField.text!, format: .iso8601Auto, fromRegion: rome)!
        //
        //            print("date1",date1)
        
        params["first_name"] = self.editProfileView.firstNameUITextField.text
        params["last_name"] = self.editProfileView.lastNameUITextField.text
        params["email"] = user?.email
        params["mobile_number"] = self.editProfileView.mobileUITextField.text
        params["landline_number"] =  self.editProfileView.landlineUITextField.text
        params["birth_date"] = newDate
        
        print("PARAMS",params)
        SwiftSpinner.show("Please wait...")
        AccountService.update(params: params  , onCompletion: { statusCode, message in
            print("\(statusCode!)" + " EditProfileViewController"  )
            print("\(message!)" + " EditProfileViewController"  )
            SwiftSpinner.hide()
            if statusCode == 202 {
                
                let updatedDao = self.saveToLocal()
                
                NotificationCenter.default.post(name: Notification.Name(rawValue:"pass"), object: updatedDao , userInfo: nil)
                self.navigationController?.popViewController(animated: true)
                Utility.showSnackBAr(messege: message!, bgcolor: UIColor(hexString: Constants.color.greenSnackBar)!)
                
            } else  {
                Utility.showAlert(title: "Error " + "\(statusCode!)" , message: message!, targetController: self)
                
            }
            
        })
        
    }
}

extension EditProfileViewController: CZPickerViewDelegate, CZPickerViewDataSource {
    
    public func numberOfRows(in pickerView: CZPickerView!) -> Int {
        
        
        print("picker 2 count", pickerView.tag)
        return imageAction.count
        
        
        
    }
    
    func czpickerView(_ pickerView: CZPickerView!, imageForRow row: Int) -> UIImage! {
        
        
        return nil
    }
    
    func numberOfRowsInPickerView(pickerView: CZPickerView!) -> Int {
        
        
        
        print("picker 2 count", pickerView.tag)
        return imageAction.count
        
        
        
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        
        
        
        print("picker 2 count", pickerView.tag)
        return imageAction[row]
        
        
        
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int){
        
        
        
        actionSelected = imageAction[row]
        print(imageAction[row])
        
        if actionSelected == "Camera" {
            
            cameraFunction()
            
        }else if actionSelected == "Photos" {
            
            openLibrary()
            
        }else{
            
            
            
        }
        
        
        
        
    }
    
    func czpickerViewDidClickCancelButton(_ pickerView: CZPickerView!) {
        
    }
}
