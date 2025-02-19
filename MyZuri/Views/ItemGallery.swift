//
//  ListItemView.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 1/1/25.
//

/// For the sidebar list on a Mac.

import SwiftData
import SwiftUI

struct ItemGallery: View {
	@Environment(\.modelContext) var modelContext
	@Query(sort: [SortDescriptor(\Item.boughtOn, order: .reverse), SortDescriptor(\Item.name)]) var items: [Item]
	@Binding var editing: Bool

	init(isPurchased: Bool,
		 sort: [SortDescriptor<Item>],
		 searchString: String,
		 editing: Binding<Bool>
		) {
		// note: don't need to store isPurchased, it just filters the items here.
		_items = Query(filter: #Predicate {
			if searchString.isEmpty {
				return isPurchased == ($0.boughtOn != nil)
			} else {
				return isPurchased == ($0.boughtOn != nil) && $0.name.localizedStandardContains(searchString)
			}
		}, sort: sort)
		_editing = editing
	}

	var body: some View {

		// TODO: separate sections for bought and wishlist items, preferably 2-up on wider screens.
		ScrollView {
			LazyVGrid(
				columns: [GridItem(Design.galleryGridSize)],
				spacing: 20
			) {
				ForEach(items) { item in
					SingleGalleryItem(item: item, editing: editing)
				}
				.onDelete(perform: deleteItems)
			}
		}
		.scrollClipDisabled()
	 }

	func deleteItems(_ indexSet: IndexSet) {
//		for index in indexSet {
//			let item = items[index]
//			modelContext.delete(item)
//		}
	}
}

#Preview {
	var editing: Binding<Bool> = .constant(false)

	ItemGallery(isPurchased: true, sort: [SortDescriptor(\Item.name)], searchString: "", editing: editing)
}
