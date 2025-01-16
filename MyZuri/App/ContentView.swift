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

	@State private var editing = false	// toggles editing for subviews

	@Query var items: [Item]
	@State private var path: [Item] = []
	@State private var sortOrder = [	SortDescriptor(\Item.itemStatusInt),
									SortDescriptor(\Item.itemCategoryInt),
									SortDescriptor(\Item.name)
								]
	@State private var searchText = ""

	var body: some View {
		NavigationStack(path: $path) {
			VStack {
				ItemGallery(sort: sortOrder, searchString: searchText, editing: $editing)
					.navigationTitle("My Zuri Items")
					.navigationDestination(for: Item.self, destination: EditItemView.init)
#if os(macOS)
					.navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
					.searchable(text: $searchText)
					.padding(10)
				}
				.toolbar {
					Button(action: addItem) {
						Label("Add Item", systemImage: "plus")
					}

					Button {
						editing.toggle()
					} label: {
						Image(systemName: editing ? "pencil.and.scribble" : "pencil.slash" )
					}

					Menu("Sort", systemImage: "arrow.up.arrow.down") {
						Picker("Sort", selection: $sortOrder) {

							Text("Name")
								.tag([
									SortDescriptor(\Item.itemStatusInt),
									SortDescriptor(\Item.itemCategoryInt),
									SortDescriptor(\Item.name)
								])

							Text("Date")
								.tag([
									SortDescriptor(\Item.itemStatusInt),
									SortDescriptor(\Item.boughtOn, order: .reverse),
									SortDescriptor(\Item.itemCategoryInt),
									SortDescriptor(\Item.name)
								])

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
//			path.append(newItem)
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
