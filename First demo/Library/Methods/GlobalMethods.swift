//
//  GlobalMethods.swift
//  Chandlo
//
//  Created by Dev 2 on 14/07/16.
//  Copyright © 2016 Kalp Corporate. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation
import Contacts

protocol getLocationDelegate{
    func returnLocationInfo(Address:String,lat:String,long:String,country:String)
}


class GlobalMethods: NSObject,CLLocationManagerDelegate {

    var cl_Location : CLLocation = CLLocation()
    var lat : CLLocationDegrees!
    var longi : CLLocationDegrees!
    var delegate : getLocationDelegate?
    var strTxtSpeech : String!
    var locMG:CLLocationManager = CLLocationManager()
    
    
    func SetOpacityLayoutForTextfield(textfield : UITextField,string:NSString){
        textfield.layer.borderColor = UIColor.lightGray.cgColor
        textfield.layer.borderWidth = 1.0
        textfield.layer.cornerRadius = 5.0
    }
    
   
    
    
    
    
    func SetOpacityLayoutForButton(button : UIButton){
        button.layer.cornerRadius = 5.0
        button.layer.opacity = 2.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.white.cgColor
    }
    
    func SetUnderLine(textfield : UITextField){
        
        let border = CALayer()
        let borderWidth : CGFloat = 2.0
        border.borderColor = UIColor.black.cgColor
        
        border.frame = CGRect(x: 0, y: textfield.frame.size.height - borderWidth, width: textfield.frame.size.width, height: textfield.frame.size.height)
        
        border.borderWidth = borderWidth;
        textfield.layer.addSublayer(border)
        textfield.layer.masksToBounds = true
    }
    
    func keyboardDidHide(view : UIView){
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 10.0, options: .curveEaseIn, animations: {
            //view.frame = CGRectMake(0,  0, view.frame.size.width,view.frame.size.height)
            view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
            })
        { (true) in
            //
        }
    }
    
    func keyboardDidShow(view : UIView){
        UIView.animate(withDuration: 0.5, delay: 0.0,usingSpringWithDamping: 1.0, initialSpringVelocity: 10.0, options: .curveEaseIn, animations: {
            
            //view.frame = CGRectMake(0, -120, view.frame.size.width,view.frame.size.height)
            view.frame = CGRect(x: 0, y: -180, width: view.frame.size.width, height: view.frame.size.height)
        })
        {
            (true) in
        }
    }
    
    
    
    func keyboardDidHidepro(view : UIView){
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 10.0, options: .curveEaseIn, animations: {
            //view.frame = CGRectMake(0,  0, view.frame.size.width,view.frame.size.height)
            view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        })
        { (true) in
            //
        }
    }
    
    func keyboardDidShowpro(view : UIView){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0.0,usingSpringWithDamping: 1.0, initialSpringVelocity: 10.0, options: .curveEaseIn, animations: {
            
                //view.frame = CGRectMake(0, -120, view.frame.size.width,view.frame.size.height)
                view.frame = CGRect(x: 0, y: -200, width: view.frame.size.width, height: view.frame.size.height)
            })
            {
                (true) in
            }
        }
    }

    
    
    func showAlertMessage(vc:UIViewController,message:String){
        let alert = UIAlertController(title: "Biker", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            vc.present(alert, animated: true, completion: nil)
    }
    
    
    func showInternetConnectionAlert(){
        let alertController = UIAlertController(title: "Internet Required", message: "Internet Connection is not available", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
            //print("OK")
        }
        alertController.addAction(okAction)
        
        
        var topController = UIApplication.shared.keyWindow!.rootViewController!
        
        while ((topController.presentedViewController) != nil) {
            topController = topController.presentedViewController!
        }
        topController.present(alertController, animated: true, completion: nil)
  }
    
    func makeToast(message : String){
        //let hud = MBProgressHUD.showAdded(to: (self.navigationController?.view)!, animated: true)
        let hud = MBProgressHUD.showAdded(to: (UIApplication.shared.delegate! as! AppDelegate).window!, animated: true)
        hud.mode = MBProgressHUDMode.text
        hud.label.text = message
        hud.margin = 20.0
        hud.offset.y = 150
        hud.label.textColor = UIColor.white
        hud.bezelView.backgroundColor = UIColor.black
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: 3.0)
    }
    
   
    
    
    func imageCompressormethod(imageee : UIImage)->UIImage {
        
        let rect = CGRect(x: 0, y: 0, width:imageee.size.width/6  , height: imageee.size.height/6)
        UIGraphicsBeginImageContext(rect.size)
        imageee.draw(in: rect)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let compressedImageData = resizedImage?.jpegData(compressionQuality: 0.1)
        
        let imageso = UIImage(data: compressedImageData!)
        
        return imageso!
    }
    
    func textToSpeech(strSpeechText: String){
        
        let synthesizer = AVSpeechSynthesizer()
        let utterrance = AVSpeechUtterance(string: strTxtSpeech)
        utterrance.rate = 0.2
        utterrance.voice = AVSpeechSynthesisVoice(language: "en-EN")
        synthesizer.speak(utterrance)
    }
    
    func startLocationManager(){
        
        DispatchQueue.main.async {
            self.locMG.distanceFilter = kCLDistanceFilterNone
            self.locMG.desiredAccuracy = kCLLocationAccuracyBest
            self.locMG.delegate = self
            self.locMG.requestWhenInUseAuthorization()
            self.locMG.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    


    func shouldEmailValidate(value:String)->Bool{
     
        return true
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        manager.stopUpdatingLocation()
        let newLocation = locations.first
        print("This many times called")
        print(newLocation!)
            lat = newLocation?.coordinate.latitude
            longi = newLocation?.coordinate.longitude
            let strLat = String(lat)
            let strLong = String(longi)
            let geocoder = CLGeocoder()
        
            geocoder.reverseGeocodeLocation(newLocation!) { (placemarksArray, error) in
                if (placemarksArray?.count)! > 0 {
                    let place = placemarksArray?.first
                    let dictData:NSMutableArray = (place!.addressDictionary as! NSMutableDictionary).object(forKey: "FormattedAddressLines") as! NSMutableArray
                    var address:String=""
                    let country:String = (place?.country)!
                    for  i in 0..<dictData.count{
                        if(address.characters.count>0){
                            address = String.localizedStringWithFormat("%@ %@",address,dictData.object(at: i) as! String)
                        }else{
                            address = String.localizedStringWithFormat("%@,",dictData.object(at: i) as! String)
                        }
                    }
                    self.delegate?.returnLocationInfo(Address:address , lat:strLat , long:strLong , country:country)
                }
            }
    }
}






extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }}





extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
