//
//  ContentView.swift
//  remedi
//
//  Created by Rushil Madhu on 4/6/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = ContentViewModel()
    
    var body: some View {
        VStack {
            if vm.isSignedIn, !vm.currentUser.isEmpty {
                MainView()
                    .transition(.move(edge: .bottom))
            } else {
                LoginView()
                    .transition(.move(edge: .bottom))
                   
            }
        }
        .animation(.interpolatingSpring(stiffness: 100, damping: 10), value: vm.isSignedIn)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(vm.isSignedIn ? Color.clear : Color.gray.opacity(0.5))
        .edgesIgnoringSafeArea(.all)
    }
}


#Preview {
    ContentView()
}
