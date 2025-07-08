import Combine

final class GameEngine: ObservableObject {
  @Published private(set) var deck: [Card]
  @Published private(set) var hands: [Player: [Card]]
  @Published private(set) var currentPlayer: Player
  let cardCount: Int

  init(cardCount: Int = 4) {
    self.cardCount = cardCount
    self.deck = Card.fullDeck.shuffled()
    self.hands = [:]
    self.currentPlayer = .south
    dealInitialHands()
  }

  private func dealInitialHands() {
    for player in Player.allCases {
      guard deck.count >= cardCount else { break }
      hands[player] = Array(deck.prefix(cardCount))
      deck.removeFirst(cardCount)
    }
  }

  func draw(for player: Player, count: Int = 1) {
    guard deck.count >= count else { return }
    var hand = hands[player] ?? []
    hand.append(contentsOf: deck.prefix(count))
    deck.removeFirst(count)
    hands[player] = hand
  }
  
  func drawCardsForCurrentPlayer(amount: Int = 1) {
    guard let hand = hands[currentPlayer] else { return }
    guard deck.count >= amount, hand.count < 4 else { return }
    for _ in 0..<amount {
      hands[currentPlayer]!.append(deck.removeFirst())
    }
  }
  
  func onCardSelected(_ card: Card) {
    print(card)
    hands[currentPlayer]?.removeAll(where: { $0 == card })
    currentPlayer = (currentPlayer == .north) ? .south : .north
  }
}
