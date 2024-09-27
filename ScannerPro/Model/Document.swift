//
//  Document.swift
//  ScannerPro
//
//  Created by Antoine Lucchini on 17/09/2024.
//

import Foundation
import SwiftData
import UIKit

@Model
final class Document {
    var name: String
    var images: [ImageData]
    var date: Date

    init(name: String, images: [ImageData], date: Date) {
        self.name = name
        self.images = images
        self.date = date
    }

    var preview: UIImage? {
        return images.first?.image
    }
}

@Model
final class ImageData {
    var imageData: Data

    init(imageData: Data) {
        self.imageData = imageData
    }

    var image: UIImage? {
        return UIImage(data: imageData)
    }
}
