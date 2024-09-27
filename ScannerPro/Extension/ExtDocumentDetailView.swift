//
//  ExtDocumentDetailView.swift
//  ScannerPro
//
//  Created by Antoine Lucchini on 18/09/2024.
//

import Foundation
import SwiftUI
import SwiftData
import PDFKit

extension DocumentDetailView {
    class ViewModel: ObservableObject {
        @Published var newDocumentName: String = ""
        @Published var isRenameAlertPresented: Bool = false

        func showRenameAlert() {
            isRenameAlertPresented.toggle()
        }

        func changeDocName(_ document: Document) {
            if !newDocumentName.isEmpty {
                document.name = newDocumentName
            }
        }

        func generatePDF(from images: [UIImage]) -> URL? {
            let pdfDocument = PDFDocument()

            for (index, image) in images.enumerated() {
                let pdfPage = PDFPage(image: image)
                pdfDocument.insert(pdfPage!, at: index)
            }

            // Save the PDF to the temporary folder
            let tempDirectory = FileManager.default.temporaryDirectory
            let pdfURL = tempDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("pdf")

            do {
                try pdfDocument.dataRepresentation()?.write(to: pdfURL)
                return pdfURL
            } catch {
                print("Erreur lors de la génération du PDF : \(error)")
                return nil
            }
        }

        func printDocument(document: Document) {
            // Check if the document contains images
            guard !document.images.isEmpty else {
                print("Aucune image à imprimer")
                return
            }

            // Create an array of UIImages from document data
            let imagesToPrint = document.images.compactMap { $0.image }

            // Generate a PDF from images
            if let pdfURL = generatePDF(from: imagesToPrint) {
                // Create a UIPrintInteractionController to handle printing
                let printController = UIPrintInteractionController.shared

                // Configure print information
                let printInfo = UIPrintInfo(dictionary: nil)
                printInfo.jobName = document.name
                printInfo.outputType = .general
                printController.printInfo = printInfo

                // Provide the content to print (the PDF file)
                if let pdfData = try? Data(contentsOf: pdfURL) {
                    printController.printingItem = pdfData
                } else {
                    print("Erreur lors de la récupération des données du PDF")
                }

                // Show Print Dialog
                printController.present(animated: true, completionHandler: nil)
            } else {
                print("Erreur lors de la génération du PDF pour l'impression")
            }
        }
    }
}
