
//  VKMy
//
//  Created by NadiaMorozova on 22.11.2018.
//  Copyright © 2018 NadiaMorozova. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class NewsViewController: UICollectionViewController {
    
    private var posts: Results<News>?
    private var profiless: Results<User>?
    private var groups: Results<Group>?
    private var photo: Results<VKPhotoAll>?
    private var networkService = NewsService()
    var notificationToken: NotificationToken?
    
    let refreshControl = UIRefreshControl()
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy  HH:mm"
        return df
    }()
    var dateTextCache: [IndexPath: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl.addTarget(self, action: #selector(NewsViewController.refreshNews), for: UIControl.Event.valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Update News", attributes: nil)
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = self.refreshControl
        } else {
            collectionView.addSubview(self.refreshControl)
        }
        
        refreshNews()
        LoadNews()

    }
    func LoadNews() {
        posts = RealmProvider.loadFromRealm(News.self)
        profiless = RealmProvider.loadFromRealm(User.self)
        groups = RealmProvider.loadFromRealm(Group.self)
        
        networkService.getPosts { (posts, profiles, groups, error) in
            DispatchQueue.main.async {
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let posts = posts, let profiles = profiles, let groups = groups else { return }
                
                do {
                    let realm = try Realm(configuration: RealmProvider.config)
                    
                    try realm.write {
                        realm.delete(RealmProvider.loadFromRealm(News.self))
                        realm.add(posts)
                        
                        realm.delete(RealmProvider.loadFromRealm(User.self))
                        realm.add(profiles)
                        
                        realm.delete(RealmProvider.loadFromRealm(Group.self))
                        realm.add(groups)
                        
                    }
                } catch {
                    print(error.localizedDescription)
                    
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        notificationToken = self.posts?.observe { (change) in
            switch change {
            case .initial(_):
                self.collectionView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                self.collectionView.makeChanges(deletions: deletions, insertions: insertions, modifications: modifications)
                
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts?.count ?? 0
        
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCell", for: indexPath) as? NewsCell else { fatalError() }
           // else { return UICollectionViewCell() }

        guard let posts = posts, let profiles = profiless, let groups = self.groups else { return UICollectionViewCell() }
        let post = posts[indexPath.row]
        cell.textNews.needsUpdateConstraints()
        cell.textNews.sizeToFit()
        cell.dataAdd.text = getCellDateText(forIndexPath: indexPath, andTimestamp: post.date)
        if post.sourceId > 0 {

            guard let profile = profiles.filter("id = %@", post.sourceId).first else { return UICollectionViewCell() }

            cell.user.kf.setImage(with: URL(string: profile.imageString))
            cell.userName.text = profile.author

        } else {
            guard let group = groups.filter("id = %@", -post.sourceId).first else { return UICollectionViewCell() }

            cell.configPhotoGoup(with: group)
            cell.configPhotoNews(with: post)
        }
     cell.configPhotoNews(with: posts[indexPath.row])

        return cell
    }
    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextNewsCell", for: indexPath) as? TextNewsCell
//        else { fatalError() }
//
//        let post = posts?[indexPath.row]
//        cell.configure(with: post!)
//
//       // return cell.convert(UITableViewCell, to: UICollectionViewCell)
//    }
    
    func getCellDateText(forIndexPath indexPath: IndexPath, andTimestamp timestamp: Double) -> String {
        if let stringDate = dateTextCache[indexPath] {
            return stringDate
        } else {
            let date = Date(timeIntervalSince1970: timestamp)
            let stringDate = dateFormatter.string(from: date)
            dateTextCache[indexPath]  = stringDate
            
            return stringDate
        }
    }
   
    @objc func refreshNews() {
        // функционал обновления новостей
        //
        
        collectionView.reloadData()
        refreshControl.endRefreshing()
        LoadNews()
    }
}
//extension NewsViewController: UICollectionViewDataSourcePrefetching {
//    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        let rows = Set(indexPaths.map { $0.row })
//        if rows.contains((posts?.count)!-1) {
//            print("NNNews")
//        }
//    }
//    
//}
extension UICollectionView {
    func makeChanges(deletions: [Int], insertions: [Int], modifications: [Int]) {
        performBatchUpdates({
            deleteItems(at: deletions.map(IndexPath.fromRow))
            insertItems(at: insertions.map(IndexPath.fromRow))
            reloadItems(at: modifications.map(IndexPath.fromRow))
        }, completion: nil)
    }
}
