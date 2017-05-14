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

class Point: Object {
    dynamic var id: Int = 0
    dynamic var latitude: Float = 0.0
    dynamic var longitude: Float = 0.0
    
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
    func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(Point.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
