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

enum WhichTab: Identifiable, CaseIterable {
	case purchased
	case wishlist

	var id: Self { self }

	var description: String {
		switch self {
		case .purchased: return "Purchased"
		case .wishlist: return "Wishlist"
		}
	}
}


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

	@State private var editing = false	// toggles editing for subviews
	@State private var whichTab: WhichTab = .purchased

	@Query var items: [Item]

	@State private var purchasedNavPath: [Item] = []
	@State private var wishlistNavPath: [Item] = []

	@State private var sortOrder = [
			SortDescriptor(\Item.itemStatusText),
			SortDescriptor(\Item.itemCategoryText),
			SortDescriptor(\Item.name) ]
	@State private var wishlistSortOrder = [
			SortDescriptor(\Item.wishlistStatusInt),
			SortDescriptor(\Item.itemStatusText),
			SortDescriptor(\Item.itemCategoryText),
			SortDescriptor(\Item.name) ]
	@State private var searchText = ""

	#if os(macOS)
		@State private var backgroundImporter: BackgroundImporter?
	#endif


	var body: some View {
		TabView(selection: $whichTab) {
			purchasedItemsView(path: $purchasedNavPath)
				.tabItem { Label("Purchased", systemImage: "figure.stand.dress") }
				.tag(WhichTab.purchased)

			wishlistItemsView(isPurchased: false, path: $wishlistNavPath)
				.tabItem { Label("Wishlist", systemImage: "lightbulb.max") }
				.tag(WhichTab.wishlist)
		}
	} // body

	func purchasedItemsView(path: Binding<[Item]>) -> some View {
		NavigationStack(path: path) {
			VStack {
				ItemGallery(isPurchased: true, sort: sortOrder, searchString: searchText,
					editing: $editing)
					.navigationTitle("My Zuri Items")
					.navigationDestination(for: Item.self, destination: EditItemView.init)
					.searchable(text: $searchText)
					.padding(10)
				}
				.toolbar {
					Button(action: addItem) {
						Label("Add Item", systemImage: "plus")
							.labelStyle(VerticalLabelStyle())
					}
					.accessibilityLabel("Add Bag")

					Button {
						editing.toggle()
					} label: {
						Image(systemName: editing ? "pencil.and.scribble" : "pencil.slash" )
					}

					#if os(macOS)
					Button(action: wishlistFix) {
						Label("Wishlist Fix", systemImage: "lightbulb.max.fill")
							.labelStyle(VerticalLabelStyle())
					}
					#endif

					Menu("Sort", systemImage: "arrow.up.arrow.down") {
						Picker("Sort", selection: $sortOrder) {

							Text("Name")
								.tag([
									SortDescriptor(\Item.itemStatusText),
									SortDescriptor(\Item.itemCategoryText),
									SortDescriptor(\Item.name)
								])

							Text("Date")
								.tag([
									SortDescriptor(\Item.itemStatusText),
									SortDescriptor(\Item.boughtOn, order: .reverse),
									SortDescriptor(\Item.itemCategoryText),
									SortDescriptor(\Item.name)
								])

						} // Picker
						.pickerStyle(.inline)

					} // Menu

				} // toolbar
		} // NavigationStack

	}

	#if os(macOS)
	private func wishlistFix() {
		withAnimation {
			Task {
				try? await backgroundImporter?.itemModelActor.wishlistFix()
			}
		}
	}
	#endif



	func wishlistItemsView(isPurchased: Bool, path: Binding<[Item]>) -> some View {
		NavigationStack(path: path) {
			VStack {
				ItemGallery(isPurchased: false, sort: wishlistSortOrder, searchString: searchText,
					editing: $editing)
					.navigationTitle("Wishlist Items")
					.navigationDestination(for: Item.self, destination: EditItemView.init)
					.padding(10)
				}
		} // NavigationStack

	}

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
