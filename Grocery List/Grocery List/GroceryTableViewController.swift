//
//  GroceryTableViewController.swift
//  Grocery List
//
//  Created by Marcelo Mogrovejo on 4/27/17.
//  Copyright © 2017 Marcelo Mogrovejo. All rights reserved.
//

import UIKit
import CoreData

class GroceryTableViewController: UITableViewController {

    var groceries = [Grocery]()
    var managedObjectContext: NSManagedObjectContext?
    var coreData = CoreDataStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get reference to app delegate
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        managedObjectContext = coreData.persistentContainer.viewContext
        
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private
    
    func loadData() {
        let request: NSFetchRequest<Grocery> = Grocery.fetchRequest()
        
        do {
            let results = try managedObjectContext?.fetch(request)
            groceries = results!
            
            tableView.reloadData()
        } catch {
            fatalError("Error in retrieving Grocery item")
        }
    }

    // MARK: - Actions
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Grocery Item", message: "What's to buy?", preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField) in
            textField.autocapitalizationType = UITextAutocapitalizationType.words
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] (alertAction: UIAlertAction) in
            
            if let itemString = alertController.textFields?.first?.text {
                let grocery = Grocery(context: (self?.managedObjectContext!)!)
                grocery.item = itemString
                
                // Save the new item on core data
                do {
                    try self?.managedObjectContext?.save()
                    
                    self?.loadData()
                } catch {
                    fatalError("Error in storing data")
                }
            } else {
                return
            }
        }
        alertController.addAction(addAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groceries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)

        let grocery = self.groceries[indexPath.row]
        
        cell.textLabel?.text = grocery.item

        return cell
    }

}
