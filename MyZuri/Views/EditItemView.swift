//
//  EditPedalView.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 12/29/24.
//


//
//  EditPedalView.swift
//  GearClosetDocument
//
//  Created by Deirdre Saoirse Moen on 12/22/24.
//

import SwiftUI

struct EditItemView: View {
	@Environment(\.modelContext) private var modelContext
	@Bindable var item: Item
	private let plainIntFormat = IntegerFormatStyle<Int16>()

	@State private var newPedalName = ""
    var body: some View {
		Text("Edit Zuri Item")
			.font(.title)

		Form {
			VStack(alignment: .leading) {
				Text("Basic Info")
				TextField("Name", text: $item.name)
				TextField("Size", text: $item.size)
				Picker("Item Category", selection: $item.itemCategory) {
					ForEach(ItemCategory.allCases) { category in
						Text(String(describing: category))

					}
				}
#if os(iOS)
				.pickerStyle(.wheel)
#endif

				Picker("Sleeve Type", selection: $item.sleeves) {
					ForEach(SleeveType.allCases) { sleeve in
						Text(String(describing: sleeve))

					}
				}
#if os(iOS)
				.pickerStyle(.wheel)
#endif

				Text("Purchase")
					.font(.headline)

				VStack {
					Toggle("Wishlist Item?", isOn: $item.isWishlistItem)

					OptionalDatePicker(  date: $item.boughtOn,
										 title: "Purchase Date",
										 removeTitle: "Remove purchase date",
										 addTitle: "Add purchase date")

					TextField("Purchase Price", value: $item.pricePaid, format: .currency(code: "USD"))
#if os(iOS)
						.keyboardType(.decimalPad)
#endif
				}
				VStack {
					Toggle("Sold Item?", isOn: $item.didsellItem)
					OptionalDatePicker(  date: $item.soldOn,
										 title: "Date Sold",
										 removeTitle: "Remove sale date",
										 addTitle: "Add sale date")

					TextField("Sale Price", value: $item.salePrice, format: .currency(code: "USD"))
#if os(iOS)
						.keyboardType(.decimalPad)
#endif
				}
				TextField("Fabric", text: $item.fabric)
				TextField("Country of Origin", text: $item.countryOfOrigin)
				TextField("Notes", text: $item.notes)

			}
		}
    }
}

//#Preview {
//    EditPedalView()
//}
