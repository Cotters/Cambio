import SwiftUI

struct WelcomeView: View {
  let onStartTapped: () -> Void
  
  var body: some View {
    ScrollView {
      VStack(spacing: 16) {
        // Header Section
        VStack(spacing: 8) {
          Text("♠️ CAMBIO ♣️")
            .font(.system(size: 36, weight: .black, design: .rounded))
            .foregroundStyle(
              LinearGradient(
                gradient: Gradient(colors: [.blue, .purple]),
                startPoint: .leading,
                endPoint: .trailing
              )
            )
          
          Text("Card Game")
            .font(.system(size: 20, weight: .medium, design: .rounded))
            .foregroundColor(.secondary)
            .tracking(2)
        }
        .padding(.top, 20)
        
        // Quick Start Button
        Button(action: onStartTapped) {
          HStack(spacing: 12) {
            Image(systemName: "play.fill")
              .font(.system(size: 18, weight: .bold))
            Text("Quick Start")
              .font(.system(size: 18, weight: .bold, design: .rounded))
          }
          .foregroundColor(.white)
          .padding(.horizontal, 32)
          .padding(.vertical, 16)
          .background(
            LinearGradient(
              gradient: Gradient(colors: [.green, .mint]),
              startPoint: .leading,
              endPoint: .trailing
            )
          )
          .clipShape(Capsule())
          .shadow(color: .green.opacity(0.3), radius: 6, x: 0, y: 3)
        }
        
        // Rules Section
        VStack(spacing: 16) {
          // Section Header
          HStack {
            Image(systemName: "book.fill")
              .font(.title2)
              .foregroundColor(.blue)
            Text("Game Rules")
              .font(.system(size: 24, weight: .bold, design: .rounded))
              .foregroundColor(.primary)
            Spacer()
          }
          
          // Objective Card
          RuleCard(
            title: "🎯 Objective",
            content: "Have the least points possible by removing cards or keeping low-scoring cards.",
            color: .orange
          )
          
          // Setup Card
          RuleCard(
            title: "⚙️ Setup",
            content: """
                        • Each player gets \(HAND_SIZE) cards
                        • Draw pile and discard pile in the middle
                        """,
            color: .blue
          )
          
          // Gameplay Card
          RuleCard(
            title: "🎮 Gameplay",
            content: """
                        1. Draw from draw pile or discard pile
                        2. Keep or discard the drawn card
                        3. Tap your cards to match with discard pile
                        4. Correct match = discard card
                        5. Wrong match = gain extra card (max \(HAND_SIZE))
                        6. Call "Cambio" when you have least points
                        """,
            color: .purple
          )
          
          // Scoring Card
          VStack(alignment: .leading, spacing: 16) {
            HStack {
              Text("📊")
                .font(.title2)
              Text("Scoring")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
              Spacer()
            }
            
            VStack(spacing: 12) {
              ScoreRow(
                icon: "👑",
                text: "Red Kings",
                points: "\(RED_KING_SCORE)",
                color: .green
              )
              
              ScoreRow(
                icon: "🃏",
                text: "Aces",
                points: "\(ACE_SCORE)",
                color: .blue
              )
              
              ScoreRow(
                icon: "🎭",
                text: "Face Cards",
                points: "+\(FACE_CARD_SCORE)",
                color: .red
              )
              
              ScoreRow(
                icon: "🔢",
                text: "Number Cards (2-10)",
                points: "Face Value",
                color: .orange,
                subtitle: "Example: 4 of Spades = -4 points"
              )
            }
          }
          .padding(20)
          .background(
            RoundedRectangle(cornerRadius: 16)
              .fill(Color(.systemBackground))
              .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
          )
        }
        .padding(.horizontal, 0)
        
        // Main Play Button
        Button(action: onStartTapped) {
          HStack(spacing: 12) {
            Image(systemName: "gamecontroller.fill")
              .font(.system(size: 20, weight: .bold))
            Text("Start Playing Cambio")
              .font(.system(size: 20, weight: .bold, design: .rounded))
          }
          .foregroundColor(.white)
          .padding(.horizontal, 40)
          .padding(.vertical, 18)
          .background(
            LinearGradient(
              gradient: Gradient(colors: [.blue, .purple]),
              startPoint: .leading,
              endPoint: .trailing
            )
          )
          .clipShape(Capsule())
          .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .padding(.bottom, 0)
      }
      .padding(.horizontal, 20)
    }
    .background(
      LinearGradient(
        gradient: Gradient(colors: [
          Color(.systemBackground),
          Color(.secondarySystemBackground)
        ]),
        startPoint: .top,
        endPoint: .bottom
      )
    )
  }
}

struct RuleCard: View {
  let title: String
  let content: String
  let color: Color
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text(title)
        .font(.system(size: 18, weight: .bold, design: .rounded))
        .foregroundColor(color)
      
      Text(content)
        .font(.system(size: 15, weight: .medium, design: .default))
        .foregroundColor(.primary)
        .fixedSize(horizontal: false, vertical: true)
    }
    .padding(20)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(
      RoundedRectangle(cornerRadius: 16)
        .fill(Color(.systemBackground))
        .overlay(
          RoundedRectangle(cornerRadius: 16)
            .stroke(color.opacity(0.3), lineWidth: 2)
        )
        .shadow(color: color.opacity(0.1), radius: 6, x: 0, y: 3)
    )
  }
}

struct ScoreRow: View {
  let icon: String
  let text: String
  let points: String
  let color: Color
  let subtitle: String?
  
  init(icon: String, text: String, points: String, color: Color, subtitle: String? = nil) {
    self.icon = icon
    self.text = text
    self.points = points
    self.color = color
    self.subtitle = subtitle
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      HStack {
        Text(icon)
          .font(.title3)
        
        Text(text)
          .font(.system(size: 16, weight: .medium, design: .rounded))
          .foregroundColor(.primary)
        
        Spacer()
        
        Text(points)
          .font(.system(size: 16, weight: .bold, design: .rounded))
          .foregroundColor(color)
          .padding(.horizontal, 12)
          .padding(.vertical, 4)
          .background(
            Capsule()
              .fill(color.opacity(0.1))
          )
      }
      
      if let subtitle = subtitle {
        Text(subtitle)
          .font(.system(size: 13, weight: .medium, design: .rounded))
          .foregroundColor(.secondary)
          .padding(.leading, 32)
      }
    }
  }
}

#Preview {
  WelcomeView(onStartTapped: {})
}
