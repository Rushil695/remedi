//
//  ProfileView.swift
//  remedi
//
//  Created by Rushil Madhu on 4/6/24.
//

import SwiftUI

struct ProfileView: View {  
    @ObservedObject var vm = ContentViewModel()
    @Binding var showing: Bool
    
    var body: some View {
        ZStack {
            Color(.black)
                .ignoresSafeArea()
            VStack {
                HStack {
                    Button {
                        showing = false
                    } label: {
                        Text("Dismiss")
                            .foregroundStyle(.blu)
                    }
                    Spacer()
                    Button {
                        vm.logOut()
                    } label: {
                        Text("Log out")
                            .foregroundStyle(.blu)
                    }
                }
                .padding()
                Spacer()
                Image(systemName: "person.crop.circle.fill")
                    .imageScale(.large)
                    
                    .foregroundStyle(.main)
                Text("This is your profile")
                    .font(.title3)
                    .foregroundStyle(.white)
                Spacer()
            }
        }
    }
}

#Preview {
    ProfileView(showing: .constant(true))
}
