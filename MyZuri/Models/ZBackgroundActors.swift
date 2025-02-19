//
//  ZBackgroundActors.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 2/16/25.
//

import Foundation
import Cocoa
import SwiftData
import UniformTypeIdentifiers
import ImageIO


actor BackgroundImporter {
	var itemModelActor: ItemModelActor
	var itemColorModelActor: ColorModelActor

	init(modelContainer: ModelContainer) async throws {
//		self.imageManager = ImageManager()

		itemModelActor = ItemModelActor(modelContainer: modelContainer)
//		try? await itemModelActor.insertPreload()

		itemColorModelActor = ColorModelActor(modelContainer: modelContainer)
//		try? await itemColorModelActor.insertPreload()
	}
}


@ModelActor public actor ColorModelActor {
//	private let fm = FileManager.default

}

@ModelActor public actor ItemModelActor {
	private let fm = FileManager.default

	func wishlistFix() async throws {
		let items = try? modelContext.fetch(FetchDescriptor<Item>(predicate: #Predicate { item in
			item.wishlistStatus == nil
		}))

		if let itemsCount = items?.count {
			for index in 0..<itemsCount {
				if let item = items?[index] {

					if item.boughtOn != nil {
						item.wishlistStatus = WishlistStatus.none
						item.wishlistStatusInt = item.wishlistStatus!.intValue
					} else {
						item.wishlistStatus = .newItem
						item.wishlistStatusInt = item.wishlistStatus!.intValue
					}
					try? modelContext.save()
				}
			}
		}
	}

/*	func insertPreload(imageManager: ImageManager) async throws {
		var bagFetchDescriptor = FetchDescriptor<Bag>()
		bagFetchDescriptor.fetchLimit = 1

		if ((try? modelContext.fetch(bagFetchDescriptor).count == 0) != nil) {
			try await Task.sleep(for: .milliseconds(3))
			for bagDTO in BagDTO.preload {
				let bag = Bag(from: bagDTO, context: modelContext)
				bag.image = imageManager.getBagImage(
						productCode: bag.bagStyle.styleCode,
						textureCode: bag.bagColor.textureCode,
						colorCode: bag.bagColor.colorCode
				)

				modelContext.insert(bag)
			}
			try? modelContext.save()
		}
	}
 */
}

extension Item {
	static let preload: [Item] = []
}

extension ProductColor {
	static let preload: [ProductColor] = []
}
