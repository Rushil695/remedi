//
//  ResultView.swift
//  remedi
//
//  Created by Rushil Madhu on 4/6/24.
//

import SwiftUI

struct QView: View {
    @ObservedObject var mainVM : MainVM
    @State var final = false
        
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(mainVM.messages, id: \.self){ message in
                    MessageView(string: message)
                        .transition(.asymmetric(insertion: .move(edge: .top).combined(with: .opacity),
                                                               removal: .opacity))
                    HStack {
                        Button {
                            mainVM.sendResponse("Yes")
                            mainVM.fetchQuestion()
                        }label: {
                            MessageView(string: "Yes")
                        }
                        
                        Button {
                            mainVM.sendResponse("No")
                            mainVM.fetchQuestion()
                        }label: {
                            MessageView(string: "No")
                        }
                    }
                    .padding(.bottom, 10)
                }
            }
            .padding(.horizontal,25)
            .animation(.easeInOut(duration: 0.5), value: mainVM.messages)        
            .onAppear(perform: {
                mainVM.fetchQuestion()
            })
            
            if mainVM.messages.last == "" {
                Button {
                    final.toggle()
                } label: {
                    Text("View Diagnostics")
                        .bold()
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.main)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(.black)
                                .shadow(color: .main.opacity(0.9),radius: 5)
                        )
                        .padding(.horizontal,25)
                }
            }
            
            Button {
                mainVM.results.toggle()
            } label: {
                Text("Restart")
                    .bold()
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.main)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.black)
                            .shadow(color: .main.opacity(0.9),radius: 5)
                    )
                    .padding(.horizontal,25)
            }
            .animation(.easeIn, value: mainVM.messages.count)
            
        }
        .navigationDestination(isPresented: $final) {
            FinalView(q: $final/*, mainvm: mainVM*/)
        }
    }
}

//#Preview {
//    QView(mainVM: )
//}
