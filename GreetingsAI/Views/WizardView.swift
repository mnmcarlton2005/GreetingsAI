
import SwiftUI

// A step-by-step wizard to guide users through the card creation process.
struct WizardView: View {

    @State var viewModel = CreationViewModel()
    
    // State to control navigation to the editor
    @State private var navigateToEditor = false
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Card Details")) {
                    // Recipient
                    TextField("Recipient's Name (e.g., Jane)", text: $viewModel.recipient)
                    
                    // Occasion
                    Picker("Occasion", selection: $viewModel.occasion) {
                        ForEach(Occasion.allCases) { occasion in
                            Text(occasion.displayName).tag(occasion)
                        }
                    }
                    
                    // Style
                    Picker("Style", selection: $viewModel.style) {
                        ForEach(AppStyle.allCases) { style in
                            Text(style.displayName).tag(style)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    // Mood
                    TextField("Mood or Vibe (e.g., Joyful, serene)", text: $viewModel.mood)
                }
            }
            
            // Action Button
            if viewModel.isLoading {
                ProgressView("Generating ideas...")
            } else {
                Button("Generate Card Ideas", action: {
                    Task {
                        await viewModel.generateContent()
                        if viewModel.errorMessage == nil {
                            navigateToEditor = true
                        }
                    }
                })
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.recipient.isEmpty || viewModel.mood.isEmpty)
            }
            
            // Error Message
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
        }
        .navigationTitle("Create Your Card")
        .navigationDestination(isPresented: $navigateToEditor) {
            EditorView(viewModel: viewModel)
        }
    }
}

#Preview {
    NavigationStack {
        WizardView()
    }
}
