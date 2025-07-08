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
//    dealInitialHands()
  }

  func dealInitialHands() {
    Task {
      for player in Player.allCases {
        for _ in 0..<handSize {
          try? await Task.sleep(for: .milliseconds(50))
            draw(for: player)
        }
      }
    }
  }
  
  func addCardToPlayersHand(_ card: Card) {
    hands[currentPlayer]?.append(card)
  }
  
  func drawCardForCurrentPlayer() {
    guard let currentPlayersHand = hands[currentPlayer],
      currentPlayersHand.count < handSize,
      let card = getTopCardFromDeck() else { return }
    hands[currentPlayer]?.append(card)
  }
  
  private func getTopCardFromDeck() -> Card? {
    return deck.popLast()
  }

  func draw(for player: Player, count: Int = 1) {
    guard deck.count >= count else { return }
    var hand = hands[player] ?? []
    guard hand.count < handSize else { return }
    hand.append(contentsOf: deck.prefix(count))
    deck.removeFirst(count)
    hands[player] = hand
  }
  
  func drawCardsForCurrentPlayer(amount: Int = 1) {
    draw(for: currentPlayer, count: amount)
  }
  
  func onCardSelected(_ card: Card) {
    print(card)
    hands[currentPlayer]?.removeAll(where: { $0 == card })
  }
}
