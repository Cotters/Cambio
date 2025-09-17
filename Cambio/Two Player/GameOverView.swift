import SwiftUI

struct GameOverView: View {
  let northScore: Int
  let northPenalty: Int
  let southScore: Int
  let southPenalty: Int
  let onRestartTapped: () -> Void
  let onMenuTapped: () -> Void
  
  private var winner: String {
    northScore == southScore ?
    "It's a Tie!" : (northScore < southScore ? "North Wins!" : "South Wins!")
  }
  
  private var winnerColor: Color {
    northScore == southScore ? .orange : (northScore > southScore ? .blue : .red)
  }
  
  var body: some View {
    VStack(spacing: 20) {
      // Game Over Title with subtle animation
      Text("GAME OVER")
        .font(.system(size: 28, weight: .bold, design: .rounded))
        .foregroundColor(.primary)
        .opacity(0.9)
      
      // Score Display Card
      VStack(spacing: 12) {
        HStack(spacing: 30) {
          // North Score
          VStack(spacing: 4) {
            Text("NORTH")
              .font(.caption)
              .fontWeight(.semibold)
              .foregroundColor(.secondary)
            Text("\(northScore)")
              .font(.system(size: 36, weight: .bold, design: .rounded))
              .foregroundColor(northScore < southScore ? .blue : .primary)
          }
          
          // VS Separator
          Text("VS")
            .font(.caption)
            .fontWeight(.bold)
            .foregroundColor(.secondary)
            .opacity(0.6)
          
          // South Score
          VStack(spacing: 4) {
            Text("SOUTH")
              .font(.caption)
              .fontWeight(.semibold)
              .foregroundColor(.secondary)
            Text("\(southScore)")
              .font(.system(size: 36, weight: .bold, design: .rounded))
              .foregroundColor(southScore < northScore ? .blue : .primary)
          }
        }
        
        // Winner announcement
        Text(winner)
          .font(.system(size: 18, weight: .semibold, design: .rounded))
          .foregroundColor(winnerColor)
          .padding(.horizontal, 20)
          .padding(.vertical, 8)
          .background(
            Capsule()
              .fill(winnerColor.opacity(0.1))
              .overlay(
                Capsule()
                  .stroke(winnerColor.opacity(0.3), lineWidth: 1)
              )
          )
      }
      .padding(.horizontal, 24)
      .padding(.vertical, 20)
      .background(
        RoundedRectangle(cornerRadius: 16)
          .fill(Color(.systemBackground))
          .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
      )
      
      // Buttons
      VStack(spacing: 12) {
        RestartButton(action: onRestartTapped)
        MenuButton(action: onMenuTapped)
      }
    }
    .padding(.horizontal, 32)
    .padding(.vertical, 24)
    .frame(maxWidth: 350)
    .background(
      RoundedRectangle(cornerRadius: 24)
        .fill(Color(.secondarySystemBackground))
        .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 6)
    )
  }
}

#Preview {
  GameOverView(
    northScore: 10,
    northPenalty: 0,
    southScore: 0,
    southPenalty: 10,
    onRestartTapped: {},
    onMenuTapped: {}
  )
}
