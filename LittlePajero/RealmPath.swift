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

class RealmPath: Object, Mappable {
    dynamic var id: Int = 1
    var locations = List<RealmLocation>()
    var points = List<RealmPoint>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id           <- map["id"]
        locations    <- (map["locations"], ListTransform<RealmLocation>())
    }
    
    //Incrementa ID
    class func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(RealmPath.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    func transformToJSON() -> [(Float, Float)] {
        var data : [(Float, Float)] = []
        for location in self.locations {
            data.append((location.latitude, location.longitude))
        }
        return data
    }
}
