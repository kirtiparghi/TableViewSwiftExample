//
//  Validator.swift
//  TableViewSwiftExample
//
//  Created by Kirti Parghi on 3/20/18.
//  Copyright © 2018 Kirti Parghi. All rights reserved.
//

import Foundation

func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

func isPasswordLongEnough(password:String) -> Bool {
    if (password.count < 6) {
        return false
    }
    return true
}
