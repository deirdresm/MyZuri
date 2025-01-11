//
//  ImageDropView.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 12/30/24.
//

import SwiftUI
import UniformTypeIdentifiers

// excluded PDF as it requires special handling.
let imageDropTypes: [UTType] = [.heic, .heif, .png, .gif, .jpeg, .webP, .tiff, .bmp, .svg, .rawImage]

// https://github.com/liamrosenfeld/Iconology/blob/main/Iconology/Main/SelectionModels/ImageRetriever.swift

struct ImageDropView: View {
	@Binding var imageData: Data?

	var body: some View {
		VStack {
			if let imageData = imageData,
				let platformImage = PlatformImage(data: imageData) {
				Image(image: platformImage)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(maxWidth: 500, maxHeight: 500)
			} else {
				Text("Drag and drop an image here.")
					.font(.headline)
					.padding()
					.frame(maxWidth: 500, maxHeight: 500)
					.background(Color.gray.opacity(0.3))
			}
		}
		.onDrop(of: imageDropTypes, isTargeted: nil) { (items) -> Bool in
			if let item = items.first {
				if let identifier = item.registeredTypeIdentifiers.first {
					print("onDrop with identifier = \(identifier)")

					item.loadDataRepresentation(forTypeIdentifier: identifier) { data, _ in
						if let data {
							imageData = data
						}
					}
				}
				return true
			} else { print("item not here"); return false }
		}
	}

}
