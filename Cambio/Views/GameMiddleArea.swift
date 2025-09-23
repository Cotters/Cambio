import SwiftUI

struct GameCenterArea: View {
  let namespace: Namespace.ID
  let gameEngine: BaseGameEngine
  let onDeckTapped: () -> Void
  let onPileTapped: () -> Void

  var body: some View {
    VStack(spacing: 24) {
      // Deck and Pile
      HStack(spacing: 40) {
        // Draw Deck
        VStack(spacing: 12) {
          AnimatedRealisticDeckView(
            namespace: namespace,
            deck: gameEngine.deck.reversed(),
          )
          .frame(height: HAND_CARD_HEIGHT)
          .onTapGesture(perform: onDeckTapped)
          
          Text("Draw")
            .font(.system(size: 14, weight: .semibold, design: .rounded))
            .foregroundColor(.blue)
        }

        // Discard Pile
        VStack(spacing: 12) {
          AnimatedRealisticDeckView(
            namespace: namespace,
            deck: gameEngine.pile,
          )
          .frame(height: HAND_CARD_HEIGHT)
          .animation(.easeInOut(duration: 0.4), value: gameEngine.pile)
          .onTapGesture(perform: onPileTapped)
          
          Text("Discard")
            .font(.system(size: 14, weight: .semibold, design: .rounded))
            .foregroundColor(.orange)
        }
      }
//      .zIndex(1)

      // Game Info
      VStack(spacing: 16) {
        HStack(spacing: 20) {
          // Cards remaining
          HStack(spacing: 8) {
            Image(systemName: "rectangle.stack.fill")
              .font(.system(size: 16, weight: .medium))
              .foregroundColor(.blue)
            Text("\(gameEngine.deck.count) cards")
              .font(.system(size: 16, weight: .medium, design: .rounded))
              .foregroundColor(.primary)
          }
          .padding(.horizontal, 16)
          .padding(.vertical, 8)
          .background(
            Capsule()
              .fill(Color(.tertiarySystemBackground))
          )

          // Current turn indicator
          HStack(spacing: 8) {
            Image(systemName: "person.fill")
              .font(.system(size: 16, weight: .medium))
              .foregroundColor(.green)
            Text("\(gameEngine.currentPlayer == .north ? "North's" : "South's") Turn")
              .font(.system(size: 16, weight: .medium, design: .rounded))
              .foregroundColor(.primary)
          }
          .padding(.horizontal, 16)
          .padding(.vertical, 8)
          .background(
            Capsule()
              .fill(Color.green.opacity(0.1))
              .overlay(
                Capsule()
                  .stroke(Color.green.opacity(0.3), lineWidth: 1)
              )
          )
        }

        // Cambio Button
        if gameEngine.gameState != .cambioCalled {
          CambioButton(action: gameEngine.onCambioTapped)
        }
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 20)
      .background(
        RoundedRectangle(cornerRadius: 16)
          .fill(Color(.secondarySystemBackground).opacity(0.8))
          .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
      )
    }
    .rotationEffect(.degrees(gameEngine.currentPlayer == .north ? 180 : 0))
    .animation(.easeInOut(duration: 0.5), value: gameEngine.currentPlayer)
  }
}

#Preview {
  @Previewable @Namespace var previewNamepsace
  ZStack {
    GameBackground()
    GameCenterArea(
      namespace: previewNamepsace,
      gameEngine: BaseGameEngine(),
      onDeckTapped: {},
      onPileTapped: {},
    )
  }
}
