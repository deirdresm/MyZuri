//
//  Item+Preview.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 1/30/25.
//

import Foundation
import SwiftData

extension Item {
	static var previewShirt: Item = {
		var itemColor = ProductColor(	id: UUID(),
										name: "Indigo",
										colorFamily: "Indigo",
										red: 0.1953125,
										green: 0.171875,
										blue: 0.45703125,
										alpha: 1,
										item: Item.previewShirt)

		return Item(name: "Preview Shirt",
					size: "2X",
					itemColors: [itemColor])
	}()
}
