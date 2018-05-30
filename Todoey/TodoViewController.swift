//
//  ViewController.swift
//  Todoey
//
//  Created by Qlicue on 07/05/2018.
//  Copyright © 2018 transevents. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {

    let itemArray = ["The don","Kalimwenjuma","Qlicue","Xcode"]
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    //MARK: - TableView datasource method..
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell 
    }

    //MARK: - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

