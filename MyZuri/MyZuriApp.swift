//
//  MyZuriApp.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 12/25/24.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

@main
struct MyZuriApp: App {
    var body: some Scene {
        DocumentGroup(editing: .itemDocument, migrationPlan: MyZuriMigrationPlan.self) {
            ContentView()
        }
    }
}

extension UTType {
    static var itemDocument: UTType {
        UTType(importedAs: "com.example.item-document")
    }
}

struct MyZuriMigrationPlan: SchemaMigrationPlan {
    static var schemas: [VersionedSchema.Type] = [
        MyZuriVersionedSchema.self,
    ]

    static var stages: [MigrationStage] = [
        // Stages of migration between VersionedSchema, if required.
    ]
}

struct MyZuriVersionedSchema: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)

    static var models: [any PersistentModel.Type] = [
        Item.self,
    ]
}
