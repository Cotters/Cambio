import SwiftUI
import MessageUI

struct MainMenu : View {
  @State private var isPresentingRules = false
  @State private var isPresentingLeaderboard = false
  @State private var isPresentingFeedbackForm = false
  @State private var emailResult: Result<MFMailComposeResult, Error>? = nil
  
  let onSoloTapped: () -> Void
  let onTwoPlayerTapped: () -> Void
    
  var body: some View {
    ZStack {
      GameBackground()
      VStack(spacing: 36) {
        VStack(spacing: 0) {
          Text("♠ CAMBIO ♣")
            .font(.system(size: 36, weight: .black, design: .rounded))
            .foregroundStyle(
              LinearGradient(
                gradient: Gradient(colors: [.blue, .purple]),
                startPoint: .leading,
                endPoint: .trailing
              )
            )
          
          Text("The Card Game")
            .font(.system(size: 20, weight: .medium, design: .rounded))
            .foregroundColor(.secondary)
            .tracking(2)
        }
        .padding(.top, 20)
        
        VStack(spacing: 16) {
          MainMenuButton(
            icon: "person.fill",
            text: "Solo",
            gradientColors: [.green, .mint],
            action: onSoloTapped,
          )
          
          MainMenuButton(
            icon: "person.2.fill",
            text: "Two Player",
            gradientColors: [.blue, .red],
            action: onTwoPlayerTapped,
          )
          
          MainMenuButton(
            icon: "list.number",
            text: "Leaderboard",
            gradientColors: [.red, .orange],
            action: { isPresentingLeaderboard.toggle() },
          )
          
          MainMenuButton(
            icon: "book.fill",
            text: "The Rules",
            gradientColors: [.blue, .teal],
            action: { isPresentingRules.toggle() },
          )
          
          MainMenuButton(
            icon: "square.and.pencil",
            text: "Feedback",
            gradientColors: [.indigo, .purple],
            action: { isPresentingFeedbackForm.toggle() },
          )
          
          
        }
      }
      .sheet(isPresented: $isPresentingRules) {
        RulesView()
      }
      .sheet(isPresented: $isPresentingLeaderboard) {
        LeaderboardView()
      }
      .sheet(isPresented: $isPresentingFeedbackForm) {
        MailView(
          mailData: MailData(
            receipientEmail: SUPPORT_EMAIL,
            subject: "Feature or Bug Fix Request"
          ),
          result: $emailResult
        )
      }
    }
  }
}

#Preview {
  MainMenu(
    onSoloTapped: {},
    onTwoPlayerTapped: {},
  )
}
