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
}

//#Preview {
//    SingleGalleryItem()
//}
