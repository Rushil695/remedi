//
//  LoginView.swift
//  remedi
//
//  Created by Rushil Madhu on 4/6/24.
//

import SwiftUI
import UIKit

struct LoginView: View {
    @StateObject var vm = LoginVM()
    @StateObject var regvm = RegisterVM()
    @State var registerView = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Spacer()
                    Image(.logo)
                        .resizable()
                        .frame(width: 390, height: 260)
                    if !vm.error.isEmpty {
                        Text(vm.error)
                            .foregroundStyle(.red)
                    }
                    if registerView {
                        namebar
                            .padding(.horizontal, 25.0)
                        regemailbar
                            .padding(.horizontal, 25.0)
                            .padding(.vertical, 15.0)
                        regpwbar
                            .padding(.horizontal, 25.0)
                    }
                    else {
                        emailbar
                            .padding(.horizontal, 25.0)
                            .padding(.bottom, 15.0)
                        pwbar
                            .padding(.horizontal, 25.0)
                    }
                    Spacer()
                    Button {
                        if !registerView {
                            vm.login()
                        } else {
                            regvm.register()
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .foregroundStyle(.main)
                            
                            Text(!registerView ? "Log In" : "Register")
                                .font(.title3)
                                .foregroundStyle(.white)
                                .bold()
                        }
                    }
                    .frame(width: 250, height: 60)
                    .padding()
                    
                    
                    VStack {
                        if !registerView {
                            Text("New around here?")
                                .foregroundStyle(.blu)
                                .padding(.bottom, 2.0)
                                .padding(.top)
                        }
                        Button(!registerView ? "Create An Account" : "Log In"){
                            registerView.toggle()
                        }
                        .foregroundStyle(.main)
                        .bold()
                        .font(.title3)
                    }
                    .padding(.bottom,35)
                    
                    Spacer()
                }
                
            }
        }.animation(.easeIn(duration: 0.4),value: registerView)
    }
}

#Preview {
    LoginView()
}

extension LoginView {
    
    private var emailbar : some View {
        HStack {
            TextField("Email", text: $vm.email)
                .autocapitalization(.none)
                .padding(.leading)
                .foregroundStyle(.black)
                .disableAutocorrection(true)
                .overlay(Image(systemName: "xmark.circle.fill").foregroundStyle(.main).padding()
                    .offset(x:10)
                    .opacity(vm.email.isEmpty ? 0.0 : 1.0)
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        vm.email = ""
                    }
                         ,alignment: .trailing)
            Image(systemName: "envelope.fill")
                .foregroundStyle(.main)
            
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(.white)
                .shadow(color: .main.opacity(0.9),radius: 5)
        )
    }
    
    
    private var pwbar : some View {
        HStack {
            SecureField("Password", text: $vm.password)
                .padding(.leading)
                .textFieldStyle(DefaultTextFieldStyle())
                .foregroundStyle(.black)
                .disableAutocorrection(true)
                .overlay(Image(systemName: "xmark.circle.fill").foregroundStyle(.main).padding()
                    .offset(x:10)
                    .opacity(vm.password.isEmpty ? 0.0 : 1.0)
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        vm.password = ""
                    }
                         ,alignment: .trailing)
            Image(systemName: "lock.fill")
                .foregroundStyle(.main)
            
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(.white)
                .shadow(color: .main.opacity(0.9),radius: 5)
        )
    }
    
    private var namebar : some View {
        HStack {
            TextField("Name", text: $regvm.name)
                .padding(.leading)
            
                .textFieldStyle(DefaultTextFieldStyle())
                .foregroundStyle(.black)
                .disableAutocorrection(true)
                .overlay(Image(systemName: "xmark.circle.fill").foregroundStyle(.main).padding()
                    .offset(x:10)
                    .opacity(vm.email.isEmpty ? 0.0 : 1.0)
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        vm.email = ""
                    }
                         ,alignment: .trailing)
            Image(systemName: "person.fill")
                .foregroundStyle(.main)
            
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(.white)
                .shadow(color: .main.opacity(0.9),radius: 5)
        )
    }
    
    private var regemailbar : some View {
        HStack {
            TextField("Email", text: $regvm.email)
                .autocapitalization(.none)
                .padding(.leading)
                .foregroundStyle(.black)
                .disableAutocorrection(true)
                .overlay(Image(systemName: "xmark.circle.fill").foregroundStyle(.main).padding()
                    .offset(x:10)
                    .opacity(regvm.email.isEmpty ? 0.0 : 1.0)
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        regvm.email = ""
                    }
                         ,alignment: .trailing)
            Image(systemName: "envelope.fill")
                .foregroundStyle(.main)
            
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(.white)
                .shadow(color: .main.opacity(0.9),radius: 5)
        )
    }
    
    private var regpwbar : some View {
        HStack {
            SecureField("Password", text: $regvm.password)
                .padding(.leading)
            
                .textFieldStyle(DefaultTextFieldStyle())
                .foregroundStyle(.black)
                .disableAutocorrection(true)
                .overlay(Image(systemName: "xmark.circle.fill").foregroundStyle(.main).padding()
                    .offset(x:10)
                    .opacity(regvm.password.isEmpty ? 0.0 : 1.0)
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        regvm.password = ""
                    }
                         ,alignment: .trailing)
            Image(systemName: "lock.fill")
                .foregroundStyle(.main)
            
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(.white)
                .shadow(color: .main.opacity(0.9),radius: 5)
        )
    }
}
