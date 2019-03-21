//
//  TableViewController.swift
//  VKMy
//
//  Created by NadiaMorozova on 21.11.2018.
//  Copyright © 2018 NadiaMorozova. All rights reserved.
//

import UIKit

class DefaultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tableView = UITableView.init()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "Default"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.tableView.frame = self.view.bounds
        self.tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "A \(section + 1)"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    static let cellReuseIdentifier = "identifier"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: DefaultViewController.cellReuseIdentifier)
        
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: DefaultViewController.cellReuseIdentifier)
        }
        
        cell?.textLabel?.text = "Row \(indexPath.row + 1)"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "You Clicked on a Row!", message: indexPath.description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
