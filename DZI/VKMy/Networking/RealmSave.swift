//
//  RealmSave.swift
//  VKMy
//
//  Created by NadiaMorozova on 06.02.2019.
//  Copyright © 2019 NadiaMorozova. All rights reserved.
//

import Foundation
import RealmSwift

class RealmSave {
    
    static func saveFriendData(_user: [User]) {
        DispatchQueue.global().async {
            do{
                let realm = try Realm()
                let oldFriendData = realm.objects(User.self)
                realm.beginWrite()
                realm.delete(oldFriendData)
                realm.add(_user)
                try realm.commitWrite()
                print (" Ваша БД: ", realm.configuration.fileURL as Any)
            } catch {
                print(error)
            }
        }
    }
    
    static func saveGroupsList(_ groups: [Group]) {
        DispatchQueue.global().async {
            do {
                let realm = try Realm()
                let oldGroups = realm.objects(Group.self)
                realm.beginWrite()
                realm.delete(oldGroups)
                realm.add(groups)
                try realm.commitWrite()
            } catch {
                print(error)
            }
        }
    }
    
    static func savePhotos(_ photos: [VKPhotoAll]) {
        DispatchQueue.global().async {
            do {
                let realm = try Realm()
                let oldPhotos = realm.objects(VKPhotoAll.self)
                realm.beginWrite()
                realm.delete(oldPhotos)
                realm.add(photos)
                try realm.commitWrite()
            } catch {
                print(error)
            }
        }
    }
    
    static func saveFeed(_ news: [News]) {
        DispatchQueue.global().async {
            do {
                let realm = try Realm()
                let oldNews = realm.objects(News.self)
                realm.beginWrite()
                realm.delete(oldNews)
                realm.add(news)
                try realm.commitWrite()
            } catch {
                print(error)
            }
        }
    }
}
class RealmProvider {
    
    static var config: Realm.Configuration {
        
        return Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    }
    
    static func saveToRealm<T: Object> (items: [T], update: Bool = true) {
        do {
            let realm = try Realm(configuration: RealmProvider.config)
            try realm.write {
                realm.add(items, update: update)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func loadFromRealm<T: Object> (_ type: T.Type, in realm: Realm = try! Realm(configuration: RealmProvider.config)) -> Results<T> {
        print(realm.configuration.fileURL!)
        return realm.objects(type)
    }
}

