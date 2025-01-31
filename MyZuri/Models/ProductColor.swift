//
//  ProductColor.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 1/30/25.
//

import Foundation
import SwiftData
import Observation
import CoreGraphics

extension MyZuriSchemaV2p1 {
	@Model
	public class ProductColor: Codable {
		var id: UUID
		var name: String					// e.g., "aqua"
		var colorFamily: String			// e.g., "aqua" is a "blue"

		var red: CGFloat
		var green: CGFloat
		var blue: CGFloat
		var alpha: CGFloat

		var item: Item?

		init(id: UUID, name: String, colorFamily: String, red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat, item: Item) {
			self.id = id
			self.name = name
			self.colorFamily = colorFamily
			self.red = red
			self.green = green
			self.blue = blue
			self.alpha = alpha
			self.item = item
		}

		enum CodingKeys: String, CodingKey {
			case id
			case name
			case colorFamily
			case red
			case green
			case blue
			case alpha
		}

		var cgColor: CGColor {
			get {
				return CGColor(red: red, green: green, blue: blue, alpha: alpha)
			}
			set(newColor) {
				if let components = newColor.components {

					if newColor.numberOfComponents == 2 {
						// monochrome
						red = components[0]
						green = components[0]
						blue = components[0]
						alpha = components[1]
					} else {
						// rgb
						red = components[0]
						green = components[1]
						blue = components[2]
						alpha = components[3]
					}
				}
			}
		}

		required public init(from decoder: any Decoder) throws {
			let container = try decoder.container(keyedBy: CodingKeys.self)
			let tempId = try? container.decodeIfPresent(UUID.self, forKey: .id)
			id = tempId ?? UUID()
			name = try container.decode(String.self, forKey: .name)
			colorFamily = try container.decode(String.self, forKey: .colorFamily)
			red = try container.decode(CGFloat.self, forKey: .red)
			green = try container.decode(CGFloat.self, forKey: .red)
			blue = try container.decode(CGFloat.self, forKey: .red)
			alpha = try container.decode(CGFloat.self, forKey: .red)
		}

		public func encode(to encoder: any Encoder) throws {
			var container = encoder.container(keyedBy: CodingKeys.self)
			try container.encode(id, forKey: .id)
			try container.encode(name, forKey: .name)
			try container.encode(colorFamily, forKey: .colorFamily)
			try container.encode(red, forKey: .red)
			try container.encode(green, forKey: .green)
			try container.encode(blue, forKey: .blue)
			try container.encode(alpha, forKey: .alpha)
		}
	}
}
