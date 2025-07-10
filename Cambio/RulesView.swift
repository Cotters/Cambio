import SwiftUI

struct RulesView: View {
  
  var body: some View {
    ScrollView {
      VStack(spacing: 16) {
        VStack(spacing: 16) {
          Text("Game Rules")
            .font(.system(size: 24, weight: .bold, design: .rounded))
            .foregroundColor(.primary)
            .padding(.top, 20)
          
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
    .scrollIndicators(.hidden) // Hides the scroll indicators
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
  RulesView()
}
