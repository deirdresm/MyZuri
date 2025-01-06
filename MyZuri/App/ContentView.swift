//
//  ContentView.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 12/25/24.
//

import SwiftUI
import SwiftData

enum SortOption: String, Identifiable, CaseIterable, CustomStringConvertible {
	case purchaseDate
	case name = "Name"
	case itemType = "Item Type"

	var id: Self { self }

	var description: String {
		switch self {
		case .purchaseDate:
			return "Purchase Date"
		case .name:
			return "Name"
		case .itemType:
			return "Item Type"
		}
	}

}  // enum

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

	@Query var items: [Item]
	@State private var path = [Item]()
	@State private var sortOrder = SortDescriptor(\Item.name)
	@State private var searchText = ""


	var body: some View {
		NavigationStack(path: $path) {
			ItemListView(sort: [sortOrder], searchString: searchText)
				.navigationTitle("My Zuri Items")
				.navigationDestination(for: Item.self, destination: EditItemView.init)
#if os(macOS)
				.navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
				.searchable(text: $searchText)
				.toolbar {
					Button(action: addItem) {
						Label("Add Item", systemImage: "plus")
					}

					Menu("Sort", systemImage: "arrow.up.arrow.down") {
						Picker("Sort", selection: $sortOrder) {

							Text("Name")
								.tag(SortDescriptor(\Item.name))

							Text("Date")
								.tag([
									SortDescriptor(\Item.boughtOn, order: .reverse),
									SortDescriptor(\Item.name)
								])
							Text("Item Type")
								.tag([SortDescriptor(\Item.itemCategory.description),
									  SortDescriptor(\Item.name)])

						} // Picker
						.pickerStyle(.inline)
					} // Menu

				} // toolbar
		} // NavigationStack
	} // body

    private func addItem() {
        withAnimation {
            let newItem = Item()
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
