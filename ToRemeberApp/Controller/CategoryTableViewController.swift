//
//  CategoryTableViewController.swift
//  ToRemeberApp
//
//  Created by Amna Amna on 7/9/20.
//  Copyright © 2020 Amna Amna. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryTableViewController: UITableViewController {
    
    var categoryList : Results<Category>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getItems()
        tableView.separatorStyle = .none
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList?.count ?? 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.category_CellIdentifier, for: indexPath)
        cell.textLabel?.text = categoryList?[indexPath.row].name ?? "No Items yet"

        if let currentCategory = categoryList?[indexPath.row]{
            let bgColor = currentCategory.color
            cell.backgroundColor = UIColor(hexString: bgColor)
            cell.textLabel?.textColor  = ContrastColorOf(UIColor(hexString: bgColor)!,returnFlat: true)
        
        }
          
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  CGFloat(80);
    }
    
    
    //MARK:  add new Categoty in list
    
    var textfield  = UITextField()
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action)  in
            if let addItem = self.textfield.text{
                let newItem = Category()
                newItem.name = addItem
                newItem.color = RandomFlatColor().hexValue()
                self.saveCategory(save: newItem)
                self.tableView.reloadData()
                
            }
        }
        
        alert.addAction(action);
        alert.addTextField { (txt) in
            txt.placeholder = "New item to remember"
            self.textfield = txt
        }
        present(alert,animated: true)
    }
    //MARK:  Manipulate DataModel
    
    
    func saveCategory(save category:Category) {
        do{
            try realm.write
            {
                realm.add(category)
                
            }
        }
        catch{
            print("there is a error \(error)")
        }
    }
    
    func getItems() {
        categoryList = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    
   
    //  Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if let deletedRow = categoryList?[indexPath.row]
            {
                do{
                    try realm.write
                    {
                        realm.delete(deletedRow)
                        
                    }
                }
                catch{
                    print("there is a error \(error)")
                }
            }
            tableView.deleteRows(at: [indexPath], with: .fade)

        }
    }
    
    
    
    
    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier : K.SegueIdentifier, sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        let destinatin = segue.destination as! TodoTableViewController
        
        if let currentIndex = tableView.indexPathForSelectedRow{
            destinatin.selectedCategory = categoryList?[currentIndex.row]
        }
    }
    
    
}
