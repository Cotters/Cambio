import SwiftUI

struct SoloPlayerHand: View {
  let namespace: Namespace.ID
  let cards: [Card]
  let onCardSelected: (Card) -> Void
  
  var body: some View {
    VStack(spacing: 8) {
      // First row (cards 0-3)
      HStack(spacing: 8) {
        ForEach(Array(cards.prefix(4).enumerated()), id: \.element.id) { _, card in
          FlippableCard(card: card)
            .matchedGeometryEffect(id: card.id, in: namespace)
            .onTapGesture {
              let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
              impactFeedback.impactOccurred()
              onCardSelected(card)
            }
            .frame(height: HAND_CARD_HEIGHT)
            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
      }
      
      // Second row (cards 4-7)
      HStack(spacing: 8) {
        ForEach(Array(cards.dropFirst(4).prefix(4).enumerated()), id: \.element.id) { _, card in
          FlippableCard(card: card)
            .matchedGeometryEffect(id: card.id, in: namespace)
            .onTapGesture {
              let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
              impactFeedback.impactOccurred()
              onCardSelected(card)
            }
            .frame(height: HAND_CARD_HEIGHT)
            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
      }
    }
    .frame(
      width: .infinity,
      height: (HAND_CARD_HEIGHT * max(1, CGFloat(cards.count) / 4)) + 8,
    )
    .frame(maxWidth: 500)
    .padding(.horizontal, 16)
    .padding(.vertical, 12)
    .background(
      RoundedRectangle(cornerRadius: 16)
        .fill(Color.blue.opacity(0.1))
        .overlay(
          RoundedRectangle(cornerRadius: 16)
            .stroke(Color.blue.opacity(0.2), lineWidth: 1)
        )
    )
  }
}


#Preview {
  @Previewable @Namespace var namespace
  let deck = Deck.standardWithJokers
  var faceUpDeck: [Card] {
    deck.forEach { $0.flip() }
    return deck
  }
  VStack {
    SoloPlayerHand(
      namespace: namespace,
      cards: Array(faceUpDeck.shuffled().prefix(4)),
      onCardSelected: { $0.flip() }
    )
  }
  .padding()
  .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
  .background(Color.blue.opacity(0.3))
}
