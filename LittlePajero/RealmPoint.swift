//
//  Point.swift
//  LittlePajero
//
//  Created by ivyxuan on 2017/5/13.
//  Copyright © 2017年 ivyxuan. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

class RealmPoint: Object {
    dynamic var id: Int = 1
    dynamic var latitude: Float = 0.0
    dynamic var longitude: Float = 0.0
    
    let owners = LinkingObjects(fromType: RealmPath.self, property: "points")
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int, latitude: Float, longitude: Float) {
        self.init()
        
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
    }
    
    //Incrementa ID
    class func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(RealmPoint.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
