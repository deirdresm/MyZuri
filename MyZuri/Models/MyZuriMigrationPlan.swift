//
//  MyZuriMigrationPlan.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 12/25/24.
//

import SwiftData

struct MyMigrationPlan: SchemaMigrationPlan {
    static var schemas: [VersionedSchema.Type] = [
		MyZuriSchemaV1.self,
		MyZuriSchemaV2.self,
    ]

    static var stages: [MigrationStage] = [
        // Stages of migration between VersionedSchema, if required.
		migrateV1toV2
    ]

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
		Item.self
	]
}

struct MyZuriSchemaV2: VersionedSchema {
	static var versionIdentifier = Schema.Version(2, 0, 0)

	static var models: [any PersistentModel.Type] = [
		Item.self
	]
}
