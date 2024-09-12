import Foundation
import OpenAI

struct ChatMessage: Identifiable {
    var id = UUID()
    var message: String
    var isUser: Bool
}

final class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = [] // Published property for chat messages

    private var openAI: OpenAI?
    
    init() {}
    
    func setupOpenAI() {
        openAI = OpenAI(apiToken: "sk-eq-iBvWcvEgOjqgSGts-yWzLf7f2CFp7UevW9jXL4WT3BlbkFJx092lztwo5wRoWwcCzAKmhnhaYtvSi-I4EWEEzxCgA") // Initialize OpenAI
    }
    
    func sendUserMessage(_ message: String) async {
        let query = CompletionsQuery(model: .gpt4_o_mini, prompt: "What is 42?", temperature: 1, maxTokens: 100, topP: 1, frequencyPenalty: 0, presencePenalty: 0, stop: ["\\n"])
        //or
        do {
            let result = try await openAI!.completions(query: query)
            print(result)
        } catch {
            print("Error: \(error)")
        }
        
        
        
    }

    private func receiveBotMessage(_ message: String) {
        let botMessage = ChatMessage(message: message, isUser: false)
        messages.append(botMessage)
        print("Messedage: \(message)")// Append bot message to chat history
    }
}
