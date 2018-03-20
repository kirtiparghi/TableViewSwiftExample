//
//  DetailVC.swift
//  TableViewSwiftExample
//
//  Created by Kirti Parghi on 3/20/18.
//  Copyright © 2018 Kirti Parghi. All rights reserved.
//

import UIKit
import CoreData

class DetailVC: UIViewController {

    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var content : String!
    
    @IBOutlet var lbl:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl.text = content
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
    
    @IBAction func btnBackTapped(sender:UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
