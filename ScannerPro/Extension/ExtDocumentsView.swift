//
//  ExtDocumentsView.swift
//  ScannerPro
//
//  Created by Antoine Lucchini on 18/09/2024.
//

import Foundation
import SwiftUI
import SwiftData

extension DocumentsView {
    @Observable
    class ViewModel {
        var modelContext: ModelContext
        var documents = [Document]()

        var isScannerPresented: Bool = false

        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            fetchData()
        }

        func fetchData() {
            do {
                let descriptor = FetchDescriptor<Document>(sortBy: [SortDescriptor(\.date, order: .reverse)])
                documents = try modelContext.fetch(descriptor)
            } catch {
                print("Fetch failed")
            }
        }

        func showScanner() {
            isScannerPresented.toggle()
        }

        func scanDocSuccess(_ scannedImages: [UIImage]) {
            let imageDataArray = scannedImages.map {
                ImageData(imageData: $0.pngData()!)
            }

            let doc = Document(
                name: "Document",
                images: imageDataArray,
                date: Date()
            )
            modelContext.insert(doc)
            fetchData()
        }

        func deleteDoc(_ document: Document) {
            withAnimation {
                modelContext.delete(document)
            }
            fetchData()
        }
    }
}
