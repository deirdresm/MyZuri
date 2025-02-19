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

	var body: some View {

		HStack {
			// photos on the left, fields on the right
			VStack(alignment: .center, spacing: 10) {
				Text(item.name)
					.font(.largeTitle).bold()
					.padding(.bottom)
				Section {
					Text("Basic Information")
						.font(.title2)
					HStack {
						Text("Item Size")
							.font(.headline)
						Text(item.size)
					}
					HStack {
						Text("Category")
							.font(.headline)
						Text(item.itemCategory.description)
					}
					HStack {
						Text("Sleeve Type")
							.font(.headline)
						Text(item.sleeves.description)
					}
				}
				.padding(5)
				.padding(.bottom)

				Divider()

				Section {
					Text("Status")
						.font(.title2)
					switch item.itemStatus {
					case .wishlist:
						Text("Wishlist, not yet purchased")
					case .bought:
						Section("Purchase Information") {
							LabeledContent("Purchase Date", value: item.dateFormatted(item.boughtOn))
							LabeledContent("Purchase Price", value: item.numberFormatted(item.pricePaid))
						}
						.padding(.bottom)
					case .returned:
						Section("Return Information") {
							LabeledContent("Purchase Date", value: item.dateFormatted(item.boughtOn))
							LabeledContent("Purchase Price", value: item.numberFormatted(item.pricePaid))
							LabeledContent("Return Date",  value: item.dateFormatted(item.soldOn))
						}
						.padding(.bottom)
					case .sold:
						Section("Sale Information") {
							LabeledContent("Purchase Date", value: item.dateFormatted(item.boughtOn))
							LabeledContent("Purchase Price", value: item.numberFormatted(item.pricePaid))
							LabeledContent("Sale Date",  value: item.dateFormatted(item.soldOn))
							LabeledContent("Sale Price",  value: item.numberFormatted(item.salePrice))
						}
						.padding(.bottom)
					}
				} // Item Status Section
				.padding(5)
				.padding(.bottom)

				Divider()

				Section {
					Text("More Information")
						.font(.title2)
					VStack {
						Text("Fabric")
							.font(.headline)
							.padding(.bottom, 5)
						Text(item.fabric)
					}
					.padding(.bottom)

					VStack {
						Text("Country of Origin")
							.font(.headline)
							.padding(.bottom, 5)
						Text(item.countryOfOrigin)
					}
					.padding(.bottom)

					VStack {
						Text("Notes")
							.font(.headline)
							.padding(.bottom, 5)
						Text(item.notes)
					}
				}

			} // VStack for data
			.padding(.horizontal)

			VStack {
				ImageDataView(imageData: item.photo)
				ImageDataView(imageData: item.detailPhoto)
			} // VStack for Image
			.padding(.horizontal)

		} // HStack
	} // body
}
