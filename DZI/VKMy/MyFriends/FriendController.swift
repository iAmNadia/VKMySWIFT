//
//  MyController.swift
//  VKMy
//
//  Created by NadiaMorozova on 12.11.2018.
//  Copyright © 2018 NadiaMorozova. All rights reserved.
//


import UIKit
import Alamofire
import Kingfisher
import RealmSwift

class FriendController: UITableViewController, UISearchResultsUpdating {
    
    var searchController: UISearchController!
    var photoFriend: PhotoFriendController?
    
    private let networkService = NetworkService()
    var friends: Results<User>? = DataBaseService.get(User.self, config: Realm.Configuration(deleteRealmIfMigrationNeeded: true))
    var notificationToken: NotificationToken?
    let session = Session.shared
    
    var filteredFriend = [User]()
    // var photoFr = [PhotoFriendController]()
    
    // let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    // lazy var myFriends: Results<User>? = try? Realm(configuration: self.config).objects(User.self)
    
    
    var searchResult: Results<User>? = try? Realm().objects(User.self)
    var friendsDict = [String: Results<User>]()//словарь по первой букве фамилии
    var friendsSectionsTitles = [String]()
    
    
    //    private var user: Results<User>? = try?
    //        Realm().objects(User.self)
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        
        notificationToken = friends?.observe { [weak self] changes in
            guard let self = self else { return }
            switch changes {
            case .initial(_):
                // print(changes)
                self.createFriendsDict()
                self.createfriendsSectionsTitles()
                self.tableView.reloadData()
            case .update(_, let deletions, let insertions,  let modifications):
                print(deletions)
                print(insertions)
                print(modifications)
                self.createFriendsDict()
                self.createfriendsSectionsTitles()
                // self.tableView.applyChanges(deletions: deletions, insertions: insertions, updates: modifications)
                self.tableView.reloadData()
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        networkService.fetch { (users: [User]?, error: Error?) in
            
            guard error == nil,
                let users = users else { print(error!.localizedDescription); return }
            do {
                try DataBaseService.save(items: users, update: true)
            } catch {
                print(error)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return friendsSectionsTitles.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return user?.count ?? 0
        let friendKey = friendsSectionsTitles[section]
        if let friendValues = friendsDict[friendKey] {
            return friendValues.count
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return friendsSectionsTitles[section]
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
        
        let friendKey = friendsSectionsTitles[indexPath.section]
        
        if let friend = friendsDict[friendKey]?[indexPath.row] {
            cell.configure(with: friend)
        }
        return cell
        
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive {
            return false
        } else {
            return true
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(searchText: searchText)
        } else {
            self.searchResult = try? Realm().objects(User.self)
        }
    }
    
    func filterContent(searchText: String) {
        if searchText.isEmpty {
            self.searchResult = try? Realm().objects(User.self)
            self.createFriendsDict()
            self.createfriendsSectionsTitles()
            self.tableView.reloadData()
            return
        }
        
        self.searchResult = try? Realm().objects(User.self).filter("firstName CONTAINS[cd] %@ OR surName CONTAINS[cd] %@", searchText, searchText)
        self.createFriendsDict()
        self.createfriendsSectionsTitles()
        self.tableView.reloadData()
    }
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return friendsSectionsTitles
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let indexPath = tableView.indexPathForSelectedRow {

            let vc = segue.destination as! PhotoFriendController
            let friendKey = friendsSectionsTitles[indexPath.section]
            let friendValues = friendsDict[friendKey]

            vc.title = friendValues?[indexPath.row].surName

            session.friendId = friendValues?[indexPath.row].id ?? 0

        }
    }
    
    //функция создания словаря ключ - первая буква фамилии, значение - массив друзей
    func createFriendsDict() {
        guard let searchResult = self.searchResult else {
            self.friendsDict = [:]
            return
        }
        
        self.friendsDict = [:]
        searchResult.forEach { friend in
            guard let letter = friend.surName.first,
                self.friendsDict[String(letter)] == nil else { return }
            
            self.friendsDict[String(letter)] = searchResult.filter("surName BEGINSWITH[cd] %@", String(letter))
        }
    }
    
    // создание отсортированного массива из первых букв фамилии друга
    func createfriendsSectionsTitles() {
        friendsSectionsTitles = [String](friendsDict.keys).sorted()
    }
    
    // меняем высоту header
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    // кастомизация header
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.textColor = UIColor.black
        headerView.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        headerView.alpha = 0.5
    }
}



