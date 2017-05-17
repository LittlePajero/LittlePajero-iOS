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
import Mapbox

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
    
    func coordinates() -> [CLLocationCoordinate2D] {
        var data : [(Double, Double)] = []
        for location in self.locations {
            data.append((location.longitude, location.latitude))
        }
        return data.map({CLLocationCoordinate2D(latitude: $0.1, longitude: $0.0)})
    }
}
