//
//  DocumentsView.swift
//  ScannerPro
//
//  Created by Antoine Lucchini on 17/09/2024.
//

import SwiftUI
import SwiftData

struct DocumentsView: View {
    @State private var viewModel: ViewModel
    @State private var path: [Document] = []

    init(modelContext: ModelContext) {
        let viewModel = ViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(viewModel.documents) { document in
                    NavigationLink(value: document){
                        docRow(for: document)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive, action: {
                            viewModel.deleteDoc(document)
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("Documents")
            .navigationDestination(for: Document.self) { document in
                DocumentDetailView(document: document)
            }
            .overlay(alignment: .bottomTrailing, content: {
                scanButton()
            })
            .sheet(isPresented: $viewModel.isScannerPresented, content: {
                ScannerView { result in
                    switch result {
                    case .success(let scannedImages):
                        viewModel.scanDocSuccess(scannedImages)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    viewModel.isScannerPresented = false
                } didCancel: {
                    viewModel.isScannerPresented = false
                }
            })
        }
    }

    private func docRow(for doc: Document) -> some View {
        HStack {
            if let preview = doc.preview {
                Image(uiImage: preview)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipped()
            }
            VStack(alignment: .leading, spacing: 5) {
                Text(doc.name)
                HStack {
                    Text("\(doc.date.formatted(Date.FormatStyle(date: .numeric)))")
                        .font(.system(size: 12))
                        .opacity(0.6)
                }
            }
        }
    }

    private func scanButton() -> some View {
        Button(action: viewModel.showScanner) {
            Image(systemName: "doc.viewfinder")
                 .resizable()
                 .frame(width: 30, height: 30)
                 .padding(25)
                 .foregroundStyle(.white)
                 .background(.blue)
                 .clipShape(Circle())
        }
        .padding(20)
    }
}
