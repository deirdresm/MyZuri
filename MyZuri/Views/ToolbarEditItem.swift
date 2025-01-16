////
////  ToolbarEditStatus.swift
////  MyZuri
////
////  Created by Deirdre Saoirse Moen on 1/12/25.
////
//
//import SwiftUI
//import SwiftData
//
//struct EditorToolbar: ToolbarContent {
//	let isEnabled: Bool
//	@Binding var editing: Bool
//	@Binding var sortOrder: [SortDescriptor]
//
//	var body: some ToolbarContent {
//		ToolbarItem {
//			if Design.editFeatureEnabled {
//				Button {
//					editing.toggle()
//				} label: {
//					Image(systemName: editing ? "eye.circle" : "pencil.circle" )
//				}
//				.disabled(!isEnabled)
//			} else {
//				EmptyView()
//			}
//		}
//
//		Menu("Sort", systemImage: "arrow.up.arrow.down") {
//			Picker("Sort", selection: $sortOrder) {
//
//				Text("Name")
//					.tag([
//						SortDescriptor(\Item.itemStatusInt),
//						SortDescriptor(\Item.name)
//					])
//
//				Text("Date")
//					.tag([
//						SortDescriptor(\Item.itemStatusInt),
//						SortDescriptor(\Item.boughtOn, order: .reverse),
//						SortDescriptor(\Item.name)
//					])
//				Text("Category")
//					.tag([
//						SortDescriptor(\Item.itemStatusInt),
//						SortDescriptor(\Item.itemCategoryInt),
//						SortDescriptor(\Item.name)
//					])
//
//			} // Picker
//			.pickerStyle(.inline)
//		} // Menu
//
//	}
//}
