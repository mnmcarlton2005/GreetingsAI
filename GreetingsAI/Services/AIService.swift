
import Foundation

// Manages all interactions with the Google Gemini API.
@Observable
final class AIService {
    
    // Placeholder for the API Key.
    // IMPORTANT: In a real app, this should be stored securely and not hardcoded.
    // e.g., loaded from an environment variable or a configuration file.
    private let apiKey = ""
    private let apiURL = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent")!

    enum AIError: Error, LocalizedError {
        case invalidAPIKey
        case requestFailed(statusCode: Int)
        case decodingError(Error)
        case noContentGenerated
        case unexpectedResponse
        case retriesExhausted
        
        var errorDescription: String? {
            switch self {
            case .invalidAPIKey: return "Invalid API Key. Please check your configuration."
            case .requestFailed(let code): return "The AI service request failed with status code: \(code)."
            case .decodingError: return "Failed to process the response from the AI service."
            case .noContentGenerated: return "The AI service did not generate any content."
            case .unexpectedResponse: return "Received an unexpected response structure from the AI service."
            case .retriesExhausted: return "All retry attempts to connect to the AI service have failed."
            }
        }
    }

    // Generates a descriptive prompt and a poetic message for a greeting card.
    func generateCardContent(occasion: Occasion, theme: AppStyle, mood: String, recipient: String) async throws -> (imagePrompt: String, message: String) {
        let systemPrompt = """
        You are a creative assistant specializing in crafting prompts for an AI image generator and writing heartfelt greeting card messages.
        
        Instructions:
        1. Based on the user's input, generate a highly descriptive and artistic prompt for an AI image generator (like Imagen or DALL-E). This prompt should be detailed, focusing on visual elements, style, and composition.
        2. Write a short, poetic, and emotionally resonant message for the greeting card that matches the theme and occasion.
        3. Return the output as a JSON object with two keys: "imagePrompt" and "message".
        
        Example Input:
        - Occasion: Birthday
        - Recipient: Friend
        - Theme: Minimalist
        - Mood: Joyful
        
        Example Output:
        {
          "imagePrompt": "A single, elegant watercolor splash of vibrant yellow and pink on a textured off-white background, minimalist, clean, celebrating a joyful moment, studio lighting.",
          "message": "Wishing you a day as bright and beautiful as you are. Happy Birthday!"
        }
        """
        
        let userPrompt = "Occasion: \(occasion.displayName), Recipient: \(recipient), Theme: \(theme.displayName), Mood: \(mood)"
        
        let fullPrompt = "\(systemPrompt)

User Input:
\(userPrompt)"
        
        let responseText = await performTextGeneration(prompt: fullPrompt)
        
        // Basic parsing of the JSON response. In a real app, use Codable.
        guard let data = responseText.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let imagePrompt = json["imagePrompt"] as? String,
              let message = json["message"] as? String else {
            throw AIError.decodingError(NSError(domain: "ParsingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse imagePrompt and message from AI response."]))
        }
        
        return (imagePrompt, message)
    }

    // Generates an image from a given prompt.
    // NOTE: This is a placeholder. You would replace this with the actual Imagen/Gemini Image API call.
    func generateImage(prompt: String) async throws -> Data {
        // This is where you would call the image generation API.
        // For now, we will return a placeholder image.
        let placeholderURL = URL(string: "https://picsum.photos/512")!
        let (data, _) = try await URLSession.shared.data(from: placeholderURL)
        return data
    }
    
    // Core function to perform text generation with exponential backoff.
    private func performTextGeneration(prompt: String) async -> String {
        let maxRetries = 5
        var currentRetry = 0
        var delay: TimeInterval = 1.0 // Initial delay of 1 second

        while currentRetry < maxRetries {
            do {
                return try await makeAPIRequest(prompt: prompt)
            } catch {
                print("API call failed (attempt \(currentRetry + 1)/\(maxRetries)): \(error.localizedDescription)")
                currentRetry += 1
                if currentRetry < maxRetries {
                    try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                    delay *= 2 // Double the delay for the next retry
                }
            }
        }
        
        // If all retries fail, return a default error message
        return "Error: Could not connect to AI service after multiple attempts."
    }

    // Makes a single API request to the Gemini endpoint.
    private func makeAPIRequest(prompt: String) async throws -> String {
        guard !apiKey.isEmpty else {
            throw AIError.invalidAPIKey
        }
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "x-goog-api-key")
        
        let requestBody: [String: Any] = [
            "contents": [
                ["parts": [["text": prompt]]]
            ]
        ]
        
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw AIError.requestFailed(statusCode: statusCode)
        }
        
        // Here we need to decode the specific Gemini API response structure.
        // The actual text is nested inside a few layers.
        let decodedResponse = try JSONDecoder().decode(GeminiResponse.self, from: data)
        
        guard let content = decodedResponse.candidates.first?.content.parts.first?.text else {
            throw AIError.noContentGenerated
        }
        
        return content
    }
}

// Codable structs for decoding the Gemini API response.
struct GeminiResponse: Codable {
    let candidates: [Candidate]
}

struct Candidate: Codable {
    let content: Content
}

struct Content: Codable {
    let parts: [Part]
    let role: String
}

struct Part: Codable {
    let text: String
}
