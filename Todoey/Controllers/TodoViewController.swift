//
//  ViewController.swift
//  Todoey
//
//  Created by Qlicue on 07/05/2018.
//  Copyright © 2018 transevents. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoViewController: SwipeTableViewController{
    
    @IBOutlet weak var searchBar: UISearchBar!
    var todoItems: Results<Item>?
    let realm = try! Realm();
    
    var selectedCategory: Category? {
        didSet{
            loadItems();
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory!.name
        guard let colorHex = selectedCategory?.color else {fatalError()}
        
        updateNavBar(withHexCode: colorHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1D9BF6")
    }
    
    //MARK:- Nav Bar Setup Method
    func updateNavBar(withHexCode colorHexCode: String){
        guard let navBar = navigationController?.navigationBar else{
            fatalError("Navigation controller doesnt exist.")
            
        }
        guard let navBarColor = UIColor(hexString: colorHexCode) else {fatalError()}
        navBar.barTintColor = navBarColor
        
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
        searchBar.barTintColor = navBarColor
    }
    //MARK: - TableView datasource method..
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = todoItems?[indexPath.row].title ?? "NO Items yet in This Category"
        
        if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoItems!.count)){
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        }
        
        
        return cell 
    }
    
    //MARK: - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    //  item.done = !item.done
                    realm.delete(item)
                }
            }catch{
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData();
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        //        todoItems[indexPath.row].done = !itemArray[indexPath.row].done
        //        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new Todoey", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the add button
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.createdAt = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error while adding new items, \(error)")
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manuplation Methods
    
    
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
    }
    
    //MARK:- Delete a cell from list
    override func updateModel(at indexPath: IndexPath) {
        if let todoItemForDeletion = self.todoItems?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(todoItemForDeletion)
                }
            }catch{
                print("Error while writing data \(error)")
            }
        }
    }
}

extension TodoViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Am the search button")
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder();
            }
        }
        
        
    }
}

