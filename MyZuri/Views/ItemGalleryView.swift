//
//  ListItemView.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 1/1/25.
//

/// For the sidebar list on a Mac.

import SwiftData
import SwiftUI

struct ItemGalleryView: View {
	@Environment(\.modelContext) var modelContext
	@Query(sort: [SortDescriptor(\Item.boughtOn, order: .reverse), SortDescriptor(\Item.name)]) var items: [Item]

	init(sort: [SortDescriptor<Item>], searchString: String) {
		_items = Query(filter: #Predicate {
			if searchString.isEmpty {
				return true
			} else {
				return $0.name.localizedStandardContains(searchString)
			}
		}, sort: sort)
	}

	var body: some View {

		// TODO: separate sections for bought and wishlist items, preferably 2-up on wider screens.
		ScrollView {
			LazyVGrid(
				columns: [GridItem(Design.galleryGridSize)],
				spacing: 20
			) {
			 ForEach(items) { item in
				 VStack {
					 if let imageData = item.photo,
						let platformImage = PlatformImage(data: imageData) {
						 Image(image: platformImage)
							 .resizable()
							 .aspectRatio(contentMode: .fit)
							 .frame(maxWidth: 300, maxHeight: 300)
					 }
					 NavigationLink {
						 EditItemView(item: item)
					 } label: {
						 Text(item.name)
					 }
				 }
			 }
			 .onDelete(perform: deleteItems)
			}
		}
		.scrollClipDisabled()
	 }

	func deleteItems(_ indexSet: IndexSet) {
		for index in indexSet {
			let item = items[index]
			modelContext.delete(item)
		}
	}
}

#Preview {
	ItemListView(sort: [SortDescriptor(\Item.name)], searchString: "")
}
