//
//  Path.swift
//  LittlePajero
//
//  Created by ivyxuan on 2017/5/12.
//  Copyright © 2017年 ivyxuan. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

class Path: Object, Mappable {
    var locations = List<Location>()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        locations    <- (map["locations"], ListTransform<Location>())
    }
}
