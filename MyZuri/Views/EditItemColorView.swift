//
//  Untitled.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 1/26/25.
//

import SwiftUI

struct EditItemColorView: View {
	@Binding var itemColor: ProductColor
	let swatch: Data?

	var body: some View {
		VStack {
			if let imageData = swatch,
				let platformImage = PlatformImage(data: imageData) {
				Image(image: platformImage)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(maxWidth: 500, maxHeight: 500)
			}
			Form {
				TextField("Color Name:", text: $itemColor.name)

				TextField("Color Family:", text: $itemColor.colorFamily)

				ColorPicker("Color Swatch", selection: $itemColor.cgColor)
					.onChange(of: itemColor.cgColor) { _, newValue in
						itemColor.cgColor = newValue
					}


			}
			.padding()
			.background(.windowBackground)
			.cornerRadius(15)
			.padding(100)
		}
		.background(Color(cgColor: itemColor.cgColor))
	}
}

#Preview {

	@Previewable @State var itemColor = ProductColor(	id: UUID(),
					name: "Indigo",
					colorFamily: "Indigo",
					red: 0.1953125,
					green: 0.171875,
					blue: 0.45703125,
					alpha: 1,
					item: Item.previewShirt)
	EditItemColorView(itemColor: $itemColor, swatch: nil)
}
