    //
//  DataConnection.swift
//  demoweb
//
//  Created by mac book on 18/11/16.
//  Copyright © 2016 com.websoptimization.com. All rights reserved.
//

import UIKit
//import Alamofire

    protocol DataConectionDelegate{
    func returnDataDic(dataDic:NSMutableDictionary,req:NSMutableURLRequest)
}


class DataConnection: NSObject {
    
    var HUD : MBProgressHUD?
    var arr_Requests : NSMutableArray = NSMutableArray()
    var arr_HUD : NSMutableArray = NSMutableArray()
    var gMethod : GlobalMethods = GlobalMethods()
    var delegate : DataConectionDelegate?

    
//_■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  HUD hide-Show Method
//_■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

    // MARK: - HUD hide-Show Method
    func showHUD(){
        HUD = MBProgressHUD(view:(UIApplication.shared.delegate! as! AppDelegate).window!)
        (UIApplication.shared.delegate! as! AppDelegate).window?.addSubview(HUD!)
        HUD?.label.text = "Loading"
        HUD?.show(animated: true)
    }
    
    func hideHUD(){
        HUD?.hide(animated: true)
    }
    
//_■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  HUD hide-Show with Request Method
//_■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

   //MARK: - HUD hide-Show with Request Method
    func showHUDWithRequest(request:URLRequest){
            arr_Requests.add(request)
        if(arr_Requests.count <= 1){
            self.showHUD()
        }
    }
    
    func hideHUDWithRequest(request:URLRequest){
        let index = arr_Requests.index(of: request)
        arr_Requests.removeObject(at: index)
        if(arr_Requests.count <= 0){
            self.hideHUD()
        }
    }
    
    
    
    func rsHUDShow(){
        if(arr_HUD.count > 0){
            
        }else{
            self.showHUD()
        }
        arr_HUD.add("1")
    }
    
    func rsHUDHide(){
        arr_HUD.removeLastObject()
        if(arr_HUD.count == 0){
            self.hideHUD()
        }
    }
    
    

//_■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  DataConnection GET request
//_■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// MARK: - DataConnection POST request
    
