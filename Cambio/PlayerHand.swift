import SwiftUI

struct PlayerHand: View {
  let namespace: Namespace.ID

  let cards: [Card]
  let onCardSelected: (Card) -> Void
  private let backgroundColor: Color = .green

  var body: some View {
    HStack {
      ForEach(cards.prefix(cards.count), id: \.id) { card in
        FlippableCard(card: card)
          .matchedGeometryEffect(id: card.id, in: namespace)
          .onTapGesture { onCardSelected(card) }
          .frame(height: HAND_CARD_HEIGHT)
      }
    }
    .frame(height: HAND_CARD_HEIGHT)
    .padding()
    .frame(maxWidth: .infinity)
    .background(backgroundColor.opacity(0.3))
    .cornerRadius(20)
  }
}
