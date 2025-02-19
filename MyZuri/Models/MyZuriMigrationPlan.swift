//
//  MyZuriMigrationPlan.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 12/25/24.
//

import Foundation
import SwiftData

struct MyMigrationPlan: SchemaMigrationPlan {
    static var schemas: [VersionedSchema.Type] = [
		MyZuriSchemaV1.self,
		MyZuriSchemaV2.self,
		MyZuriSchemaV2p1.self,
		MyZuriSchemaV2p2.self,
		MyZuriSchemaV2p3.self
    ]

    static var stages: [MigrationStage] = [
        // Stages of migration between VersionedSchema, if required.
		migrateV1toV2,
		migrateV2toV2p1,
		migrateV2p1toV2p2,
		migrateV2p2toV2p3,
    ]

	static let migrateV2p2toV2p3 = MigrationStage.custom(
		fromVersion: MyZuriSchemaV2p2.self,
		toVersion: MyZuriSchemaV2p3.self,
		willMigrate: nil,
		didMigrate: { context in
			if let items = try? context.fetch(FetchDescriptor<MyZuriSchemaV2p3.Item>()) {

				for item in items {
					if item.boughtOn != nil {
						item.wishlistStatus = WishlistStatus.none // not on the wishlist
						item.wishlistStatusInt = -1
					} else {
						item.wishlistStatus = .newItem // sensible default
						item.wishlistStatusInt = 0
					}

					for pc in item.itemColors {
						pc.createdAt = Date()
					}
					try? context.save()
				}
			}
			try? context.save()
		}
	)

	static let migrateV2p1toV2p2 = MigrationStage.custom(
		fromVersion: MyZuriSchemaV2p1.self,
		toVersion: MyZuriSchemaV2p2.self,
		willMigrate: nil,
		didMigrate: { context in
			if let items = try? context.fetch(FetchDescriptor<MyZuriSchemaV2p2.Item>()) {

				for item in items {
					item.isNewItem = false
					item.itemCategoryText = item.itemCategory.description
					item.sleeveTypeText = item.sleeves.description
					item.itemStatusText = item.itemStatus.description
					try? context.save()
				}
			}
			try? context.save()
		}
	)

	static let migrateV2toV2p1 = MigrationStage.custom(
		fromVersion: MyZuriSchemaV2.self,
		toVersion: MyZuriSchemaV2p1.self,
		willMigrate: nil,
		didMigrate: { context in
			if let items = try? context.fetch(FetchDescriptor<MyZuriSchemaV2p1.Item>()) {

				for item in items {

					if item.colors.count > 0 {
						item.itemColors = [MyZuriSchemaV2p1.ProductColor]()
						item.makeProductColorsFromItemColors()
						item.colors = []
						try? context.save()
					}

				}
			}
			try? context.save()
		}
	)

	static let migrateV1toV2 = MigrationStage.custom(
		fromVersion: MyZuriSchemaV1.self,
		toVersion: MyZuriSchemaV2.self,
		willMigrate: nil,
		didMigrate: { context in
			if let items = try? context.fetch(FetchDescriptor<MyZuriSchemaV2.Item>()) {

				for item in items {
					if item.name == "New Item" {
						item.itemStatusInt = -1
					} else {
						item.itemStatusInt = item.itemStatus.intValue
					}

					item.itemCategoryInt = item.itemCategory.intValue
				}
			}
		}
	)
}

struct MyZuriSchemaV1: VersionedSchema {
	static var versionIdentifier = Schema.Version(1, 0, 0)

	static var models: [any PersistentModel.Type] = [
		MyZuriSchemaV1.Item.self
	]
}

struct MyZuriSchemaV2: VersionedSchema {
	static var versionIdentifier = Schema.Version(2, 0, 0)

	static var models: [any PersistentModel.Type] = [
		MyZuriSchemaV2.Item.self
	]
}

// 2p1: Add ProductColor
struct MyZuriSchemaV2p1: VersionedSchema {
	static var versionIdentifier = Schema.Version(2, 1, 0)

	static var models: [any PersistentModel.Type] = [
		MyZuriSchemaV2p1.Item.self,
		MyZuriSchemaV2p1.ProductColor.self
	]
}


// 2p2: Remove ItemColor
struct MyZuriSchemaV2p2: VersionedSchema {
	static var versionIdentifier = Schema.Version(2, 2, 0)

	static var models: [any PersistentModel.Type] = [
		MyZuriSchemaV2p2.Item.self,
		MyZuriSchemaV2p2.ProductColor.self
	]
}

// 2p3: Several changes:
// * Add URL field for clickable URLs
// * Add enum (WishlistType) for Wishlish Item Sorting
struct MyZuriSchemaV2p3: VersionedSchema {
	static var versionIdentifier = Schema.Version(2, 3, 0)

	static var models: [any PersistentModel.Type] = [
		MyZuriSchemaV2p3.Item.self,
		MyZuriSchemaV2p3.ProductColor.self
	]
}
