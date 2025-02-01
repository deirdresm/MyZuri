//
//  ItemColorBarView.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 1/28/25.
//

import SwiftUI

struct ItemColorBarView: View {
	@Bindable var item: Item
	@State private var selectedColorIndex: Int = -1
	@State private var shouldPresentSheet: Bool = false

	init(item: Bindable<Item>) {
		_item = item
		if item.itemColors.count > 0 {
			selectedColorIndex = 0
		}
	}

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
				if selectedColorIndex == -1 {
					selectedColorIndex = 0
				}
			}

			ForEach(item.itemColors) { itemColor in
				Circle()
					.fill(Color(cgColor: itemColor.cgColor))
					.frame(idealWidth: 75, idealHeight: 75, maxHeight: 75)
					.onTapGesture(count: 1) {
						if let index = item.itemColors.firstIndex(of: itemColor) {
							selectedColorIndex = index
						} else {
							selectedColorIndex = 0
						}
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
			EditItemColorView(item: item, itemColor: $item.itemColors[selectedColorIndex])
		}
    }

	func addItemColor() {
		item.itemColors.append(
			ProductColor(id: UUID(),
				name: "New Color",
				colorFamily: "blue",
				red: 0, green: 0.25, blue: 0.95, alpha: 1,
				item: item
			)
		)
	}

	func removeLastItemColor() {
		item.itemColors.removeLast()
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
	@Previewable @Bindable var item = Item.previewShirt
	@Previewable @State var itemColors = [ProductColor(	id: UUID(), name: "Indigo",
								colorFamily: "Indigo",
								red: 0.1953125,
								green: 0.171875,
								blue: 0.45703125,
														alpha: 1, item: Item.previewShirt)]


	ItemColorBarView(item: $item)
}
