//
//  Album.swift
//  First demo
//
//  Created by rushi trivedi on 1/9/19.
//  Copyright © 2019 Webs Optimization. All rights reserved.
//

import Foundation

class Album {
    
    var title:String?
    var url:String?
    var thumbUrl:String?
    
    init(title:String?,url:String?,thumbUrl:String?) {
        if let Title = title, let Url = url, let ThumbUrl = thumbUrl {
            self.title = Title
            self.url = Url
            self.thumbUrl = ThumbUrl
        }
    }
}
