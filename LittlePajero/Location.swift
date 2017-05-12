//
//  Location.swift
//  LittlePajero
//
//  Created by ivyxuan on 2017/5/12.
//  Copyright © 2017年 ivyxuan. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

class Location: Object, Mappable {
    dynamic var latitude: Float = 0.00
    dynamic var longitude: Float = 0.00
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        latitude     <- map["latitude"]
        longitude    <- map["longitude"]
    }
}
