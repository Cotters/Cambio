import SwiftUI

struct DeckView: View {
  let namespace: Namespace.ID
  let deck: [Card]
  let onTap: () -> Void
  
  @State private var scale: CGFloat = 1.0

  var body: some View {
    ZStack {
      ForEach(deck, id: \.id) { card in
        CardView(card: card)
//          .frame(height: HAND_CARD_HEIGHT)
//          .scaledToFit()
//          .cornerRadius(12, antialiased: true)
//          .shadow(color: .green.opacity(0.5), radius: 0.45)
          .matchedGeometryEffect(id: card.id, in: namespace)
          .zIndex(Double(deck.count))
          .onTapGesture(perform: onTap)
      }
    }
//    .zIndex(100)
    .accessibilityLabel("\(deck.count) cards left in deck")
  }
}
