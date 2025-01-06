//
//  ItemColor.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 1/5/25.
//

import Foundation
import SwiftData


extension MyZuriSchemaV1 {

	@Model
	public class ItemColor {
		var name: String				// color name, lowercased
		var hexCode: String			// color as a hex code

		// many-to-many relationship
		@Relationship(inverse: \Item.colors) var items: [Item]

		// Name is unique.
		#Unique<ItemColor>([\.name])

		init(name: String, hexCode: String, items: [Item] = []) {
			self.name = name
			self.hexCode = hexCode
			self.items = items
		}
	}
}
