//
//  WishlistStatusPicker.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 2/14/25.
//

import SwiftUI

struct WishlistStatusPicker: View {
	@Bindable var item: Item

	init(item: Bindable<Item>) {
		_item = item
	}
	
	var body: some View {
		Picker("Wishlist Status", selection: $item.wishlistStatus) {
			ForEach(WishlistStatus.allCases) { wishlistStatus in
				Text(String(describing: wishlistStatus))
					.tag(wishlistStatus)
			}
		}
		.onChange(of: item.wishlistStatus) {
			item.wishlistStatusInt = item.wishlistStatus!.intValue
		}
		.padding(.vertical)
	}
}
