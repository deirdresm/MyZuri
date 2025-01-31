//
//  Item+Preview.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 1/30/25.
//

import Foundation
import SwiftData

extension Item {

	static var previewShirt: Item {
		Item(name: "Preview Shirt",
			 size: "2X",
			 itemCategory: .blouse,
			 sleeves: .longSleeves,
			 itemStatus: .wishlist,
			 boughtOn: nil,
			 pricePaid: nil,
			 soldOn: nil,
			 salePrice: 140.0,
			 fabric: "Cotton",
			 countryOfOrigin: "Kenya",
			 notes: "",
			 photo: nil,
			 detailPhoto: nil,
			 colors: [],
			 productColors: []
		)
	}
}
