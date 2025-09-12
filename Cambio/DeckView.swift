import SwiftUI

struct CardTransform {
  let offsetX: Double
  let offsetY: Double
  let rotation: Double
}

struct AnimatedRealisticDeckView: View {
  let namespace: Namespace.ID
  let deck: [Card]
  
  @State private var cardTransforms: [UUID: CardTransform] = [:]
  @State private var previousDeckCount: Int = 0
  
  var body: some View {
    ZStack {
      ForEach(Array(deck.enumerated()), id: \.element.id) { index, card in
        FlippableCard(card: card, canFlip: false)
          .matchedGeometryEffect(id: card.id, in: namespace)
          .frame(height: HAND_CARD_HEIGHT)
          .offset(x: cardTransforms[card.id]?.offsetX ?? 0,
                  y: cardTransforms[card.id]?.offsetY ?? 0)
          .rotationEffect(.degrees(cardTransforms[card.id]?.rotation ?? 0))
          .zIndex(Double(index))
          .shadow(color: .black.opacity(0.15), radius: 2, x: 1, y: 1)
      }
    }
    .accessibilityLabel("\(deck.count) cards left in deck")
    .onAppear {
      previousDeckCount = deck.count
      generateRandomTransforms()
    }
    .onChange(of: deck.count) { oldValue, newValue in
      if newValue > oldValue {
        generateRandomTransforms()
      } else if newValue < oldValue {
        adjustRemainingCards()
      }
      previousDeckCount = newValue
    }
  }
  
  private func generateRandomTransforms() {
    for (index, card) in deck.enumerated() {
      if cardTransforms[card.id] == nil {
        let depthFactor = max(0.2, 1.0 - Double(index) * 0.03)
        
        cardTransforms[card.id] = CardTransform(
          offsetX: Double.random(in: -4...4) * depthFactor,
          offsetY: Double.random(in: -4...4) * depthFactor,
          rotation: Double.random(in: -10...10) * depthFactor
        )
      }
    }
  }
  
  private func adjustRemainingCards() {
    for card in deck.prefix(3) {
      if var transform = cardTransforms[card.id] {
        let adjustment = 0.3
        transform = CardTransform(
          offsetX: transform.offsetX + Double.random(in: -adjustment...adjustment),
          offsetY: transform.offsetY + Double.random(in: -adjustment...adjustment),
          rotation: transform.rotation + Double.random(in: -2...2)
        )
        cardTransforms[card.id] = transform
      }
    }
  }
}
