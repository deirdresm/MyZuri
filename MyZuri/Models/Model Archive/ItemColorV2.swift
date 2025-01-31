//
//  ItemColorV2.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 1/30/25.
//

import Foundation
import SwiftData
import Observation
import CoreGraphics

extension MyZuriSchemaV2 {

	// TODO: need a DTO for between-contexts?
	/// `ItemColor` holds information about the colors in the piece.
	@Observable final class ItemColor: Identifiable, Codable, Equatable, Comparable, Hashable, Sendable {
		var id: UUID
		var name: String					// e.g., "aqua"
		var colorFamily: String			// e.g., "aqua" is a "blue"
		var prevalence: ColorProminance		// how prominent is this color?

		var red: CGFloat
		var green: CGFloat
		var blue: CGFloat
		var alpha: CGFloat

		init(name: String, colorFamily: String, prevalence: ColorProminance, red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
			self.id = UUID()
			self.name = name
			self.colorFamily = colorFamily
			self.prevalence = prevalence
			self.red = red
			self.green = green
			self.blue = blue
			self.alpha = alpha
		}

		var hexColor: String {
			String(format: "#%02lX%02lX%02lX",
				   lroundf(Float(red * 255)),
				   lroundf(Float(green * 255)),
				   lroundf(Float(blue * 255)))
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

		// Comparable conformance
		static func < (lhs: ItemColor, rhs: ItemColor) -> Bool {
			if lhs.prevalence != rhs.prevalence {
				return lhs.prevalence < rhs.prevalence
			}
			return lhs.name < rhs.name
		}

		// Equatable conformance
		static func == (lhs: MyZuriSchemaV2.ItemColor, rhs: MyZuriSchemaV2.ItemColor) -> Bool {
			return lhs.name == rhs.name && lhs.hexColor == rhs.hexColor
		}

		func hash(into hasher: inout Hasher) {
			hasher.combine(id)
			hasher.combine(name)
		}
	}
}
