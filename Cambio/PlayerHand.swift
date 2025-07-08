import SwiftUI

struct PlayerHand: View {
  let cards: [Card]
  let onCardSelected: (Card) -> Void
  private let backgroundColor: Color = .green

  var body: some View {
    HStack {
      ForEach(cards.prefix(cards.count), id: \.self) { card in
        CardView(card: card)
          .onTapGesture {
            onCardSelected(card)
          }
          .frame(height: HAND_CARD_HEIGHT)
      }
    }
    .frame(height: HAND_CARD_HEIGHT)
    .padding()
//    .padding()
    .frame(maxWidth: .infinity)
//    .frame(height: HAND_CARD_HEIGHT)
    .background(backgroundColor.opacity(0.3))
    .cornerRadius(20)
  }
}
