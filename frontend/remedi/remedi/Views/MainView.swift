//
//  MainView.swift
//  remedi
//
//  Created by Rushil Madhu on 4/6/24.
//

import SwiftUI
import PhotosUI

struct MainView: View {
    @State var profileView = false
    @StateObject var mainvm = MainVM()
    @State private var showingCamera = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.black)
                    .ignoresSafeArea()
                VStack {
                    HStack{
                        Spacer()
                        Button(action: {
                            profileView.toggle()
                        }, label: {
                            Image(systemName: "person.crop.circle.fill")
                                .foregroundStyle(.blu
                                )
                                .imageScale(.large)
                        })
                    }
                    .padding()
                    Text("Hello, how are you doing today?")
                        .foregroundStyle(LinearGradient(colors: [.blu,.main], startPoint: .leading, endPoint: .trailing))
                        .font(.title)
                    Spacer()
                    Image(.logo)
                        .resizable()
                        .frame(width: 390, height: 260)
                    Text("Upload a picture, audio, or type in your issue")
                        .foregroundStyle(LinearGradient(colors: [.blu,.main], startPoint: .leading, endPoint: .trailing))
                        .foregroundStyle(.blu)
                        .font(.title2)
                        .padding(.bottom,38.0)
                        .padding(.horizontal, 25.0)
                    HStack {
                        Button {
                            
                        } label: {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(.white)
                                .shadow(color: .main.opacity(0.9),radius: 5)
                        }
                        
                        Button {
                            self.showingCamera = true
                        } label: {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(.white)
                                .shadow(color: .main.opacity(0.9),radius: 5)
                        }
                        
                        
                        
                    }
                    .padding(.horizontal, 25.0)
                    
                    
                    textbar
                        .padding(.all, 25.0)
                    
                }
                .sheet(isPresented: $profileView, content: {
                    ProfileView(showing: $profileView)
                })
                .sheet(isPresented: $showingCamera) {
                    CameraPicker(image: $mainvm.image)
                }
                .navigationDestination(isPresented: $mainvm.results) {
                    ResultView()
                        .navigationBarBackButtonHidden()
                }
            }
        }
    }
    
}

#Preview {
    MainView()
}

extension MainView {
    
    private var textbar : some View {
        HStack {
            TextField("Please describe your issue......", text: $mainvm.textPrompt)
                .padding(.leading)
                .textFieldStyle(DefaultTextFieldStyle())
                .foregroundStyle(.blu)
                
            
            if mainvm.textPrompt.isEmpty{
                Image(systemName: "paperplane")
                    .foregroundStyle(.gray)
            }
            else {
                Button {
                    mainvm.requestPresignedURL(fileName: UUID().uuidString, fileType: "image/png") { url in
                        mainvm.url  = url
                    }
                    guard let burl = mainvm.url, let bimage = mainvm.image else { return }
                    mainvm.uploadImageToS3(url: burl, image: bimage)
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundStyle(.blu)
                }

            }
            
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(.black)
                .shadow(color: .blu.opacity(0.9),radius: 5)
        )
    }
}