    func reqPostWithParams(params:NSDictionary, action : String, arrImages : NSMutableArray, req:NSMutableURLRequest, arridenti : NSMutableArray) {
        
        let urlAPI = GlobalConstant.GlobalConstants.liveURL+action
        let urlPath = NSURL(string: urlAPI)
        
        var request = URLRequest(url: urlPath! as URL)
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        request.httpShouldHandleCookies = false
        request.timeoutInterval = 30
        request.httpMethod = "POST"
        
        if(Reachability.forInternetConnection().currentReachabilityStatus().rawValue == 0) {
            gMethod.showInternetConnectionAlert()
            // 27-10-17
        }
        else{
            
            let boundary = "---------------------------14737809831466499882746641449"
            let contentType = NSString.localizedStringWithFormat("multipart/form-data; boundary=%@", boundary)
            request.addValue(contentType as String, forHTTPHeaderField: "Content-Type")
            
             let bodys = NSMutableData()
             // //MARK: - Future Uncomment
            for (key,value) in params {
                let str1 = String.localizedStringWithFormat("--%@\r\n", boundary)
                let data1 = str1.data(using: String.Encoding.utf8)
                let str2 = String.localizedStringWithFormat("Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key as! String)
                let data2 = str2.data(using: String.Encoding.utf8)
                let str3 = String.localizedStringWithFormat("%@\r\n",params.object(forKey: key) as! String)
                let data3 = str3.data(using: String.Encoding.utf8)
                bodys.append(data1!)
                bodys.append(data2!)
                bodys.append(data3!)
            }

            let photos = "profile_pic"
            let photos2 = "cover_pic"
             if(arrImages.count>0){
                    for i in 0..<arrImages.count{
                        let img = arrImages.object(at: i)
                        
                        guard let imagedata = (img as! UIImage).jpegData(compressionQuality: 1.0)
                        else {
                            return
                        }
                        
                        //let photos = "Your Image Key"
                        if((imagedata) != nil){
                            let filename = String.localizedStringWithFormat("image%d.jpeg", i)
                            bodys.append(String.localizedStringWithFormat("--%@\r\n", boundary).data(using: String.Encoding.utf8)!)
                            
                            let strCheck = arridenti.object(at: i) as! String
                            
                            
                            if(strCheck == "profile"){
                                bodys.append(String.localizedStringWithFormat("Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",photos,filename ).data(using: String.Encoding.utf8)!)
                            }
                            else{
                                bodys.append(String.localizedStringWithFormat("Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",photos2,filename ).data(using: String.Encoding.utf8)!)
                            }
                            
                            bodys.append("Content-Type: image/jpeg\r\n\r\n".data(using: String.Encoding.utf8)!)
                            bodys.append(imagedata)
                            bodys.append(String.localizedStringWithFormat("\r\n").data(using: String.Encoding.utf8)!)
                        }
                    }
            }
            
            
             bodys.append(String.localizedStringWithFormat("--%@--\r\n",boundary).data(using: String.Encoding.utf8)!)
            request.httpBody = bodys as Data
            let strPostLength = String.localizedStringWithFormat("%lu", bodys.length)
            request.addValue(strPostLength, forHTTPHeaderField: "Content-Length")
            if(UserDefaults.standard.object(forKey: "sessionname") != nil){
                let strSession = UserDefaults.standard.object(forKey: "sessionname") as! String
                request.addValue(strSession, forHTTPHeaderField: "Cookie")
            }
            
            if(Reachability.forInternetConnection().currentReachabilityStatus().rawValue == 0) {
                gMethod.showInternetConnectionAlert()
                // 27-10-17
            }
            else{
                
                self.rsHUDShow()
                
                let task = URLSession.shared.dataTask(with: request) {
                    data, response, error in
                    
                    let index = self.arr_Requests.index(of: request)
                    if let data = data {
                        if let response = response as? HTTPURLResponse , 200...399 ~= response.statusCode {
                            //print(response)
                            let response = response
                            let json = try? JSONSerialization.jsonObject(with: data, options:.allowFragments) as! NSDictionary
                            
                            
                            print(json)
                            let dictMain = (json!.mutableCopy()) as? NSMutableDictionary
                            //DispatchQueue.main.async {
                                self.delegate?.returnDataDic(dataDic: dictMain!, req: req)
                           // }
                        }
                        else {
                                print(response as! HTTPURLResponse)
                        }
                    }else {
                        print("error=\(error!.localizedDescription)")
                    }
                    
                    DispatchQueue.main.async {
                       // self.hideHUDWithRequest(request: self.arr_Requests.object(at: index) as! URLRequest)
                        if(action == "ride/getRiderLatLng" || action == "gps/add"){
                        }
                        else{
                            self.rsHUDHide()
                        }
                    }
                }
                task.resume()
            }
         }
    }
    
    
    //MARK: - Dataconnection POST without image and simple parameter in dictionary
    func postRequestWithoutImage(params: NSMutableDictionary, action:String, req:NSMutableURLRequest){
        
        let urlAPI = GlobalConstant.GlobalConstants.liveURL+action
        guard let serviceUrl = URL(string: urlAPI) else { return }
        
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        
        
        if(Reachability.forInternetConnection().currentReachabilityStatus().rawValue == 0) {
            gMethod.showInternetConnectionAlert()
            // 27-10-17
        }
        else{
            self.showHUDWithRequest(request: request)
            
            session.dataTask(with: request) { (data, response, error) in
                
                
                let index = self.arr_Requests.index(of: request)
                
                if let response = response {
                    print(response)
                }
                
                if let data = data {
                    
                    DispatchQueue.main.async {
                        self.hideHUDWithRequest(request: self.arr_Requests.object(at: index) as! URLRequest)
                    }
                    
                    if let response = response as? HTTPURLResponse , 200...399 ~= response.statusCode {
                            do {
                                let json = try JSONSerialization.jsonObject(with: data, options: [])
                                 let dict : NSMutableDictionary = NSMutableDictionary()
                                dict.setValue(json, forKey: "data")
                                self.delegate?.returnDataDic(dataDic: dict, req: req)
                                
                            }
                            catch {
                                print(error)
                            }
                    }
                    else{
                        
                    }
                }
                else{
                    print("error=\(error!.localizedDescription)")
                }
                
                
                }.resume()
            
        }
    }
    
    
    

        
        
        
    
       
    
    
    
    
    
    //MARK: - Dataconnection POST without image
    func doRequestWithPosttt(params: NSDictionary, action:String, req:NSMutableURLRequest){
        
        let dataParameters = self.dataParams(params: params)
        //let session = URLSession.shared
        let urlAPI = GlobalConstant.GlobalConstants.liveURL+action
        let urlPath = NSURL(string: urlAPI)
        
        var request = URLRequest(url: urlPath! as URL)
        request.timeoutInterval = 60
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(self.contentLength(dataParameters), forHTTPHeaderField: "Content-Length")
        request.httpBody = dataParameters
        request.httpMethod = "POST"
        
        if(Reachability.forInternetConnection().currentReachabilityStatus().rawValue == 0) {
            gMethod.showInternetConnectionAlert()
            // 27-10-17
        }
        else{
            self.showHUDWithRequest(request: request)
            let task = URLSession.shared.dataTask(with: request) {
                data, response, error in
                
                let index = self.arr_Requests.index(of: request)
                if let data = data {
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.hideHUDWithRequest(request: self.arr_Requests.object(at: index) as! URLRequest)
                    })
                    
                    if let response = response as? HTTPURLResponse , 200...399 ~= response.statusCode {
                        print("Status Code",response.statusCode)
                        //  let json = try? JSONSerialization.jsonObject(with: data, options:[])
                        let json = try? JSONSerialization.jsonObject(with: data, options:.allowFragments) as AnyObject
                        //print(json)
                        let dict : NSMutableDictionary = NSMutableDictionary()
                        dict.setValue(json, forKey: "data")
                        self.delegate?.returnDataDic(dataDic: dict, req: req)
                        
                        //let dict : NSMutableDictionary = NSMutableDictionary(dictionary: json!)
                        //
//                        if(dict.object(forKey: "status_code") as! String == "1"){
//                            self.delegate?.returnDataDic(dataDic: dict, req: req)
//                        }
//                        else{
//                            DispatchQueue.main.async {
//                                self.gMethod.makeToast(message: dict.object(forKey: "message") as! String)
//                            }
//                        }
                    }
                    else {
                        
                    }
                }else {
                    print("error=\(error!.localizedDescription)")
                }
                
//                DispatchQueue.main.async(execute: {() -> Void in
//                    self.hideHUDWithRequest(request: self.arr_Requests.object(at: index) as! URLRequest)
//                })
            }
            task.resume()
        }
  }
    
    
    
    //MARK: - Simply GET request
    func simplyGETRequest(action:String,req:NSMutableURLRequest){
        
        var request = URLRequest(url: URL(string: GlobalConstant.GlobalConstants.liveURL+action)!)
        request.httpMethod = "GET"
        if(UserDefaults.standard.object(forKey: "sessionname") != nil){
            let strSession = UserDefaults.standard.object(forKey: "sessionname") as! String
            request.addValue(strSession, forHTTPHeaderField: "Cookie")
        }
        
        let session = URLSession.shared
        let sessionConfiguration = URLSessionConfiguration.background(withIdentifier: "mustdone")
        sessionConfiguration.sessionSendsLaunchEvents = true
        sessionConfiguration.isDiscretionary = true
        
        if(Reachability.forInternetConnection().currentReachabilityStatus().rawValue == 0) {
            gMethod.showInternetConnectionAlert()
            // 27-10-17
        }else{
            
        }
        
        
        
        
        
        self.showHUDWithRequest(request: request)
        
        session.dataTask(with: request) {data, response, err in
            print("Entered the completionHandler")
            let index = self.arr_Requests.index(of: request)
            
            if let data = data {
                if let response = response as? HTTPURLResponse , 200...399 ~= response.statusCode {
                    let response = response
                    print("Status Code",response.statusCode)
                    
                    let json = try? JSONSerialization.jsonObject(with: data, options:.allowFragments)
                    let dictMain = NSMutableDictionary()
                    dictMain.setValue(json, forKey: "dataMain")
                    //let dictMain = (json!.mutableCopy()) as? NSMutableDictionary
                    DispatchQueue.main.async(execute: {() -> Void in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                            self.hideHUDWithRequest(request: self.arr_Requests.object(at: index) as! URLRequest)
                            self.delegate?.returnDataDic(dataDic: dictMain, req: req)
                        }
                        
                    })
                 }
                else {
                    //print(response as? HTTPURLResponse)
                    print(response as! HTTPURLResponse)
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.hideHUDWithRequest(request: self.arr_Requests.object(at: index) as! URLRequest)
                    })
                }
            }else {
                print("error=\(err!.localizedDescription)")
                DispatchQueue.main.async(execute: {() -> Void in
                    self.hideHUDWithRequest(request: self.arr_Requests.object(at: index) as! URLRequest)
                })
            }
            
            
            }.resume()
    }
    
    
    
    
    
    
    
     // MARK: - DataConnection GET request
     func doRequestGet(params:NSDictionary, action : String, req:NSMutableURLRequest){
        let dataParameters = self.dataParams(params: params)
        
         let url1 = URL(string: GlobalConstant.GlobalConstants.liveURL+action)
         var request = URLRequest(url: url1!)
        
        request.timeoutInterval = 60
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(self.contentLength(dataParameters), forHTTPHeaderField: "Content-Length")
        request.httpBody = dataParameters
        request.httpMethod = "GET"
        
        
        if(Reachability.forInternetConnection().currentReachabilityStatus().rawValue == 0) {
                gMethod.showInternetConnectionAlert()
          
        }
        else{
        
            self.showHUDWithRequest(request: request)
            
              let task = URLSession.shared.dataTask(with: request) {
                    data, response, error in
                    
                    let index = self.arr_Requests.index(of: request)
                    
                    if let data = data {
                        
                        if let response = response as? HTTPURLResponse , 200...399 ~= response.statusCode {
                            
                             let response = response
                             let json = try? JSONSerialization.jsonObject(with: data, options:.allowFragments)
                             let dict_response = NSMutableDictionary()
                             dict_response.setValue(json, forKey: "data")
                            
                            self.delegate?.returnDataDic(dataDic: dict_response, req: req)
                        }
                        else {
                            
                        }
                    }
                    else {
                        print("error=\(error!.localizedDescription)")
                    }
                    
                   DispatchQueue.main.async(execute: {() -> Void in
                        self.hideHUDWithRequest(request: self.arr_Requests.object(at: index) as! URLRequest)
                    })
                }
                task.resume()
            }
       }
   
    func contentLength(_ dataParam: Data) -> String {
        return "\(UInt(dataParam.count))"
    }
    
    func strUrl(_ function: String) -> String {
        return "https://jsonplaceholder.typicode.com/\(function)"
    }
    
    func dataParams(params: NSDictionary) -> Data {
        
        let arr_Params = [Any]()
        
// //MARK: - Future uncomment
//         for (key,value) in params {
//            let set = CharacterSet.urlQueryAllowed
//            let str_Value = (params[key] as! String).addingPercentEncoding(withAllowedCharacters: set)!
//            let str_Key = (key as AnyObject).addingPercentEncoding(withAllowedCharacters: set)!
//            
//            arr_Params.append("\(str_Key)=\(str_Value)")
//        }
        
        let str_Params = (arr_Params as NSArray).componentsJoined(by: "&")
        return str_Params.data(using: String.Encoding.utf8)!
    }
}

