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
        DocumentGroup(editing: .myZuriDocument, migrationPlan: MyZuriMigrationPlan.self) {
            ContentView()
        }
    }
}

extension UTType {
	static var myZuriDocument: UTType {
		UTType(importedAs: "net.deirdre.myZuri")
	}
}
