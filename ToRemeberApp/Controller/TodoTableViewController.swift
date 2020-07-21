//
//  ViewController.swift
//  ToRemeberApp
//
//  Created by Amna Amna on 7/8/20.
//  Copyright © 2020 Amna Amna. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoTableViewController: UITableViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    var todoList: Results<Item>?
    var categoryList = [Category]()
    let realm = try! Realm()
    
    var selectedCategory : Category?{
        didSet{
            getItems()
            
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none

        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedColor = selectedCategory?.color {
            title = selectedCategory!.name
            navigationController?.navigationBar.backgroundColor = UIColor(hexString: selectedColor)
            navigationController?.navigationBar.tintColor =
                ContrastColorOf(UIColor(hexString: selectedColor)!,returnFlat: true)
                      navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: ContrastColorOf(UIColor(hexString: selectedColor)!,returnFlat: true)]

            searchBar.barTintColor = UIColor(hexString: selectedColor)
            
        }
        
        
       }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellItem", for: indexPath)
        cell.textLabel?.text = todoList?[indexPath.row].itemName ?? "No items Yet"
        if let currentcell = todoList?[indexPath.row]{
            cell.accessoryType = currentcell.isDone == true ?.checkmark : .none
            
            let percentage =  CGFloat(indexPath.row)/CGFloat(todoList!.count)
            if let currentCategory = selectedCategory{
                
                let bgColor = UIColor(hexString:currentCategory.color)!.darken(byPercentage:percentage)
                cell.backgroundColor = bgColor
                cell.textLabel?.textColor  = ContrastColorOf(bgColor!,returnFlat: true)
                cell.tintColor = ContrastColorOf(bgColor!,returnFlat: true)
                
            }
        }
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return  CGFloat(50);
       }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoList?[indexPath.row]
        {
            do{
                try realm.write{
                    item.isDone = !item.isDone
                    
                }
            }
            catch{
                print("error in update /(error)")
            }
        }
        
        
        self.tableView.reloadData()
        
    }
    
    //MARK:  add new item in list
    
    var textfield  = UITextField()
    @IBAction func newItemAction(_ sender: Any) {
        
        let alert = UIAlertController.init(title: "Add New Item to remember", message: "", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "add item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write{
                        let newItem = Item()
                        newItem.itemName = self.textfield.text!
                        currentCategory.items.append(newItem)
                        
                    }
                }
                catch{
                    print("there is a error \(error)")
                }
                self.tableView.reloadData()
                
                
            }        }
        
        alert.addAction(action);
        alert.addTextField { (txt) in
            txt.placeholder = "New item to remember"
            self.textfield = txt;
            
            
        }
        present(alert,animated: true)
    }
    
    
    
    //MARK:  Manipulate DataModel
    
    
    func saveItems(save items : Item) {
        do{
            try realm.write{
                realm.add(items)
            }
        }
        catch{
            print("there is a error \(error)")
        }
    }
    
    func getItems() {
        todoList = selectedCategory?.items.sorted(byKeyPath: "itemName", ascending: true)
        tableView.reloadData()
        
    }
    
    
    
    //  Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if let deletedRow = todoList?[indexPath.row]
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
    
    
}
extension TodoTableViewController :UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoList = todoList?.filter(NSPredicate(format: "itemName CONTAINS[cd] %@", searchBar.text!)).sorted(byKeyPath: "itemName", ascending: true)
        tableView.reloadData()
        
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            getItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                
            }
        }
    }
}

