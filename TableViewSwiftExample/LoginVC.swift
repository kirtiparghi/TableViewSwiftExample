//
//  LoginVC.swift
//  TableViewSwiftExample
//
//  Created by Kirti Parghi on 3/20/18.
//  Copyright © 2018 Kirti Parghi. All rights reserved.
//

import UIKit
import CoreData

class LoginVC: UIViewController {

    @IBOutlet var txtFieldEmail : UITextField!
    @IBOutlet var txtFieldPassword : UITextField!
    
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var arrayOfStrings = ["Computer","Keyboard","Mouse","Speaker","Laptop","iPhone","iPod","MacbookPro","Android","Tablet","iPad"]

    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataInLocalDB(arrayOfStrings: arrayOfStrings)
    }
    
    func loadDataInLocalDB(arrayOfStrings:[String]) {
        //LOAD RECORDS IN TABLE
        for item in arrayOfStrings {
            let entity = NSEntityDescription.entity(forEntityName: "RandomStrings", in: myContext)
            let record = NSManagedObject(entity: entity!, insertInto: myContext) as! RandomStrings
            record.content = item
            do {
                try myContext.save()
            }
            catch {
                print("Something went wrong!!!!")
            }
        }
    }
    
    @IBAction func btnLoginTapped(sender:UIButton) {
        if (isValidEmail(testStr: txtFieldEmail.text!) == false) {
            let alrt = UIAlertController(title: "Alert", message: "Email is not valid.", preferredStyle: .alert)
            let okActionButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alrt.addAction(okActionButton)
            self.present(alrt, animated: true, completion: nil)
        }
        else if (isPasswordLongEnough(password: txtFieldPassword.text!) == false) {
            let alrt = UIAlertController(title: "Alert", message: "Password must be atleast 6 characters long.", preferredStyle: .alert)
            let okActionButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alrt.addAction(okActionButton)
            self.present(alrt, animated: true, completion: nil)
        }
        else {
            // store password and email in user defaults
            var defaults = UserDefaults.standard
            defaults.set(txtFieldEmail.text, forKey: "email")
            defaults.set(txtFieldPassword.text, forKey: "password")
        }
        self.performSegue(withIdentifier: "homeSegue", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
