//
//  VerticalLabelStyle.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 2/8/25.
//
import SwiftUI

struct VerticalLabelStyle: LabelStyle {
	func makeBody(configuration: Configuration) -> some View {
		VStack {
			configuration.icon.font(.headline)
			configuration.title.font(.footnote)
		}
	}
}

#Preview {
	Button(action: { print("Button tapped!") }) {
		Label("Add New", systemImage: "plus")
			.labelStyle(VerticalLabelStyle())
	}
	.accessibilityLabel("Tap the Button")
}
