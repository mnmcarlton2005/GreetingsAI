
import SwiftUI
import PhotosUI

// An editor view for advanced customization of the generated card.
struct EditorView: View {
    
    @Bindable var viewModel: CreationViewModel
    @Environment(AuthViewModel.self) private var authViewModel
    
    @State private var showPreview = false

    var body: some View {
        ScrollView {
            VStack(spacing: Theme.Spacing.medium) {
                // MARK: - Image Preview
                ZStack {
                    if let imageData = viewModel.generatedImageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(Theme.CornerRadius.medium)
                            .shadow(radius: 3)
                    } else if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Color.gray.opacity(0.2)
                            .cornerRadius(Theme.CornerRadius.medium)
                        Text("No Image")
                    }
                }
                .frame(height: 300)
                
                // MARK: - Controls
                VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                    Text("Customize Your Card")
                        .font(Theme.Fonts.bold(size: 22))

                    // Image Prompt
                    Text("AI Image Prompt")
                        .font(Theme.Fonts.medium(size: 16))
                    TextEditor(text: $viewModel.generatedImagePrompt)
                        .frame(height: 100)
                        .border(Color.gray, width: 0.5)
                        .cornerRadius(Theme.CornerRadius.small)

                    // Regenerate Image Button
                    Button("Regenerate Image", systemImage: "arrow.clockwise") {
                        Task { await viewModel.generateImage() }
                    }
                    .buttonStyle(.bordered)
                    
                    // Custom Image Picker
                    PhotosPicker(
                        selection: $viewModel.customImage,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        Label("Upload Your Own Image", systemImage: "photo.on.rectangle")
                    }
                    .buttonStyle(.bordered)
                    
                    // Message Editor
                    Text("Card Message")
                        .font(Theme.Fonts.medium(size: 16))
                    TextEditor(text: $viewModel.generatedMessage)
                        .frame(height: 100)
                        .border(Color.gray, width: 0.5)
                        .cornerRadius(Theme.CornerRadius.small)
                }
                .padding(.horizontal)
                
                Spacer()

                // MARK: - Action Buttons
                HStack {
                    Button("Preview & Export") {
                        showPreview = true
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Save to Library") {
                        guard let userId = authViewModel.user?.id else { return }
                        Task {
                            await viewModel.saveCard(userId: userId)
                            // Optionally, navigate away or show a confirmation
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
        }
        .navigationTitle("Editor")
        .sheet(isPresented: $showPreview) {
            PreviewView(viewModel: viewModel)
        }
    }
}

#Preview {
    NavigationStack {
        EditorView(viewModel: CreationViewModel())
            .environment(AuthViewModel())
    }
}
