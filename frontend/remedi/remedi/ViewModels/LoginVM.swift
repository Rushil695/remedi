//
//  File.swift
//  remedi
//
//  Created by Rushil Madhu on 4/6/24.
//

import Foundation
import FirebaseAuth

class LoginVM: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var error = ""
    
    init(email: String = "", password: String = "") {
        self.email = email
        self.password = password
    }
    
    func login() {
        guard validate() else {
            return
        }
        //Try to login
        Auth.auth().signIn(withEmail: email, password: password)
    }
    
    private func validate() -> Bool{
        error = ""
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty, !password.trimmingCharacters(in:.whitespaces).isEmpty else {
            error = "Please fill in all the fields"
            return false
        }
        
        guard email.contains("@") && email.contains(".") else {
            error = "Please enter valid email"
            return false
        }
        return true
    }

}
