//
//  TabBarButton.swift
//  HaruSijak
//
//  Created by 신나라 on 6/24/24.
//

import Foundation
import SwiftUI

struct TabBarButton: View {
    let icon: String
    let text: String
    @Binding var selection: Int
    let tag: Int
    
    var body: some View {
        Button(action: {
            selection = tag
        }) {
            VStack(content: {
                Image(systemName: icon)
                Text(text)
            })
            .foregroundColor(selection == tag ? .primary : .secondary)
        }
    }
    
}
