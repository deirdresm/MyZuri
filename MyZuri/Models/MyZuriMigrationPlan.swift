//
//  MyZuriMigrationPlan.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 12/25/24.
//

import SwiftData

struct MyMigrationPlan: SchemaMigrationPlan {
    static var schemas: [VersionedSchema.Type] = [
		MyZuriSchemaV1.self
    ]

    static var stages: [MigrationStage] = [
        // Stages of migration between VersionedSchema, if required.
    ]

//	static let migrateV1toV2 = MigrationStage.custom(
//		fromVersion: MyZuriSchemaV1.self,
//		toVersion: MyZuriSchemaV2.self,
//		willMigrate:  { context in
//			print("Executing willMigrate for migrateV1toV2")
//		}, didMigrate: { context in
//			print("Executing didMigrate for migrateV1toV2")
//			let items = try context.fetch(FetchDescriptor<MyZuriSchemaV2.Item>())
//
//			for item in items {
//				if let boughtDate = item.boughtOn {
//					if let soldDate = item.soldOn {
//						item.itemStatus = ItemStatus.sold
//					} else {
//						item.itemStatus = ItemStatus.bought
//					}
//				} else {
//					item.itemStatus = ItemStatus.wishlist
//				}
//				print("Set status for \(item.name) to \(item.itemStatus.description)")
//			}
//
//			try context.save()
//	  }
//	)

}

struct MyZuriSchemaV1: VersionedSchema {
	static var versionIdentifier = Schema.Version(1, 0, 0)

	static var models: [any PersistentModel.Type] = [
		Item.self,
		ItemColor.self
	]
}
