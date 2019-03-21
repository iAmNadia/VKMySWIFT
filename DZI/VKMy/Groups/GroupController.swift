//
//  GroupController.swift
//  VKMy
//
//  Created by NadiaMorozova on 13.11.2018.
//  Copyright © 2018 NadiaMorozova. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import RealmSwift

class GroupController: UITableViewController {
    private let networkService = NetworkService()
  
    var notificationToken: NotificationToken?
    let searchController = UISearchController(searchResultsController: nil)
    var group: Results<Group>? = DataBaseService.get(Group.self, config:  Realm.Configuration(deleteRealmIfMigrationNeeded: true))
    var realm: Realm?
    var groupFilter = [Group]()
    
    var allGroup = [SearchGroups]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationToken = group?.observe { [weak self] changes in
            guard let self = self else { return }
            switch changes {
            case .initial(_):
               // print(changes)
                self.tableView.reloadData()
            case .update(_, let deletions, let insertions,  let modifications):
                print(deletions)
                print(insertions)
                print(modifications)
                self.tableView.applyChanges(deletions: deletions, insertions: insertions, updates: modifications)
            case .error(let error):
                print(error.localizedDescription)
            }
        }
        tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
   
        self.notificationToken = realm?.observe {(notification, realm) in

        }
        networkService.fetch { [weak self] (group: [Group]?, error: Error?) in
            guard error == nil else {
                return
            }
            guard let self = self, error == nil,
                let group = group else { return }
            
            let realm = try? Realm()
            try? realm?.write {
                if self.group != nil {
                    realm?.delete(self.group!)
                }
            }
            try! DataBaseService.save(items: group, update: true)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupCell
        
        guard let group = group?[indexPath.row] else {
            return UITableViewCell()
        }
   
        cell.configure(with: group)
        return cell
    }
  
    
            @IBAction func addGroup(segue: UIStoryboardSegue){
                if segue.identifier == "addGroup" {
                   guard let allController = segue.source as? AllGroupController,
                    let indexPath = allController.tableView.indexPathForSelectedRow else { return }
                    
                    let groups = allController.allGroups[indexPath.row]
                    if !(group?.contains(where: { $0.id == groups.id } ))! {
                       networkService.joinAndLeaveAnyGroup(groupId: groups.id, action: .joinGroup)
                        
                        realm?.add(groups)

                       }
                }
         }
    func searchBarIsEmpty() -> Bool {
        
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterForSearchText(_ searchText: String, scope: String = "All") {
        groupFilter = (group?.filter {( can : Group) -> Bool in
            return can.groupName.lowercased().contains(searchText.lowercased())
            })!
        
        tableView.reloadData()
    }
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
          
            guard let group = group?[indexPath.row] else{ return }
            try! DataBaseService.delete(items: [group])
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }    
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Cell" ,
            let destVC =  segue.destination as? AllGroupController {
            destVC.allGroups = allGroup
        }
    }

}