//_■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  DataConnection POST request
//_■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
 //MARK: - DataConnection POST request




//        for key in params{
//            let set = CharacterSet.urlQueryAllowed
//            let strkey = key as! String
//            let str_Value = strkey.addingPercentEncoding(withAllowedCharacters: set)
//                //(params[key] as! String).addingPercentEncoding(withAllowedCharacters: set)!
//            arr_Params.append("\(key)=\(str_Value)")
//        }





// let jsoon = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSMutableDictionary
//let json = try ? JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? [String : AnyObject]
//let jsonString = String(bytes: data, encoding: String.Encoding.utf8)


// //MARK: - Future Uncomment
//            for (key,value) in params {
//
//                let str1 = String.localizedStringWithFormat("--%@\r\n", boundary)
//                let data1 = str1.data(using: String.Encoding.utf8)
//
//                let str2 = String.localizedStringWithFormat("Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key as! String)
//                let data2 = str2.data(using: String.Encoding.utf8)
//
//                let str3 = String.localizedStringWithFormat("%@\r\n",params.object(forKey: key) as! String)
//                let data3 = str3.data(using: String.Encoding.utf8)
//
//                bodys.append(data1!)
//                bodys.append(data2!)
//                bodys.append(data3!)
//            }

    
    
    
    
    
    
    //MARK: - Simply GET
    //                    if(json is NSDictionary) {
    //
    //                        let json2 = json as! NSDictionary
    //                        let dict : NSMutableDictionary = NSMutableDictionary()
    //                        dict.setValue(json2.mutableCopy() as! NSMutableDictionary, forKey: "data")
    //                       // self.delegate?.returnDataDic(dataDic: dict, req: req)
    //                    }else{
    //
    //                        let json2 = json as! NSArray
    //                        let dict : NSMutableDictionary = NSMutableDictionary()
    //                        dict.setValue(json2.mutableCopy() as! NSMutableArray, forKey: "data")
    //                        //self.delegate?.returnDataDic(dataDic: dict, req: req)
    //                    }
