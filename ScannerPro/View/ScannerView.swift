//
//  ScannerView.swift
//  ScannerPro
//
//  Created by Antoine Lucchini on 18/09/2024.
//

import SwiftUI
import VisionKit

struct ScannerView: UIViewControllerRepresentable {
    let didFinishWith: ((_ result: Result<[UIImage], Error>) -> Void)
    let didCancel: () -> Void

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scannerViewController = VNDocumentCameraViewController()

        scannerViewController.delegate = context.coordinator

        return scannerViewController
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {  }


    func makeCoordinator() -> Coordinator {
        Coordinator(with: self)
    }

    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        let scannerView: ScannerView

        init(with scannerView: ScannerView) {
            self.scannerView = scannerView
        }

        // The camera successfully completed a scan.
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            let scannedPages: [UIImage] = (0..<scan.pageCount).compactMap { scan.imageOfPage(at: $0) }

            scannerView.didFinishWith(.success(scannedPages))
        }

        // The user canceled out of the document camera interface.
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            scannerView.didCancel()
        }

        // The document scan failed or was unable to capture a photo.
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            scannerView.didFinishWith(.failure(error))
        }
    }
}
