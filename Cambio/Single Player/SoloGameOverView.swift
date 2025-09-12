import SwiftUI

struct SoloGameOverView: View {
  let playerScore: Int
  let penaltyPoints: Int
  let onRestartTapped: () -> Void
  let onMenuTapped: () -> Void

  private var scoreMessage: String {
    if playerScore <= 0 {
      return "Amazing Game!"
    } else if playerScore < 10 {
      return "Good Game!"
    } else if playerScore < 20 {
      return "Room for Improvement!"
    } else {
      return "Better Luck Next Time!"
    }
  }

  private var scoreColor: Color {
    if playerScore <= 0 {
      return .green
    } else if playerScore < 10 {
      return .blue
    } else if playerScore < 20 {
      return .orange
    } else {
      return .red
    }
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
        // Player Score
        VStack(spacing: 4) {
          Text("YOUR SCORE")
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.secondary)
          Text("\(playerScore)")
            .font(.system(size: 48, weight: .bold, design: .rounded))
            .foregroundColor(scoreColor)
          if (penaltyPoints > 0) {
            Text("(Penalty of +\(penaltyPoints))")
              .font(.system(size: 16, weight: .bold, design: .rounded))
              .foregroundColor(.red)
          }
        }

        // Score message
        Text(scoreMessage)
          .font(.system(size: 18, weight: .semibold, design: .rounded))
          .foregroundColor(scoreColor)
          .padding(.horizontal, 20)
          .padding(.vertical, 8)
          .background(
            Capsule()
              .fill(scoreColor.opacity(0.1))
              .overlay(
                Capsule()
                  .stroke(scoreColor.opacity(0.3), lineWidth: 1)
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
  SoloGameOverView(
    playerScore: 10,
    penaltyPoints: 3,
    onRestartTapped: {},
    onMenuTapped: {}
  )
}
