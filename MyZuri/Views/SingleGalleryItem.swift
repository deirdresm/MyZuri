//
//  SingleGalleryItem.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 1/12/25.
//

import SwiftUI

struct SingleGalleryItem: View {
	@Environment(\.modelContext) var modelContext
	var item: Item
	var editing: Bool

    var body: some View {
		VStack {
			if let imageData = item.photo,
			   let platformImage = PlatformImage(data: imageData) {
				Image(image: platformImage)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(maxWidth: 300, maxHeight: 300)
			} else {
				Spacer() // force the label to align with those with images.
			}

			GeometryReader { geo in
				if item.itemColors.count > 0 {
					HStack {
						ForEach(item.itemColors, id: \.self) { color in
							Color(cgColor: color.cgColor)
								.frame(minWidth: 20, idealWidth: calcColorTabWidth(geoWidth: geo.size.width), maxWidth: geo.size.width, minHeight: 20)
						}
					}
					.frame(idealWidth: geo.size.width, idealHeight: 20)
				} else {
					Color.clear
						.frame(idealWidth: geo.size.width, idealHeight: 20)
				}
			} // GeometryReader
			.frame(maxHeight: 20)

			NavigationLink {
				Group {
					if editing {
						EditItemView(item: item)

					} else {
						ShowItemView(item: item)
					}
				}
			} label: {
				Text(item.name)
			}
		}
	}

	func calcColorTabWidth(geoWidth: CGFloat) -> CGFloat {
		let marginWidths = item.itemColors.count >= 2 ? CGFloat((item.itemColors.count - 1) * 10) : CGFloat(0)
		return max((geoWidth - marginWidths)/CGFloat(item.itemColors.count), 20.0)
	}
}

//#Preview {
//    SingleGalleryItem()
//}
