//
//  ViewController.swift
//  First demo
//
//  Created by iOS Dev on 11/29/18.
//  Copyright © 2018 Webs Optimization. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    @IBOutlet weak var tblHotel: UITableView!
    var methodStart:Any!
    var methodFinish:Any!
    var employees = [Employee]()
    var albums = [Album]()
    var dataCon:DataConnection!
    var reqData:NSMutableURLRequest!
    var arrData:NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let methodStart = Date()
        arrData = NSMutableArray()
        
        let methodFinish = Date()
        let executionTime = methodFinish.timeIntervalSince(methodStart)
        print("Execution time: \(executionTime)")
        
        self.callGetEmployeeData()
        tblHotel.tableFooterView = UIView()
    }
}



// MARK:- DataConnection Delegate
extension ViewController: DataConectionDelegate {
    func callGetEmployeeData(){
        dataCon = DataConnection()
        dataCon.delegate = self
        reqData = NSMutableURLRequest()
        reqData.addValue("GetEmployeeList", forHTTPHeaderField: "Elistdata")
        dataCon.simplyGETRequest(action: "photos", req: reqData)
    }
    
    func returnDataDic(dataDic: NSMutableDictionary, req: NSMutableURLRequest) {
        if(req == reqData){
            let empData =   dataDic["dataMain"] as! NSArray
            //employees = self.getEmployeeFromArr(empArr: empData)
            albums = self.ReturnAlbumFromArr(empArr: empData)
            //arrData = (empData.mutableCopy() as! NSMutableArray)
            tblHotel.reloadData()
        }
    }
}

// MARK:- DataBindingToModel
extension ViewController {
    
    func getEmployeeFromArr(empArr: NSArray) -> [Employee] {
        var emp = [Employee]()
        for index in 0..<empArr.count {
            let employee = empArr.object(at: index) as! NSDictionary
            let thisEmp = Employee(name: (employee.object(forKey: "name") as! String), email: (employee.object(forKey: "email") as! String), website: (employee.object(forKey: "website") as! String), phone: (employee.object(forKey: "phone") as! String))
            emp.append(thisEmp)
        }
        return emp
    }
    
    func ReturnAlbumFromArr(empArr: NSArray) -> [Album] {
        var emp = [Album]()
        for index in 0..<empArr.count {
            let employeedd = empArr.object(at: index) as! NSDictionary
            let strtitle = (employeedd.object(forKey: "title") as! String)
            let strurl = (employeedd.object(forKey: "url") as! String)
            let strThumb = (employeedd.object(forKey: "thumbnailUrl") as! String)
            
            let thisEmp = Album(title: strtitle, url: strurl, thumbUrl: strThumb)
                
            emp.append(thisEmp)
        }
        return emp
    }
}


// MARK:- UITableViewDataSource
extension ViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return arrData.count
        return albums.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let singleHotel = self.albums[indexPath.row]
        //let singleHotel = arrData.object(at: indexPath.row) as! NSDictionary
        
        let lblName = (cell.viewWithTag(1)! as! UILabel)
        let imgL = (cell.viewWithTag(2)! as! UIImageView)
        
        //let url = URL(string: singleHotel.url!)
        //let data = try? Data(contentsOf: url!)
        
        //    imgL.image = UIImage(data: data!)
        //lblName.text = singleHotel.object(forKey: "title") as! String
        lblName.text = singleHotel.title
          //  imgL.kf.setImage(with: url)
        
        
        return cell
    }
    
    
    
    
    
    
    
    
    
    
    
    
}


