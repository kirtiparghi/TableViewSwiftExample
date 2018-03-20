//
//  ViewController.swift
//  TableViewSwiftExample
//
//  Created by Kirti Parghi on 3/20/18.
//  Copyright © 2018 Kirti Parghi. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var txtFieldRecord : UITextField!
    var results: [NSManagedObject]!
    
    var arrayOfStrings:[String]!
    var selectedString : String!
    @IBOutlet var tableview : UITableView!
    
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let path = FileManager.default.urls(for:.documentDirectory, in:.userDomainMask)
        print(path)
        
        fetchRecords()
    }

    @IBAction func addRecord() {
        let entity = NSEntityDescription.entity(forEntityName: "RandomStrings", in: myContext)
        let record = NSManagedObject(entity: entity!, insertInto: myContext) as! RandomStrings
        record.content = txtFieldRecord.text
        do {
            try myContext.save()
            fetchRecords()
        }
        catch {
            print("Something went wrong!!!!")
        }
    }
    
    func fetchRecords() {
        arrayOfStrings = Array()
        
        let request : NSFetchRequest<RandomStrings> = RandomStrings.fetchRequest()
        
        do {
            results = try myContext.fetch(request)
            print(results)
            if results.count == 0 {
            }
            else {
                for item in results {
                    let obj = item as! RandomStrings
                    arrayOfStrings.append(obj.content!)
                }
                tableview.reloadData()
            }
        }
        catch {
            print("Error while saving users")
        }
    }
    
    @IBAction func btnLogoutTapped(sender:UIBarButtonItem) {
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RandomStrings")
        // Configure Fetch Request
        fetchRequest.includesPropertyValues = false
        
        do {
            let request : NSFetchRequest<RandomStrings> = RandomStrings.fetchRequest()
            let results = try self.myContext.fetch(request)
            for item in results {
                self.myContext.delete(item)
            }
            // Save Changes
            try self.myContext.save()
            self.fetchRecords()
        } catch {
            print("Something went wrong!!!")
        }
        
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "password")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "loginvc")
        self.present(controller, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfStrings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        tableViewCell.textLabel?.text = arrayOfStrings[indexPath.row]
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let alrt = UIAlertController(title: "Content At Cell", message: arrayOfStrings[indexPath.row], preferredStyle: .alert)
//        let okActionButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
//        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alrt.addAction(okActionButton)
//        alrt.addAction(cancelActionButton)
//        self.present(alrt, animated: true, completion: nil)
        selectedString = arrayOfStrings[indexPath.row]
        self.performSegue(withIdentifier: "contentSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            arrayOfStrings.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        else if editingStyle == .insert {
            
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editRowAction = UITableViewRowAction(style: .default, title: "Edit", handler:{action, indexpath in
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Edit Content", message: "", preferredStyle: .alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                textField.text = "Some default text"
            }
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                var obj = self.results[indexPath.row] as! RandomStrings
                obj.content = textField?.text
                do {
                    // Save Changes
                    try self.myContext.save()
                    self.fetchRecords()
                } catch {
                    print("Something went wrong!!!")
                }
            }))
            
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
        });
        editRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        let deleteRowAction = UITableViewRowAction(style: .default, title: "Delete", handler:{action, indexpath in
            // Initialize Fetch Request
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RandomStrings")
            // Configure Fetch Request
            fetchRequest.includesPropertyValues = false
            
            do {
                let request : NSFetchRequest<RandomStrings> = RandomStrings.fetchRequest()
                let results = try self.myContext.fetch(request)
                for item in results {
                    if (item.content == self.arrayOfStrings[indexPath.row]) {
                        self.myContext.delete(item)
                        break
                    }
                }
                // Save Changes
                try self.myContext.save()
                self.fetchRecords()
            } catch {
                print("Something went wrong!!!")
            }
        });
        
        return [deleteRowAction, editRowAction];
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! DetailVC
        controller.content = selectedString
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
