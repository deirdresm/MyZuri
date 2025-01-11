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


				Picker("Purchase Status", selection: $item.itemStatus) {
					ForEach(ItemStatus.allCases) { status in
						Text(String(describing: status))
					}
				}


				VStack {

					switch item.itemStatus {
					case .wishlist:
						Text("Wishlist Item")
					case .bought:
						OptionalDatePicker(  date: $item.boughtOn,
											 title: "Purchase Date",
											 removeTitle: "Remove purchase date",
											 addTitle: "Add purchase date")

						TextField("Purchase Price", value: $item.pricePaid, format: .currency(code: "USD"))
	#if os(iOS)
						.keyboardType(.decimalPad)
	#endif
					case .returned:
						OptionalDatePicker(  date: $item.soldOn,
											 title: "Date Returned",
											 removeTitle: "Remove return date",
											 addTitle: "Add return date")

						TextField("Return Value", value: $item.salePrice, format: .currency(code: "USD"))
	#if os(iOS)
							.keyboardType(.decimalPad)
	#endif
					case .sold:
						OptionalDatePicker(  date: $item.soldOn,
											 title: "Date Sold",
											 removeTitle: "Remove sale date",
											 addTitle: "Add sale date")

						TextField("Sale Price", value: $item.salePrice, format: .currency(code: "USD"))
	#if os(iOS)
							.keyboardType(.decimalPad)
	#endif
					}

				}
				TextField("Fabric", text: $item.fabric)
				TextField("Country of Origin", text: $item.countryOfOrigin)
				TextField("Notes", text: $item.notes)
				ImageDropView(imageData: $item.photo)
				ImageDropView(imageData: $item.detailPhoto)
			}
		} // Form
		.padding(.horizontal)
		.navigationTitle("Edit Item")
		#if os(iOS)
		.navigationBarTitleDisplayMode(.inline)
		#endif

    } // body
}
