////
////  AllGropps.swift
////  VKMy
////
////  Created by NadiaMorozova on 06.02.2019.
////  Copyright © 2019 NadiaMorozova. All rights reserved.
////
//
//import Foundation
//import UIKit
//import Kingfisher
//import RealmSwift
//
//class AllGroups: UITableViewController {
//    var groupses: Results<SearchGroups>? = DataBaseService.get(SearchGroups.self, config: Realm.Configuration(deleteRealmIfMigrationNeeded: true))
//    var allGroups = [Group]()
//    var searchRequest = NetworkService()
//    var searchController = UISearchController(searchResultsController: nil)
//    var newGroup = [String]()
//   
//     var searchResult: Results<SearchGroups>? = try? Realm().objects(SearchGroups.self)
//    var searchDict = [String: Results<SearchGroups>]()
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        searchGroups()
//        
//        navigationItem.searchController = searchController
//        navigationItem.hidesSearchBarWhenScrolling = false
//        
//        if let textFieldInsideSearchBar = searchController.searchBar.getSubview(type: UITextField.self), let searchIconImageView = textFieldInsideSearchBar.leftView as? UIImageView {
////            searchIconImageView.image = searchIconImageView.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
//            searchIconImageView.tintColor = UIColor.blue
//        }
//        if let textFieldInsideSearchBar = searchController.searchBar.getSubview(type: UITextField.self) {
//            textFieldInsideSearchBar.layer.backgroundColor = UIColor.white.cgColor
//            textFieldInsideSearchBar.layer.cornerRadius = 10.0
//        }
//    }
//    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return newGroup.count
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//       let groupKey = newGroup[section]
//        if let groupValues = searchDict[groupKey] {
//            return groupValues.count
//        }
//        return 0
//        //return allGroups.count
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "AllGroupCell", for: indexPath) as! AllGroupCell
//        let groupKey = newGroup[indexPath.section]
//           if let group = searchDict[groupKey]?[indexPath.row] {
//            cell.configure(with: group)
//        }
//        //
//       
//        return cell
//    }
//    
//    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//    
//    func searchGroups() {
//        searchController.searchResultsUpdater = self
//        searchController.dimsBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "Поиск"
//        searchController.searchBar.tintColor = .black
//    }
//}
//
//extension AllGroups: UISearchResultsUpdating, UISearchBarDelegate {
//    func updateSearchResults(for searchController: UISearchController) {
//        guard !searchController.searchBar.text!.isEmpty else {
//            allGroups.removeAll()
//            tableView.reloadData()
//            return
//        }
//        
//        searchRequest.getSearchGroupRequest(searchText: ((searchController.searchBar.text?.lowercased()))!, completion: { [weak self] (search) in
//            self?.allGroups = search
//            self?.tableView?.reloadData()
//        })
//    }
//}
//
//extension UIView {
//    func getSubview<T>(type: T.Type) -> T? {
//        let svs = subviews.flatMap { $0.subviews }
//        let element = (svs.filter { $0 is T }).first
//        return element as? T
//    }
//}
