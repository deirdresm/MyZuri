//
//  ItemV2.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 1/30/25.
//

import Foundation
import SwiftData

extension MyZuriSchemaV2 {

	/// `ItemStatus` - Have we bought this yet?
	enum ItemStatus: String, Identifiable, Codable, CaseIterable, CustomStringConvertible, Equatable {
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

		/// `intValue` (to save as integer for sorting purposes)
		var intValue: Int {
			switch self {
			case .wishlist: return 1
			case .bought: return 0
			case .returned: return 3
			case .sold: return 4
			}
		}
	}

	/// `ItemCategory` - What general type of item is it?
	enum ItemCategory: String, Identifiable, Codable, CaseIterable, CustomStringConvertible, Equatable {
		case blouse
		case standardDress
		case longDress
		case bowlOrBag
		case scarfOrShawl
		case otherItem

		var id: Self { self }

		/// `description` for UI elements
		var description: String {
			switch self {
			case .blouse: return "Blouse"
			case .standardDress: return "Standard Dress"
			case .longDress: return "Long Dress"
			case .bowlOrBag: return "Bowl or Bag"
			case .scarfOrShawl: return "Scarf or Shawl"
			case .otherItem: return "Other Item"
			}
		}

		/// `intValue` (to save as integer for sorting purposes)
		var intValue: Int {
			switch self {
			case .blouse: return 1
			case .standardDress: return 2
			case .longDress: return 3
			case .bowlOrBag: return 4
			case .scarfOrShawl: return 5
			case .otherItem: return 6
			}
		}
	}

	/// `SleeveType` - What type of sleeves does it have, if any?
	enum SleeveType: String, Identifiable, Codable, CaseIterable, CustomStringConvertible, Equatable {
		case sleeveless
		case shortSleeves
		case longSleeves
		case notApplicable	// maybe it's a bowl, y'know

		var id: Self { self }

		/// `description` for UI elements
		var description: String {
			switch self {
			case .sleeveless: return "Sleeveless"
			case .shortSleeves: return "Short Sleeves"
			case .longSleeves: return "Long Sleeves"
			case .notApplicable: return "Not Applicable"
			}
		}
	}

	/// `ColorProminance` - How much of this color do we have?
	enum ColorProminance: String, Identifiable, Codable, CaseIterable, CustomStringConvertible, Equatable, Sendable, Comparable {
		case mainColor
		case accentColor
		case bitColor

		var id: Self { self }

		/// `description` for UI elements
		var description: String {
			switch self {
			case .mainColor: return "Main Color"
			case .accentColor: return "Secondary/Accent Color"
			case .bitColor: return "Bit Color"
			}
		}

		static func < (lhs: ColorProminance, rhs: ColorProminance) -> Bool {
			switch (lhs, rhs) {
			case (.mainColor, .accentColor): return true
			case (.mainColor, .bitColor): return true
			case (.accentColor, .bitColor): return true
			default: return false
			}
		}

	}

	@Model
	public class Item: Codable {
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

		var colors: [ItemColor]

		// to backstop sortability until we have the enum thing resolved
		var itemStatusInt: Int = -1
		var itemCategoryInt: Int = -1

		@Attribute(.externalStorage)
		var photo: Data?				// keeping it simple with one photo

		@Attribute(.externalStorage)
		var detailPhoto: Data?			// second photo to show fabric closeup

		@Transient
		static var dateFormatter = DateFormatter()
		@Transient
		static var numberFormatter = NumberFormatter()

		@Transient
		func dateFormatted(_ date: Date?) -> String {
			if let date {
				Item.dateFormatter.timeStyle = .none
				Item.dateFormatter.dateFormat = "yyyy-MM-dd"
				return Item.dateFormatter.string(from: date)
			} else {
				return ""
			}
		}

		@Transient
		func numberFormatted(_ number: Double?) -> String {
			if let number {
				Item.numberFormatter.numberStyle = .currency
//				Item.numberFormatter.currencyCode = currency.rawValue
				Item.numberFormatter.maximumFractionDigits = 2
				Item.numberFormatter.minimumFractionDigits = 2

				let nsnum = NSNumber(value: number)
				return Item.numberFormatter.string(from: nsnum) ?? ""
			} else {
				return ""
			}
		}

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

			if name == "New Item" {
				itemStatusInt = -1		// special value to put at the top of the list
			} else {
				self.itemStatusInt = itemStatus.intValue
			}
			self.itemCategoryInt = itemCategory.intValue

			self.lastModified = Date()
		}

		/// Coding Keys for easier `Codable` conformance.
		enum CodingKeys: CodingKey {
			case name
			case size
			case lastModified
			case itemCategory
			case sleeves
			case itemStatus
			case boughtOn
			case pricePaid
			case soldOn
			case salePrice
			case fabric
			case countryOfOrigin
			case notes
			case photo
			case detailPhoto
			case colors
		}

		/// Required initializer for `Decodable` conformance.
		required public init(from decoder: any Decoder) throws {
			let container = try decoder.container(keyedBy: CodingKeys.self)
			let tempName = try container.decode(String.self, forKey: .name)
			name = tempName
			size = try container.decode(String.self, forKey: .size)
			lastModified = try container.decode(Date.self, forKey: .lastModified)
			let tempitemCategory = try container.decode(ItemCategory.self, forKey: .itemCategory)
			itemCategory = tempitemCategory
			sleeves = try container.decode(SleeveType.self, forKey: .sleeves)
			let tempItemStatus = try container.decode(ItemStatus.self, forKey: .itemStatus)
			itemStatus = tempItemStatus
			boughtOn = try container.decodeIfPresent(Date.self, forKey: .boughtOn)
			pricePaid = try container.decodeIfPresent(Double.self, forKey: .pricePaid)
			soldOn = try container.decodeIfPresent(Date.self, forKey: .soldOn)
			salePrice = try container.decodeIfPresent(Double.self, forKey: .salePrice)
			fabric = try container.decode(String.self, forKey: .fabric)
			countryOfOrigin = try container.decode(String.self, forKey: .countryOfOrigin)
			notes = try container.decode(String.self, forKey: .notes)
			colors = try container.decode([ItemColor].self, forKey: .colors)

			if tempName == "New Item" {
				itemStatusInt = -1		// special value to put at the top of the list
			} else {
				itemStatusInt = tempItemStatus.intValue
			}
			itemCategoryInt = tempitemCategory.intValue

			// TODO: deal with importing/exporting photos.
		}

		/// Required method for `Encodable` conformance.
		public func encode(to encoder: any Encoder) throws {
			var container = encoder.container(keyedBy: CodingKeys.self)
			try container.encode(name, forKey: .name)
			try container.encode(size, forKey: .size)
			try container.encode(lastModified, forKey: .lastModified)
			try container.encode(itemCategory, forKey: .itemCategory)
			try container.encode(sleeves, forKey: .sleeves)
			try container.encode(itemStatus, forKey: .itemStatus)
			try container.encodeIfPresent(boughtOn, forKey: .boughtOn)
			try container.encodeIfPresent(pricePaid, forKey: .pricePaid)
			try container.encodeIfPresent(soldOn, forKey: .soldOn)
			try container.encodeIfPresent(salePrice, forKey: .salePrice)
			try container.encode(fabric, forKey: .fabric)
			try container.encode(countryOfOrigin, forKey: .countryOfOrigin)
			try container.encode(notes, forKey: .notes)
			try container.encode(colors, forKey: .colors)

			// TODO: deal with importing/exporting photos.
		}
	}
}
