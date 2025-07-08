import SwiftUI

struct PlayerHand: View {
  let namespace: Namespace.ID

  let cards: [Card]
  let onCardSelected: (Card) -> Void
  private let backgroundColor: Color = .green

  var body: some View {
    HStack {
      ForEach(cards.prefix(cards.count), id: \.id) { card in
        FlippableCard(card: card, beginsFaceUp: card.isFaceUp, onTap: { onCardSelected(card) } )
          .matchedGeometryEffect(id: card.id, in: namespace)
//          .onTapGesture { onCardSelected(card) }
          .frame(height: HAND_CARD_HEIGHT)
//        CardView(card: card)
//          .zIndex(Double(deck.count))
//          .matchedGeometryEffect(id: card.id, in: namespace)
//          .zIndex(Double(cards.count)) // Do we need?
//          .onTapGesture { onCardSelected(card) }
//          .frame(height: HAND_CARD_HEIGHT)
      }
    }
    .frame(height: HAND_CARD_HEIGHT)
    .padding()
    .frame(maxWidth: .infinity)
    .background(backgroundColor.opacity(0.3))
    .cornerRadius(20)
  }
}
