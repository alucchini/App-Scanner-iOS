# Scanner Pro • Document & PDF

[![Swift](https://img.shields.io/badge/Swift-5.9-orange)](https://developer.apple.com/swift/) [![SwiftUI](https://img.shields.io/badge/SwiftUI-iOS17+-blue)](https://developer.apple.com/xcode/swiftui/)

## Introduction

**Scanner Pro • Document & PDF** is a SwiftUI-based iOS app for scanning, saving, printing, and sharing documents. Built for iOS 17+, it leverages the power of SwiftData to provide fast and reliable document management.

Key Features:
- Scan documents using the camera.
- Save scanned documents locally with SwiftData.
- Print documents directly from the app.
- Share documents via the iOS Share Sheet.
  
## Technologies

This project is powered by:
- **Swift 5.9**
- **SwiftUI** for a declarative UI.
- **SwiftData** for persistent document storage.
- **CoreGraphics** for managing scanned images.

## Table of Contents
1. [Installation](#installation)
2. [Features](#features)
3. [Screenshots](#screenshots)
4. [Code Overview](#code-overview)
5. [How It Works](#how-it-works)
6. [Contributing](#contributing)
7. [License](#license)

## Installation

### Prerequisites
- Xcode 15 or later
- iOS 17+ simulator or device

### Steps
1. Clone the repo:
   ```bash
   git clone https://github.com/alucchini/App-Scanner-iOS.git
   ```
2. Open `ScannerPro.xcodeproj` in Xcode.
3. Build and run the app on an iOS 17+ simulator or device.

## Features

### 1. Scan Documents
   - Use the built-in camera to scan physical documents.
   - The app supports cropping, enhancing the image quality, and handling multiple pages in one scan session.

### 2. Save and Organize Documents
   - Documents are saved locally using **SwiftData**.
   - Each document is tagged with metadata such as name, date, and format.
   - Users can create folders and manage documents in a hierarchical view.

### 3. Print Documents
   - Integrated printing support to print scanned documents in high resolution.
   - The print feature uses **UIPrintInteractionController**.

### 4. Share Documents
   - Share scanned documents in PDF or image format using the native **Share Sheet**.
   - Support for sharing to cloud storage, email, social media, etc.

## Screenshots

| Home Screen | Scan Document | Document Detail | Print Preview |
|-------------|---------------|---------------|---------------|
| ![Home Screen](Screenshots/home.png) | ![Scan Document](Screenshots/scan.png) | ![Document Detail](Screenshots/detail.png) | ![Print Preview](Screenshots/print.png) |

## Code Overview

### 1. Models
The primary model is `Document`, which includes:
```swift
import SwiftData

struct Document: Identifiable {
    var id: UUID
    var name: String
    var date: Date
    var pages: [ImageData]
}
```

This model is saved using **SwiftData** to ensure fast and reliable persistence:
```swift
@MainActor
class DocumentManager: ObservableObject {
    @Published var documents: [Document] = []
    
    func saveDocument(_ document: Document) {
        // Logic to save document to SwiftData
    }
}
```

### 2. Views

- **DocumentsView**: Displays a list of documents, with options to scan or create new folders.
- **DocumentDetailView**: Allows the user to view, rename, and manage individual documents.
  
Here’s how the document list is rendered:
```swift
List {
    ForEach(documents) { document in
        DocumentRow(document: document)
    }
}
```

### 3. Scanning Feature
The scanning functionality is implemented using the **VisionKit** framework for document detection:
```swift
import VisionKit

struct ScannerView: UIViewControllerRepresentable {
    // Implementing VisionKit's scanner to capture documents
}
```

### 4. Printing
Documents are converted to PDFs for printing using **UIPrintInteractionController**:
```swift
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
```

### 5. Sharing
Sharing is done via the native **ShareLink** in SwiftUI:
```swift
ShareLink(item: document, preview: SharePreview("Document", image: previewImage))
```

## How It Works

1. **Document Scanning**: Users can scan documents via the device camera, utilizing **VisionKit** for auto-detection and image processing.
2. **Document Management**: Scanned documents are stored using SwiftData, and can be organized, renamed, or deleted.
3. **Print Integration**: Users can print documents in high quality using iOS’s built-in printing functionality.
4. **Document Sharing**: The app uses **ShareLink** to easily share documents across various apps.

## Contributing

We welcome contributions! Please follow these steps:
1. Fork the repo.
2. Create a feature branch: `git checkout -b feature/your-feature`.
3. Commit your changes: `git commit -m 'Add new feature'`.
4. Push to the branch: `git push origin feature/your-feature`.
5. Submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

N'hésite pas à adapter ce ReadMe selon les spécificités et évolutions de ton projet. Tu peux ajouter plus d'explications si nécessaire ou ajuster les sections selon tes besoins.
