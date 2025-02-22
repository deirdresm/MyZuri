//
//  Item.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 12/25/24.
//

import Foundation
import SwiftData

typealias Item = MyZuriSchemaV2p3.Item
typealias ItemCategory = MyZuriSchemaV2p3.ItemCategory
typealias SleeveType = MyZuriSchemaV2p3.SleeveType
typealias ItemStatus = MyZuriSchemaV2p3.ItemStatus
typealias ProductColor = MyZuriSchemaV2p3.ProductColor
typealias WishlistStatus = MyZuriSchemaV2p3.WishlistStatus

extension MyZuriSchemaV2p3 {

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

		/// `getCategory` (returns an enum instance from a `String`)
		static func getCategory(_ string: String) -> ItemCategory {
			if string == "Blouse" {
				return .blouse
			} else if string == "Standard Dress" {
				return .standardDress
			} else if string == "Long Dress" {
				return .longDress
			} else if string == "Bowl or Bag" {
				return .bowlOrBag
			} else if string == "Scarf or Shawl" {
				return .scarfOrShawl
			} else if string == "Other Item" {
				return .otherItem
			}
			return .blouse
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

	enum WishlistStatus: String, Identifiable, Codable, CaseIterable, CustomStringConvertible, Equatable, Comparable {

		case none
		case newItem
		case stillOnSite
		case recentlyDiscontinued
		case soldOut
		case unicorn

		var id: Self { self }
		
		var description: String {
			switch self {
			case .none: return "None"
			case .newItem: return "New Item"
			case .stillOnSite: return "Still On Site"
			case .soldOut: return "Sold Out In My Size"
			case .recentlyDiscontinued: return "Recently Discontinued"
			case .unicorn: return "Unicorn"
			}
		}

		var intValue: Int {
			switch self {
			case .none: return -1
			case .newItem: return 0
			case .stillOnSite: return 1
			case .soldOut: return 2
			case .recentlyDiscontinued: return 3
			case .unicorn: return 4
			}
		}

		/// use `intValue` so we can have cases out of alphabetical order
		static func ==(lhs: WishlistStatus, rhs: WishlistStatus) -> Bool {
			return lhs.intValue == rhs.intValue
		}

		/// use `intValue` so we can have cases out of alphabetical order
		static func < (lhs: WishlistStatus, rhs: WishlistStatus) -> Bool {
			return lhs.intValue < rhs.intValue
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

		// following added in V2p1
		var itemColors: [ProductColor]

		// following added in V2p2
		var isNewItem: Bool = false
		var itemStatusText: String = ""
		var sleeveTypeText: String = ""
		var itemCategoryText: String = ""

		var wishlistStatus: WishlistStatus?
		var wishlistStatusInt: Int = -1
		var url: URL?

		@Attribute(.externalStorage)
		var photo: Data?				// keeping it simple with one photo

		@Attribute(.externalStorage)
		var detailPhoto: Data?			// second photo to show fabric closeup

		@Transient
		var urlPath: String {
			get { url?.absoluteString ?? "" }
			set(newPath) {
				if let newPathURL = URL(string: newPath) {
					url = newPathURL
				} // else do nothing.
			}
		}

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

		init(	name: String = "New Item",
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
				url: URL? = nil,
				photo: Data? = nil,
				detailPhoto: Data? = nil,
				itemColors: [ProductColor] = []
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
			self.url = url

			self.photo = photo
			self.detailPhoto = detailPhoto

			self.itemColors = itemColors

			if name == "New Item" {
				isNewItem = true
			} else {
				isNewItem = false
			}
			itemStatusText = itemStatus.description
			sleeveTypeText = sleeves.description
			itemCategoryText = itemCategory.description

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
			case url
			case photo
			case detailPhoto
			case colors
			case itemColors
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
			url = try container.decode(URL.self, forKey: .url)
			itemColors = try container.decode([ProductColor].self, forKey: .itemColors)

			if tempName == "New Item" {
				itemStatusText = ""		// special value to put at the top of the list
			} else {
				itemStatusText = tempItemStatus.description
			}
			itemCategoryText = tempitemCategory.description

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
			try container.encode(url, forKey: .url)
			try container.encode(itemColors, forKey: .itemColors)
		}
	}
}
