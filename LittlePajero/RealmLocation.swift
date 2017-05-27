//
//  Location.swift
//  LittlePajero
//
//  Created by ivyxuan on 2017/5/12.
//  Copyright © 2017年 ivyxuan. All rights reserved.
//

import Foundation
import RealmSwift

class RealmLocation: Object {
    dynamic var id: Int = 1
    dynamic var latitude: Double = 0.00
    dynamic var longitude: Double = 0.00
    
    let ownerPath = LinkingObjects(fromType: RealmPath.self, property: "locations")
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    //Incrementa ID
    class func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(RealmLocation.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
