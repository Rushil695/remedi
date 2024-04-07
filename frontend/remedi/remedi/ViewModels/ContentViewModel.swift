//
//  ContentViewModel.swift
//  remedi
//
//  Created by Rushil Madhu on 4/6/24.
//

import Foundation
import FirebaseAuth

class ContentViewModel: ObservableObject {
    @Published var currentUser : String = ""
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        self.handler = Auth.auth().addStateDidChangeListener {  [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUser = user?.uid ?? ""
            }
        }
    }
    
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
        
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
        }
        catch {
            print(error )
        }
    }
}

