import SwiftUI

struct DeckView: View {
  let namespace: Namespace.ID
  let deck: [Card]
  let onTap: () -> Void

  var body: some View {
    ZStack {
      ForEach(deck, id: \.id) { card in
        FlippableCard(card: card, canFlip: false, beginsFaceUp: card.isFaceUp)
//          .matchedGeometryEffect(id: card.id, in: namespace)
//          .zIndex(Double(deck.count))
          .onTapGesture(perform: onTap)
      }
    }
//    .zIndex(100)
    .accessibilityLabel("\(deck.count) cards left in deck")
  }
}
