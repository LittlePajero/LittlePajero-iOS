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

class RealmLocation: Object, Mappable {
    dynamic var id: Int = 1
    dynamic var latitude: Float = 0.00
    dynamic var longitude: Float = 0.00
    
    let ownerPath = LinkingObjects(fromType: RealmPath.self, property: "locations")
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        latitude     <- map["latitude"]
        longitude    <- map["longitude"]
    }
    
    //Incrementa ID
    class func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(RealmLocation.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
