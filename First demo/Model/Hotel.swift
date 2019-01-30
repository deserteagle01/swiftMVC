//
//  Hotel.swift
//  First demo
//
//  Created by rushi trivedi on 1/9/19.
//  Copyright © 2019 Webs Optimization. All rights reserved.
//

import Foundation

class Employee {
    
    var name:String?
    var email:String?
    var website:String?
    var phone:String?
    
    init(name:String?,email:String?,website:String?, phone:String? ) {
        if let names = name, let Email = email, let webs = website, let phuone = phone {
            self.name = name
            self.email = Email
            self.website = webs
            self.phone = phuone
        }
    }
    
}
