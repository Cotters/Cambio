import SwiftUI

struct CardTransform {
    let offsetX: Double
    let offsetY: Double
    let rotation: Double
}

struct DeckView: View {
    let namespace: Namespace.ID
    let deck: [Card]
    
    @State private var cardTransforms: [UUID: CardTransform] = [:]
    
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
            }
        }
        .accessibilityLabel("\(deck.count) cards left in deck")
        .onAppear {
            generateRandomTransforms()
        }
        .onChange(of: deck.count) { oldValue, newValue in
            // Only regenerate transforms if cards were added (deck was shuffled/reset)
            if newValue > oldValue {
                generateRandomTransforms()
            }
        }
    }
    
    private func generateRandomTransforms() {
        for (index, card) in deck.enumerated() {
            if cardTransforms[card.id] == nil {
                // This just adds more subtle randomness for cards deeper in the deck
                let depthFactor = max(0.1, 1.0 - Double(index) * 0.05)
                
                cardTransforms[card.id] = CardTransform(
                    offsetX: Double.random(in: -3...3) * depthFactor,
                    offsetY: Double.random(in: -3...3) * depthFactor,
                    rotation: Double.random(in: -8...8) * depthFactor
                )
            }
        }
    }
}

// Version 1
struct RealisticDeckView: View {
    let namespace: Namespace.ID
    let deck: [Card]
    
    @State private var cardTransforms: [UUID: CardTransform] = [:]
    
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
                    .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
            }
        }
        .accessibilityLabel("\(deck.count) cards left in deck")
        .onAppear {
            generateRandomTransforms()
        }
        .onChange(of: deck.count) { oldValue, newValue in
            if newValue > oldValue {
                generateRandomTransforms()
            }
        }
    }
    
    private func generateRandomTransforms() {
        for (index, card) in deck.enumerated() {
            if cardTransforms[card.id] == nil {
                let baseOffset = Double(index) * 0.5
                let randomRange = max(2.0, 6.0 - Double(index) * 0.1)
                let rotationRange = max(3.0, 12.0 - Double(index) * 0.2)
                
                cardTransforms[card.id] = CardTransform(
                    offsetX: baseOffset + Double.random(in: -randomRange...randomRange),
                    offsetY: baseOffset + Double.random(in: -randomRange...randomRange),
                    rotation: Double.random(in: -rotationRange...rotationRange)
                )
            }
        }
    }
}

// Version 2
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
