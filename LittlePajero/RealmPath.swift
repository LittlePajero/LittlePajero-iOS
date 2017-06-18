//
//  Path.swift
//  LittlePajero
//
//  Created by ivyxuan on 2017/5/12.
//  Copyright © 2017年 ivyxuan. All rights reserved.
//

import Foundation
import RealmSwift
import Mapbox

class RealmPath: Object {
    dynamic var id: Int = 1
    var locations = List<RealmLocation>()
    var points = List<RealmPoint>()
    dynamic var rank: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
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
