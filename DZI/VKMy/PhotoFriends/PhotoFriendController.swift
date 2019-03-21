//
//  VKViewCell.swift
//  VKMy
//
//  Created by NadiaMorozova on 12.11.2018.
//  Copyright © 2018 NadiaMorozova. All rights reserved.


import UIKit
import Kingfisher
import RealmSwift

private let reuseIdentifier = "Cell"

class PhotoFriendController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
   
    var likes = 0
    //private let vkService = PhotoAllService()
    private let networkService = NetworkService()

    var realm: Realm?
    var notificationToken: NotificationToken?
    var friendPhoto: Results<VKPhotoAll>? = DataBaseService.get(VKPhotoAll.self, config:  Realm.Configuration(deleteRealmIfMigrationNeeded: true))
   // var friendPhoto: Results<VKPhotoAll>? = DataBaseService.get(VKPhotoAll.self)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        notificationToken = friendPhoto?.observe { [weak self] changes in
            guard let self = self else { return }
            switch changes {
            case .initial(_):
                self.collectionView.reloadData()
            case .update(_, let deletions, let insertions,  let modifications):
                print(deletions)
                print(insertions)
                print(modifications)
                self.collectionView.reloadData()
            case .error(let error):
                print(error.localizedDescription)
             
            }
        }
        collectionView.reloadData()
      
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.notificationToken = realm?.observe {(notification, realm) in
            print("\(notification.rawValue)")
            print(realm.objects(VKPhotoAll.self)[0].photo)
        }
        networkService.PhotoIdAlamofire() { [weak self] photos, error in
            guard let self = self, error == nil,
                let friendPhotos = photos else {
                    print(error!.localizedDescription); return }
            let realm = try? Realm()
            try? realm?.write {
                if self.friendPhoto != nil {
                    realm?.delete(self.friendPhoto!)
                    self.collectionView.reloadData()
                }
            }
         // self.friendPhoto = friendPhotos
            do {
                try DataBaseService.save(items: friendPhotos, update: true)
               // self.friendPhoto = realm?.objects(VKPhotoAll.self).filter("ANY lincUser")
            } catch {
                print(error)
                self.collectionView.reloadData()
           
           }
            let ph = VKPhotoAll()
            let photo = ph.lincUser
            for po in photo {

                print("\(po.photos)")

                 self.collectionView.reloadData()
           }
        }
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return names.count
        return friendPhoto?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoFriendCell", for: indexPath) as! PhotoFriendCell

        cell.photo.kf.setImage(with: URL(string: friendPhoto![indexPath.row].photo))
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? PhotoFriendCell {
                cell.photo.transform = .init(scaleX: 0.9, y: 0.9)

            }
        }
    }
    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? PhotoFriendCell {
                cell.photo.transform = .identity
                cell.contentView.backgroundColor = .clear

               // cell.likeCount.transform = .identity

            }
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
      //  notificationToken?.invalidate()
        
    }

}

