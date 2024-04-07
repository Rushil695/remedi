//
//  MessageView.swift
//  remedi
//
//  Created by Rushil Madhu on 4/6/24.
//

import SwiftUI

struct MessageView: View {
    var string: String
    
    var body: some View {
        Text(string)
            .font(.headline)
            .frame(maxWidth: .infinity)
            .foregroundStyle(.main)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(.black)
                    .shadow(color: .main.opacity(0.9),radius: 5)
            )
    }
}

#Preview {
    MessageView(string: "what is happening")
}
