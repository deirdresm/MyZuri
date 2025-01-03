//
//  EffectCategory.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 12/25/24.
//

import Foundation
import SwiftData

typealias Item = MyZuriSchemaV1.Item
typealias ItemCategory = MyZuriSchemaV1.ItemCategory
typealias SleeveType = MyZuriSchemaV1.SleeveType

extension MyZuriSchemaV1 {

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
		var itemCategory: ItemCategory
		var sleeves: SleeveType
		var isWishlistItem: Bool		// if false, you have the item, otherwise it's a wanted item (used to show/hide next two items in UI)
		var boughtOn: Date?			// nil if wishlist item
		var pricePaid: Double?			// nil if wishlist item
		var didsellItem: Bool			// if false, you haven't sold the item, otherwise it's a current/wishlist item (used to show/hide next two items in UI)
		var soldOn: Date?				// nil if still owned or wishlist item
		var salePrice: Double?			// nil if still owned or wishlist item
		var fabric: String			// linen? cotton?
		var countryOfOrigin: String	// Ghana, India, etc.
		var notes: String				// thoughts about the item

		@Attribute(.externalStorage)
		var photo: Data?				// keeping it simple with one photo

		init(name: String = "New Item",
			 size: String = "",
			 itemCategory: ItemCategory = .blouse,
			 sleeves: SleeveType = .longSleeves,
			 isWishlistItem: Bool = true,
			 boughtOn: Date? = nil,
			 pricePaid: Double? = nil,
			 didSellItem: Bool = false,
			 soldOn: Date? = nil,
			 salePrice: Double? = nil,
			 fabric: String = "Cotton",
			 countryOfOrigin: String = "Ghana",
			 notes: String = "",
			 photo: Data? = nil
		) {
			self.name = name
			self.size = size
			self.itemCategory = itemCategory
			self.sleeves = sleeves
			self.isWishlistItem = isWishlistItem
			self.boughtOn = boughtOn
			self.pricePaid = pricePaid
			self.didsellItem = didSellItem
			self.soldOn = soldOn
			self.salePrice = salePrice
			self.fabric = fabric
			self.countryOfOrigin = countryOfOrigin
			self.notes = notes
			self.photo = photo

			self.lastModified = Date()
		}
	}
}
