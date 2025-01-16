//
//  ImageDataView.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 1/12/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct ImageDataView: View {
	let imageData: Data?

	var body: some View {
		VStack {
			if let imageData = imageData,
				let platformImage = PlatformImage(data: imageData) {
				Image(image: platformImage)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(maxWidth: 500, maxHeight: 500)
			} else {
				EmptyView()
			}
		}
	}
}
