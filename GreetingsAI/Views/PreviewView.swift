
import SwiftUI

// A view for previewing the final card and accessing export options.
struct PreviewView: View {

    @Bindable var viewModel: CreationViewModel
    @State private var exportService = ExportService()
    
    // The view content to be exported
    var cardView: some View {
        FinalCardView(
            image: viewModel.generatedImageData.flatMap(UIImage.init),
            message: viewModel.generatedMessage
        )
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: Theme.Spacing.large) {
                // MARK: - Live Preview
                Text("Live Preview")
                    .font(Theme.Fonts.bold(size: 24))
                
                cardView
                    .aspectRatio(5/7, contentMode: .fit)
                    .frame(width: 300)
                    .cornerRadius(Theme.CornerRadius.large)
                    .shadow(radius: 5)
                
                Spacer()

                // MARK: - Export Options
                VStack(spacing: Theme.Spacing.medium) {
                    Text("Export Options")
                        .font(Theme.Fonts.bold(size: 20))

                    // ShareLink for easy sharing (PNG)
                    if let data = try? exportService.exportAsPNG(view: cardView) {
                        let shareable = ShareableView(data: data, name: "GreetingCard.png")
                        ShareLink(item: shareable, preview: SharePreview("My Greeting Card", image: Image(uiImage: UIImage(data: data)!))) {
                            Label("Share as Image", systemImage: "square.and.arrow.up")
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    // PDF Export Button
                    Button("Export as PDF for Print") {
                        // TODO: Implement PDF sharing/saving logic
                        if let pdfData = try? exportService.exportAsPDF(view: cardView) {
                            // Use ShareLink or other methods to handle the PDF data
                            print("PDF Generated with size: \(pdfData.count) bytes")
                        }
                    }
                    .buttonStyle(.bordered)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Preview & Export")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        // Dismiss the sheet
                    }
                }
            }
        }
    }
}

// The actual visual representation of the final card.
struct FinalCardView: View {
    let image: UIImage?
    let message: String
    
    var body: some View {
        ZStack {
            // Background Image
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Color.gray.opacity(0.2)
            }
            
            // Message Overlay
            VStack {
                Spacer()
                Text(message)
                    .font(.custom("Zapfino", size: 22)) // Example of a custom font
                    .foregroundColor(.black.opacity(0.7))
                    .padding()
                    .background(.white.opacity(0.5))
                    .cornerRadius(10)
                    .padding()
            }
        }
    }
}


#Preview {
    PreviewView(viewModel: CreationViewModel())
}
