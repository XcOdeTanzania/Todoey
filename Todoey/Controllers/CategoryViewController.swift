//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Qlicue on 05/06/2018.
//  Copyright © 2018 transevents. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var category: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories();
    }
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = category?[indexPath.row].name ?? "No Categories Added Yet"
        
        return cell
    }
    
    //MARK: - ableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    //MARK: - Data Manipulation Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("I get called")
        let destinationVC = segue.destination as! TodoViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = category?[indexPath.row]
            
        }
    }
    func save(category: Category){
        
        do{
            try realm.write {
                realm.add(category)
            }
            
        } catch{
            print("Error saving in context, \(error) ")
        }
        
        tableView.reloadData()
    }
    
    
    func loadCategories(){
        category = realm.objects(Category.self)
    }
    
    //MARk:- Delete Data from swipe
    override func updateModel(at indexPath: IndexPath) {
                    if let categoryForDeletion = self.category?[indexPath.row]{
                        do{
                            try self.realm.write {
                                self.realm.delete(categoryForDeletion)
                            }
                        }catch{
                            print("Error while writing data \(error)")
                        }
                    }
    }
    //MARK:- Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //what will happen once the user clicks the add button
            
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
}


