//
//  remediApp.swift
//  remedi
//
//  Created by Rushil Madhu on 4/6/24.
//

import SwiftUI
import FirebaseCore

@main
struct remediApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
