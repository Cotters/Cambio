import SwiftUI

struct SoloGameCenterArea: View {
  let namespace: Namespace.ID
  let gameEngine: SoloGameEngine
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
            deck: gameEngine.deck,
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
      .zIndex(200)

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
    }
  }
}

#Preview {
  @Previewable @Namespace var namespace
  let gameEngine = SoloGameEngine()
  SoloGameCenterArea(
    namespace: namespace,
    gameEngine: gameEngine,
    onDeckTapped: {},
    onPileTapped: {},
  )
}
