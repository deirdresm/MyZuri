//
//  ItemColorBarView.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 1/28/25.
//

import SwiftUI

struct ItemColorBarView: View {
	@Binding var itemColors: [ProductColor]
	let item: Item
	@State private var selectedItemIndex: Int = 0
	@State private var shouldPresentSheet: Bool = false

    var body: some View {
		HStack {
			ZStack {
				Color.clear
					.background(.fill.tertiary)
				Image(systemName: "plus")
					.font(.largeTitle)
			}
			.frame(idealWidth: 75, idealHeight: 75)
			.onTapGesture(count: 1) {
				addItemColor()
			}

			ForEach(itemColors.indices, id: \.self) { index in
				Circle()
					.fill(Color(cgColor: itemColors[index].cgColor))
					.frame(idealWidth: 75, idealHeight: 75, maxHeight: 75)
					.onTapGesture(count: 1) {
						selectedItemIndex = index
						shouldPresentSheet = true
					}
			}

			ZStack {
			 Color.clear
				 .background(.fill.tertiary)
			 Image(systemName: "minus")
				 .font(.largeTitle)
		 }
		 .frame(idealWidth: 75, idealHeight: 75)
		 .onTapGesture(count: 1) {
			 removeLastItemColor()
		 }

		}
		.frame(maxWidth: .infinity, idealHeight: 75)
		.sheet(isPresented: $shouldPresentSheet) {
			print("Sheet dismissed!")
		} content: {
			EditItemColorView(itemColor: $itemColors[selectedItemIndex], swatch: item.detailPhoto)
		}
    }

	func addItemColor() {
		itemColors.append(ProductColor(id: UUID(), name: "New Color", colorFamily: "blue", red: 0, green: 0.25, blue: 0.95, alpha: 1, item: item))
	}

	func removeLastItemColor() {
		itemColors.removeLast()
	}
}

struct PressButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.scaleEffect(configuration.isPressed ? 0.97 : 1)
			.animation(.bouncy, value: configuration.isPressed)
	}
}

#Preview {

	@Previewable @State var itemColors = [ProductColor(	id: UUID(), name: "Indigo",
								colorFamily: "Indigo",
								red: 0.1953125,
								green: 0.171875,
								blue: 0.45703125,
														alpha: 1, item: Item.previewShirt)]


	ItemColorBarView(itemColors: $itemColors, item: Item.previewShirt)
}
