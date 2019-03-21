////
////  AllController.swift
////  VKMy
////
////  Created by NadiaMorozova on 12.11.2018.
////  Copyright © 2018 NadiaMorozova. All rights reserved.
////
//
import UIKit
import Alamofire
import Kingfisher
import RealmSwift

class AllGroupController: UITableViewController {
    var groupsDict = [String: Results<SearchGroups>]()
    var groupses: Results<SearchGroups>? = DataBaseService.get(SearchGroups.self, config: Realm.Configuration(deleteRealmIfMigrationNeeded: true))

    var realm: Realm?
    var allgroupService = [AllGroupService]()
    var allGroups = [SearchGroups]()
    var networkService = NetworkService()
    var searchController = UISearchController(searchResultsController: nil)
    var notificationToken: NotificationToken?
    var searchResult: Results<SearchGroups>? = try? Realm().objects(SearchGroups.self)
    var searchDict = [String: Results<SearchGroups>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchGroups()
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        if let textFieldInsideSearchBar = searchController.searchBar.getSubview(type: UITextField.self),
            let searchIconImageView = textFieldInsideSearchBar.leftView as? UIImageView {
            searchIconImageView.image = searchIconImageView.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            searchIconImageView.tintColor = UIColor.blue
        }
        if let textFieldInsideSearchBar = searchController.searchBar.getSubview(type: UITextField.self) {
            textFieldInsideSearchBar.layer.backgroundColor = UIColor.white.cgColor
            textFieldInsideSearchBar.layer.cornerRadius = 10.0
            tableView.reloadData()
        }
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllGroupCell", for: indexPath) as! AllGroupCell

        cell.configure(with: allGroups[indexPath.row])
        return cell
    }

    
    func searchGroups() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск групп..."
        searchController.searchBar.tintColor = .black
    }
    
}

extension AllGroupController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController ) {
        let searchText = searchController.searchBar.text!
        
            guard searchText == searchText, searchText != "" else { return }

            networkService.PhotoIdHaHaAlamofire(searchText: searchText, completion: { [weak self] (groups, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                guard let groups = groups, let self = self else { return }
                self.allGroups = groups
              //  print(groups.count)
                self.tableView.reloadData()
            })
        
    }
}

extension UIView {
    func getSubview<T>(type: T.Type) -> T? {
        let svs = subviews.flatMap { $0.subviews }
        let element = (svs.filter { $0 is T }).first
        return element as? T
    }
}









