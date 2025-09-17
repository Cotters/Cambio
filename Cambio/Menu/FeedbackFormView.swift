import SwiftUI
import MessageUI

struct FeedbackFormView: View {
  
  enum FeedbackCategory: String, CaseIterable, Identifiable {
    case bug = "🐛 Bug Report"
    case suggestion = "💡 Suggestion"
    case praise = "⭐ Praise"
    case other = "📋 Other"
    
    var id: String { self.rawValue }
  }
  
  @State private var text: String = ""
  @State private var selectedCategory: FeedbackCategory = .suggestion
  @State private var email: String = ""
  @State private var isSubmitting = false
  @State private var showConfirmation = false
  @State private var characterCount: Int = 0
  @State private var showCharacterLimitWarning = false
  @FocusState private var isTextEditorFocused: Bool

  private let maxCharacterLimit = 800
  private let minCharacterLimit = 1
  
  var body: some View {
    NavigationView {
      ZStack {
        Color(.systemGroupedBackground)
          .ignoresSafeArea()
        
        ScrollView {
          VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
              Image(systemName: "bubble.left.and.bubble.right.fill")
                .font(.system(size: 50))
                .foregroundColor(.blue)
                .symbolRenderingMode(.hierarchical)
              
              Text("We'd Love Your Feedback")
                .font(.title2)
                .fontWeight(.bold)
              
              Text("Help us improve your experience")
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            .padding(.top, 20)
            
            // Form Content
            VStack(alignment: .leading, spacing: 16) {
              // Category Picker
              VStack(alignment: .leading, spacing: 8) {
                Text("Category")
                  .font(.headline)
                  .foregroundColor(.primary)
                
                Picker("Category", selection: $selectedCategory) {
                  ForEach(FeedbackCategory.allCases) { category in
                    Text(category.rawValue).tag(category)
                  }
                }
                .pickerStyle(.menu)
                .padding(8)
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(12)
              }
              
              // Email Field
              VStack(alignment: .leading, spacing: 8) {
                Text("Email (Optional)")
                  .font(.headline)
                  .foregroundColor(.primary)
                
                TextField("Email", text: $email)
                  .keyboardType(.emailAddress)
                  .textContentType(.emailAddress)
                  .autocapitalization(.none)
                  .padding()
                  .background(Color(.secondarySystemGroupedBackground))
                  .cornerRadius(12)
                  .overlay(
                    RoundedRectangle(cornerRadius: 12)
                      .stroke(email.isEmpty ? Color.clear : Color.blue.opacity(0.3), lineWidth: 1)
                  )
              }
              
              // Feedback Text Editor
              VStack(alignment: .leading, spacing: 8) {
                HStack {
                  Text("Your Feedback")
                    .font(.headline)
                    .foregroundColor(.primary)
                  
                  Spacer()
                  
                  Text("\(characterCount)/\(maxCharacterLimit)")
                    .font(.caption)
                    .foregroundColor(characterCount > maxCharacterLimit ? .red : .secondary)
                }
                
                ZStack(alignment: .topLeading) {
                  TextEditor(text: $text)
                    .focused($isTextEditorFocused)
                    .frame(minHeight: 150)
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(12)
                    .overlay(
                      RoundedRectangle(cornerRadius: 12)
                        .stroke(isTextEditorFocused ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .onChange(of: text) { oldValue, newValue in
                      characterCount = newValue.count
                      if newValue.count > maxCharacterLimit {
                        showCharacterLimitWarning = true
                      } else {
                        showCharacterLimitWarning = false
                      }
                    }
                  
                  if text.isEmpty {
                    Text("Share your thoughts, ideas, or issues...")
                      .foregroundColor(.gray)
                      .padding(.horizontal, 20)
                      .padding(.vertical, 15)
                      .offset(y: 10)
                      .allowsHitTesting(false)
                  }
                }
                
                if showCharacterLimitWarning {
                  Text("Character limit exceeded (\(maxCharacterLimit) max)")
                    .font(.caption)
                    .foregroundColor(.red)
                    .transition(.opacity)
                }
              }
            }
            .padding(.horizontal)
            
            // Submit Button
            Button(action: submitFeedback) {
              HStack {
                if isSubmitting {
                  ProgressView()
                    .tint(.white)
                }
                Text(isSubmitting ? "Submitting..." : "Submit Feedback")
                  .fontWeight(.semibold)
              }
              .frame(maxWidth: .infinity)
              .padding()
              .background(canSubmit ? Color.blue : Color.gray)
              .foregroundColor(.white)
              .cornerRadius(12)
              .disabled(!canSubmit || isSubmitting)
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            // Footer Note
            Text("Your feedback helps us create a better experience for everyone. Thank you! 💙")
              .font(.caption)
              .foregroundColor(.secondary)
              .multilineTextAlignment(.center)
              .padding(.horizontal, 40)
              .padding(.top, 8)
          }
          .padding(.bottom, 20)
        }
        .scrollDismissesKeyboard(.interactively)
      }
      .navigationTitle("Feedback")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .keyboard) {
          HStack {
            Spacer()
            Button("Done") {
              isTextEditorFocused = false
            }
          }
        }
      }
      .alert("Feedback Submitted!", isPresented: $showConfirmation) {
        Button("OK", role: .cancel) {
          resetForm()
        }
      } message: {
        Text("Thank you for your valuable feedback. We'll review it soon!")
      }
    }
  }
  
  private var canSubmit: Bool {
    !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
    text.count >= minCharacterLimit &&
    text.count <= maxCharacterLimit
  }
  
  private func submitFeedback() {
    isSubmitting = true
    
    // Simulate network request
    Task {
      try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
      
      await MainActor.run {
        isSubmitting = false
        showConfirmation = true
        
        // Here you would normally send the data to your backend:
        let feedbackData: [String: Any] = [
          "category": selectedCategory.rawValue,
          "email": email,
          "message": text,
          "timestamp": Date().ISO8601Format()
        ]
        
        print("Feedback submitted: \(feedbackData)")
      }
    }
  }
  
  private func resetForm() {
    text = ""
    email = ""
    characterCount = 0
    selectedCategory = .suggestion
    showCharacterLimitWarning = false
  }
}

#Preview {
  FeedbackFormView()
}
