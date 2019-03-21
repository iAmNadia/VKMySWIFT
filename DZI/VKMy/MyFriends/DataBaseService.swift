//
//  DataBaseService.swift
//  VKMy
//
//  Created by NadiaMorozova on 15.01.2019.
//  Copyright © 2019 NadiaMorozova. All rights reserved.
//

import RealmSwift

class DataBaseService {
    
    @discardableResult
    static func save<T: Object>(items: [T], config: Realm.Configuration = Realm.Configuration.defaultConfiguration, update: Bool = true) throws -> Realm {
        print(config.fileURL ?? "")
        let realm = try Realm(configuration: config)
        
        try realm.write {
            realm.add(items, update: true)
        }
        
        return realm
    }
    static func get<T: Object>(_ type: T.Type, config: Realm.Configuration = Realm.Configuration.defaultConfiguration) -> Results<T>? {
        let realm = try? Realm(configuration: config)
        
        return realm?.objects(type)
        
    }
    @discardableResult
    static func delete<T: Object>(items: [T], config: Realm.Configuration = Realm.Configuration.defaultConfiguration) throws -> Realm {
        // print(config.fileURL ?? "")
        let realm = try Realm(configuration: config)
        
        try realm.write {
            realm.delete(items)
        }
        
        return realm
    }
    static func getData<Element: Object>(type: Element.Type, config: Realm.Configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)) -> Results<Element>? {
        let realm = try? Realm(configuration: config)
        return realm?.objects(type)
    }
}
extension Results {
    
    func toArray() -> [Element] {
        return self.map{$0}
}
}
