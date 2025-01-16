//
//  ItemV1.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 1/11/25.
//

import Foundation
import SwiftData

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

	/// `ColorProminance` - How much of this color do we have?
	enum ColorProminance: String, Identifiable, Codable, CaseIterable, CustomStringConvertible {
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
	}

	/// `ItemColor` holds information about the colors in the piece.
	public struct ItemColor: Codable {
		var name: String					// e.g., "aqua"
		var colorFamily: String			// e.g., "aqua" is a "blue"
		var hexColor: String				// for this specific item's variant of that color
		var prevalence: ColorProminance		// how prominent is this color?
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
			name = try container.decode(String.self, forKey: .name)
			size = try container.decode(String.self, forKey: .size)
			lastModified = try container.decode(Date.self, forKey: .lastModified)
			itemCategory = try container.decode(ItemCategory.self, forKey: .itemCategory)
			sleeves = try container.decode(SleeveType.self, forKey: .sleeves)
			itemStatus = try container.decode(ItemStatus.self, forKey: .itemStatus)
			boughtOn = try container.decodeIfPresent(Date.self, forKey: .boughtOn)
			pricePaid = try container.decodeIfPresent(Double.self, forKey: .pricePaid)
			soldOn = try container.decodeIfPresent(Date.self, forKey: .soldOn)
			salePrice = try container.decodeIfPresent(Double.self, forKey: .salePrice)
			fabric = try container.decode(String.self, forKey: .fabric)
			countryOfOrigin = try container.decode(String.self, forKey: .countryOfOrigin)
			notes = try container.decode(String.self, forKey: .notes)
			colors = try container.decode([ItemColor].self, forKey: .colors)

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
