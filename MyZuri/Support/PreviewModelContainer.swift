//
//  PreviewModelContainer.swift
//  MyZuri
//
//  Created by Deirdre Saoirse Moen on 1/11/25.
//

import SwiftData

/// Because this is a document-based app, the `DocumentGroup` has special magic for creating
/// the `ModelContainer` specific to that document. For previews, though, it needs to be explicitly
/// created, plus this imports sample data.

@MainActor
let previewContainer: ModelContainer = {
	do {
		let container = try ModelContainer(
			for: Item.self,
			configurations: ModelConfiguration(isStoredInMemoryOnly: true)
		)
		let modelContext = container.mainContext
		if try modelContext.fetch(FetchDescriptor<Item>()).isEmpty {
//			SampleDeck.contents.forEach { container.mainContext.insert($0) }
		}
		return container
	} catch {
		fatalError("Failed to create container")
	}
}()
