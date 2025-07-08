import Combine

final class GameEngine: ObservableObject {
  @Published private(set) var deck: [Card]
  @Published private(set) var hands: [Player: [Card]]
  @Published private(set) var currentPlayer: Player
  let handSize: Int

  init(handSize: Int = 4) {
    self.handSize = handSize
    self.deck = Card.fullDeck.shuffled()
    self.hands = [:]
    self.currentPlayer = .south
    dealInitialHands()
  }

  private func dealInitialHands() {
    for player in Player.allCases {
      draw(for: player, count: handSize)
    }
  }

  private func draw(for player: Player, count: Int = 1) {
    guard deck.count >= count else { return }
    var hand = hands[player] ?? []
    hand.append(contentsOf: deck.prefix(count))
    deck.removeFirst(count)
    hands[player] = hand
  }
  
  func drawCardsForCurrentPlayer(amount: Int = 1) {
    guard hands[currentPlayer]!.count < handSize else { return }
    draw(for: currentPlayer, count: amount)
  }
  
  func onCardSelected(_ card: Card) {
    print(card)
    hands[currentPlayer]?.removeAll(where: { $0 == card })
    currentPlayer = (currentPlayer == .north) ? .south : .north
  }
}
