
import SwiftUI
import PDFKit

// Handles the export of greeting cards to various formats like PNG, GIF, and PDF.
@Observable
final class ExportService {

    enum ExportError: Error, LocalizedError {
        case renderingFailed
        case pdfCreationFailed
        case invalidView
        
        var errorDescription: String? {
            switch self {
            case .renderingFailed: return "Failed to render the view as an image."
            case .pdfCreationFailed: return "Could not create a PDF document from the rendered image."
            case .invalidView: return "The view provided for export is not valid."
            }
        }
    }

    // Exports a SwiftUI view as a PNG image.
    @MainActor
    func exportAsPNG(view: some View) throws -> Data {
        let renderer = ImageRenderer(content: view)
        
        // Ensure the view has a defined size. For this example, we'll use a standard 5x7 inch ratio.
        renderer.proposedSize = .init(width: 5 * 72, height: 7 * 72) // 72 dpi
        
        guard let uiImage = renderer.uiImage else {
            throw ExportError.renderingFailed
        }
        
        guard let pngData = uiImage.pngData() else {
            throw ExportError.renderingFailed
        }
        
        return pngData
    }

    // Exports a SwiftUI view as a high-resolution PDF for printing.
    @MainActor
    func exportAsPDF(view: some View) throws -> Data {
        // A6 size in points (105mm x 148mm)
        let a6Width: CGFloat = 105 * (72 / 25.4)
        let a6Height: CGFloat = 148 * (72 / 25.4)
        let pageRect = CGRect(x: 0, y: 0, width: a6Width, height: a6Height)

        let renderer = ImageRenderer(content:
            view
                .frame(width: pageRect.width - 32, height: pageRect.height - 32) // Add margins
                .overlay(
                    // Add fold lines for a bifold card
                    HStack {
                        Spacer()
                        Rectangle().frame(width: 1).foregroundColor(.gray.opacity(0.5))
                        Spacer()
                    }
                )
                .padding(16)
        )
        
        renderer.proposedSize = .init(width: pageRect.width, height: pageRect.height)

        let pdfData = NSMutableData()
        
        guard let consumer = CGDataConsumer(data: pdfData) else {
            throw ExportError.pdfCreationFailed
        }

        var mediaBox = pageRect
        guard let pdfContext = CGContext(consumer: consumer, mediaBox: &mediaBox, nil) else {
            throw ExportError.pdfCreationFailed
        }

        pdfContext.beginPDFPage(nil)
        renderer.render { size, renderer in
            renderer(pdfContext)
        }
        pdfContext.endPDFPage()
        pdfContext.closePDF()

        return pdfData as Data
    }
}

// Shareable item for use with ShareLink
struct ShareableView: Transferable {
    let data: Data
    let name: String
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .png) { item in
            item.data
        }
        .suggestedFileName(self.name)
    }
}
