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
	@State private var sortOption: SortOption

	@State private var path = [Item]()
	@State private var sortOrder = SortDescriptor(\Item.name)
	@State private var searchText = ""


	init(sortOption: SortOption = .purchaseDate) {
		self.sortOption = sortOption

		switch self.sortOption {
		case .purchaseDate:
			_items = Query(sort: [
				SortDescriptor(\Item.boughtOn, order: .reverse),
				SortDescriptor(\Item.name)
				])
		case .name:
			_items = Query(sort: \.name, order: .forward)
		case .itemType:
			_items = Query(sort: [
				SortDescriptor(\.itemCategory.description),
				SortDescriptor(\Item.name)
				])
		} // switch
	} // init

    var body: some View {
        NavigationSplitView {
			ItemListView(sort: [sortOrder], searchString: searchText)
				.navigationTitle("My Zuri Items")
				.navigationDestination(for: Item.self, destination: EditItemView.init)
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
			.searchable(text: $searchText)
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
#endif
				Button(action: addItem) {
					Label("Add Item", systemImage: "plus")
				}

				Menu("Sort", systemImage: "arrow.up.arrow.down") {
					Picker("Sort", selection: $sortOrder) {
						ForEach(SortOption.allCases) { sortOrder in
							Text(sortOrder.description)
						}
					}
				}

            }
//			.onChange(of: sortOrder) { oldValue, newValue in
//				switch self.sortOrder {
//				case .purchaseDate:
//					_items = Query(sort: [
//						SortDescriptor(\Item.boughtOn, order: .reverse),
//						SortDescriptor(\Item.name)
//						])
//				case .name:
//					_items = Query(sort: \.name, order: .forward)
//				case .itemType:
//					_items = Query(sort: [
//						SortDescriptor(\.itemCategory.description),
//						SortDescriptor(\Item.name)
//						])
//				} // switch
//			}

        } detail: {
            Text("Select an item")
        }
    }

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
