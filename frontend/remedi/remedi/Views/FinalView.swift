//
//  FinalView.swift
//  remedi
//
//  Created by Rushil Madhu on 4/6/24.
//

import SwiftUI

struct FinalView: View {
    @Binding var q: Bool
//    @ObservedObject var mainvm : MainVM
        
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        
                    } label: {
                        Image(systemName: "xmark.fill")
                            .foregroundStyle(.main)
                    }
                }
                VStack{
                        Text("FINAL DIAGNOSTIC")
                            .foregroundStyle(.main)
                            .font(.title)
                            .bold()
                            .padding()
                    ScrollView {
                        Text("Patient has alziemers that cannot be cured. Need to get his afffairs in order")
                            .foregroundStyle(.main.opacity(0.8))
                            .padding(.horizontal, 25)
                    }
                    Spacer()
                    }
                
                    .background(RoundedRectangle(cornerRadius: 25)
                        .fill(.black)
                        .shadow(color: .blu.opacity(0.9),radius: 5)
                        .foregroundStyle(.white)
                        .frame(width: .infinity, height: 300)
                        .padding(.horizontal, 15))
                
                .frame(width: 400, height: 300)
                
                Text("Severity: ")
                    .foregroundStyle(.white)
                    .font(.title2)
                    .padding(.top, 26.0)
                    .bold()
                    .padding()
                Spacer()
                Button {
                    
                } label: {
                    Text("Schedule an appointment with our volunteer doctor")
                        .padding()
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 20.0)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.black)
                        .shadow(color: .white.opacity(0.9),radius: 5)
                )
            }
        }
    }
}

#Preview {
    FinalView(q: .constant(false))
}
