//
//  Untitled.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 1/26/25.
//

import SwiftUI

struct EditItemColorView: View {
	let item: Item
	@Binding var itemColor: ProductColor

	var body: some View {
		VStack {
			if let imageData = item.detailPhoto ?? item.photo,
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

	@Previewable @State var itemColor = Item.previewShirt.itemColors[0]
	EditItemColorView(item: Item.previewShirt, itemColor: $itemColor)
}
