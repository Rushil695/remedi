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
    @StateObject private var audioRecorderManager = AudioRecorderManager()


    
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
                    Image(.logo)
                        .resizable()
                        .frame(width: 390, height: 230)
                    Text("How may we help you today?")
                        .lineLimit(1)
                        .foregroundStyle(LinearGradient(colors: [.blu,.main], startPoint: .leading, endPoint: .trailing))
                        .font(.custom("", size: 26))
                        .padding(.horizontal, 25.0)
                        .offset(y: 50)
                    Spacer()
                    
                    Text("Upload a picture, audio, or type in your issue")
                        .foregroundStyle(LinearGradient(colors: [.blu,.main], startPoint: .leading, endPoint: .trailing).opacity(0.7))
                        .foregroundStyle(.blu)
                        .font(.callout)
                        .padding(.top, 65.0)
                        .padding(.horizontal, 25.0)
                    HStack {
                        Button {
                            if audioRecorderManager.isRecording {
                                        audioRecorderManager.stopRecording()
                            } else {
                                audioRecorderManager.startRecording()
                            }
                            main 
                        } label: {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(.black)
                                .shadow(color: .main.opacity(0.9),radius: 5)
                                .overlay {
                                    if mainvm.audio == nil {
                                        Image(systemName: "mic.fill")
                                            .foregroundStyle(audioRecorderManager.isRecording ? .red : .main)
                                            .imageScale(.large)
                                    }
                                    else {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(.main)
                                            .imageScale(.large)
                                    }
                                }
                        }
                        
                        Button {
                            let url = URL(string: mainvm.s3url.absoluteString + UUID().uuidString)!
                            mainvm.uploadImageToS3(url: url, image: mainvm.image ?? .logo)
                            self.showingCamera = true
                        } label: {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(.black)
                                .shadow(color: .main.opacity(0.9),radius: 5)
                                .overlay {
                                    if mainvm.image == nil {
                                        Image(systemName: "camera.fill")
                                            .foregroundStyle(.main)
                                            .imageScale(.large)
                                    }
                                    else {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(.main)
                                            .imageScale(.large)
                                    }
                                        
                                }
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
                    QView(mainVM: mainvm)
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
                
            
            if mainvm.textPrompt.isEmpty {
                Image(systemName: "paperplane")
                    .foregroundStyle(.gray)
            }
            else {
                Button {
                    Task {
                        do {
                            let ex = try await mainvm.sendDataToServer(imageLink: "", textData: mainvm.textPrompt)
                            DispatchQueue.main.async {
                                mainvm.response.append(ex)
                                mainvm.results.toggle()
                            }
                        } catch {
                            print("Error sending data to server: \(error)")
                        }
                    }
                }
                label: {
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
