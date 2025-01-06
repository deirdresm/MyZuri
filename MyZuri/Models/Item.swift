//
//  Item.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 12/25/24.
//

import Foundation
import SwiftData

typealias Item = MyZuriSchemaV1.Item
typealias ItemColor = MyZuriSchemaV1.ItemColor
typealias ItemCategory = MyZuriSchemaV1.ItemCategory
typealias SleeveType = MyZuriSchemaV1.SleeveType
typealias ItemStatus = MyZuriSchemaV1.ItemStatus

extension MyZuriSchemaV1 {

	/// `ItemStatus` - Have we bought this yet?
	enum ItemStatus: String, Identifiable, Codable, CaseIterable, CustomStringConvertible {
		case wishlist
		case bought
		case returned
		case sold

		var id: Self { self }

		/// `description` for UI elements
		var description: String {
			switch self {
			case .wishlist: return "Wishlist Item"
			case .bought: return "Bought"
			case .returned: return "Returned"
			case .sold: return "Sold"
			}
		}
	}

	/// `ItemCategory` - What general type of item is it?
	enum ItemCategory: String, Identifiable, Codable, CaseIterable, CustomStringConvertible {
		case blouse
		case standardDress
		case longDress
		case otherItem

		var id: Self { self }

		/// `description` for UI elements
		var description: String {
			switch self {
			case .blouse: return "Blouse"
			case .standardDress: return "Standard Dress"
			case .longDress: return "Long Dress"
			case .otherItem: return "Other Item"
			}
		}
	}

	/// `SleeveType` - What type of sleeves does it have, if any?
	enum SleeveType: String, Identifiable, Codable, CaseIterable, CustomStringConvertible {
		case sleeveless
		case shortSleeves
		case longSleeves
		case notApplicable	// maybe it's a bowl, y'know

		var id: Self { self }

		/// `description` for UI elements
		var description: String {
			switch self {
			case .sleeveless: return "Sleveless"
			case .shortSleeves: return "Short Sleeves"
			case .longSleeves: return "Long Sleeves"
			case .notApplicable: return "Not Applicable"
			}
		}
	}

	@Model
	public class Item {
		var name: String				// formal item name
		var size: String				// empty string if unsized
		var lastModified: Date			// date last modified
		var itemCategory: ItemCategory	// blouse, etc.
		var sleeves: SleeveType		// short, long, etc.
		var itemStatus: ItemStatus		// wishlist, bought, etc.
		var boughtOn: Date?			// nil if wishlist item
		var pricePaid: Double?			// nil if wishlist item
		var soldOn: Date?				// nil if still owned or wishlist item
		var salePrice: Double?			// nil if still owned or wishlist item
		var fabric: String			// linen? cotton?
		var countryOfOrigin: String	// Ghana, India, etc.
		var notes: String				// thoughts about the item

		var colors: [ItemColor]		// what colors the item contains

		@Attribute(.externalStorage)
		var photo: Data?				// keeping it simple with one photo

		@Attribute(.externalStorage)
		var detailPhoto: Data?			// second photo to show fabric closeup

		init(name: String = "New Item",
			 size: String = "",
			 itemCategory: ItemCategory = .blouse,
			 sleeves: SleeveType = .longSleeves,
			 itemStatus: ItemStatus = .wishlist,
			 boughtOn: Date? = nil,
			 pricePaid: Double? = nil,
			 soldOn: Date? = nil,
			 salePrice: Double? = nil,
			 fabric: String = "Cotton",
			 countryOfOrigin: String = "Kenya",
			 notes: String = "",
			 photo: Data? = nil,
			 detailPhoto: Data? = nil,
			 colors: [ItemColor] = []
		) {
			self.name = name
			self.size = size
			self.itemCategory = itemCategory
			self.sleeves = sleeves
			self.itemStatus = itemStatus
			self.boughtOn = boughtOn
			self.pricePaid = pricePaid
			self.soldOn = soldOn
			self.salePrice = salePrice
			self.fabric = fabric
			self.countryOfOrigin = countryOfOrigin
			self.notes = notes

			self.photo = photo
			self.detailPhoto = detailPhoto
			self.colors = colors

			self.lastModified = Date()
		}
	}
}
