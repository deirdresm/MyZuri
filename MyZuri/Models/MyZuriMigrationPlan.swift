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
    ]

    static var stages: [MigrationStage] = [
        // Stages of migration between VersionedSchema, if required.
    ]
}

struct MyZuriSchemaV1: VersionedSchema {
	static var versionIdentifier = Schema.Version(1, 0, 0)

	static var models: [any PersistentModel.Type] = [
		Item.self
	]
}
