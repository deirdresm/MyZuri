//
//  EditItemView.swift
//  GearClosetDocument
//
//  Created by Deirdre Saoirse Moen on 12/22/24.
//

import SwiftUI

/// Editing version of `ShowItemView`

struct EditItemView: View {
	@Bindable var item: Item
	private let plainInt16Format = IntegerFormatStyle<Int16>()
	private let plainIntFormat = IntegerFormatStyle<Int>()

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
					.onChange(of: item.itemCategory) {
						item.itemCategoryText = item.itemCategory.description
					}

					Picker("Sleeve Type", selection: $item.sleeves) {
						ForEach(SleeveType.allCases) { sleeve in
							Text(String(describing: sleeve))

						}
					}
					.onChange(of: item.sleeves) {
						item.sleeveTypeText = item.sleeves.description
					}


					Text("Purchase")
						.font(.headline)


					Picker("Purchase Status", selection: $item.itemStatus) {
						ForEach(ItemStatus.allCases) { status in
							Text(String(describing: status))
						}
					}
					.onChange(of: item.itemStatus) {
						item.itemStatusText = item.itemStatus.description
						item.isNewItem = false
					}

					if item.itemStatus == .wishlist {
						Picker("Wishlist Status", selection: $item.wishlistStatus) {
							ForEach(WishlistStatus.allCases) { wishlistStatus in
								Text(String(describing: wishlistStatus))
									.tag(wishlistStatus as WishlistStatus)
							}
						}
						.onChange(of: item.wishlistStatus) {
							item.wishlistStatusInt = item.wishlistStatus!.intValue
						}
						.padding(.vertical)
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
				}
				VStack(alignment: .leading) {
					TextField("URL", text: $item.urlPath)
						.padding()

					VStack(alignment: .leading) {
						TextEditor(text: $item.notes)
							.font(.system(size: 17))
							.frame(minHeight: 50, maxHeight: 300)
							.fixedSize(horizontal: false, vertical: true)
							.multilineTextAlignment(.leading)
							.navigationTitle("Notes")
					}

					ItemColorBarView(item: $item)
				} // Vstack

			HStack {
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
