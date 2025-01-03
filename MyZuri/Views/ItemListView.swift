//
//  ListItemView.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 1/1/25.
//

/// For the sidebar list on a Mac.

import SwiftData
import SwiftUI

struct ItemListView: View {
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
		 List {
			 ForEach(items) { item in
				 NavigationLink {
					 EditItemView(item: item)
				 } label: {
					 Text(item.name)
				 }
			 }
			 .onDelete(perform: deleteItems)
		 }
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
