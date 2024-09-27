//
//  DocumentDetailView.swift
//  ScannerPro
//
//  Created by Antoine Lucchini on 18/09/2024.
//

import SwiftUI
import SwiftData

struct DocumentDetailView: View {
    @StateObject private var viewModel: ViewModel
    @State private var showImageList = false
    var document: Document

    init(document: Document) {
        _viewModel = StateObject(wrappedValue: ViewModel())
        self.document = document
    }

    var body: some View {
        HStack {
            ScrollView {
                VStack {
                    ForEach(document.images, id: \.imageData) { imageData in
                        if let image = imageData.image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            Spacer()
            VStack {
                if showImageList {
                    VStack(spacing: 10) {
                        Text("\(document.images.count) pages")
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                        ScrollView {
                            ForEach(document.images, id: \.imageData) { imageData in
                                if let image = imageData.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .padding(.bottom, 10)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: 125)
                    .background(Color.gray.opacity(0.2))
                }
                Spacer()
            }
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Menu {
                    Button(action : {
                        viewModel.showRenameAlert()
                    }) {
                        Label("Rename", systemImage: "pencil")
                    }
                    ShareLink(item: viewModel.generatePDF(from: document.images.compactMap { $0.image })!) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                    Button(action: {
                        viewModel.printDocument(document: document)
                    }) {
                        Label("Print", systemImage: "printer")
                    }
                } label: {
                    HStack {
                        Text(document.name)
                            .bold()
                        Image(systemName: "chevron.down.circle.fill")
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    withAnimation {
                        showImageList.toggle()
                    }
                }) {
                    Image(systemName: "list.bullet")
                }
            }
        }
        .alert("Rename the document", isPresented: $viewModel.isRenameAlertPresented) {
            TextField("", text: $viewModel.newDocumentName)
            Button("OK") { viewModel.changeDocName(document) }
            Button("Cancel", role: .cancel) {}
        }
    }
}
