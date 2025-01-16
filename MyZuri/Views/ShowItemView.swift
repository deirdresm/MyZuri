//
//  ShowItemView.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 1/12/25.
//

import SwiftUI

/// Non-editing version of `EditItemView`
struct ShowItemView: View {
	@Environment(\.modelContext) private var modelContext
	@Bindable var item: Item
	private let plainIntFormat = IntegerFormatStyle<Int16>()

	@State private var newPedalName = ""
	var body: some View {

		HStack {
			// photos on the left, fields on the right
			HStack {
				VStack {
					ImageDataView(imageData: item.photo)
					ImageDataView(imageData: item.detailPhoto)
				}

				VStack {

					Section("Basic Information") {
						LabeledContent("Item Name", value: item.name)
						LabeledContent("Item Size", value: item.size)
						LabeledContent("Category",  value: item.itemCategory.description)
						LabeledContent("Sleeve Type",  value: item.sleeves.description)
					}

					Section("Status") {
						switch item.itemStatus {
						case .wishlist:
							Text("Wishlist, not yet purchased")
						case .bought:
							Section("Purchase Information") {
								LabeledContent("Purchase Date", value: item.dateFormatted(item.boughtOn))
								LabeledContent("Purchase Price", value: item.numberFormatted(item.pricePaid))
							}
						case .returned:
							Section("Return Information") {
								LabeledContent("Purchase Date", value: item.dateFormatted(item.boughtOn))
								LabeledContent("Purchase Price", value: item.numberFormatted(item.pricePaid))
								LabeledContent("Return Date",  value: item.dateFormatted(item.soldOn))
							}
						case .sold:
							Section("Sale Information") {
								LabeledContent("Purchase Date", value: item.dateFormatted(item.boughtOn))
								LabeledContent("Purchase Price", value: item.numberFormatted(item.pricePaid))
								LabeledContent("Sale Date",  value: item.dateFormatted(item.soldOn))
								LabeledContent("Sale Price",  value: item.numberFormatted(item.salePrice))
							}
						}
					} // Item Status Section
				} // Section

				Section("More Information") {
					LabeledContent("Fabric", value: item.fabric)
					LabeledContent("Country of Origin", value: item.countryOfOrigin)
					LabeledContent("Notes",  value: item.notes) // TODO: Multiline
				}

			} // VStack
		} // HStack
	} // body
}
