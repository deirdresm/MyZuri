//
//  ItemContainerView.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 1/14/25.
//


import SwiftUI

/// A container for item content
struct ItemContainerView<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.clear)
            content
//                .foregroundStyle(Color.cardText)
        }
        .aspectRatio(2, contentMode: .fit)
        .background()
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
