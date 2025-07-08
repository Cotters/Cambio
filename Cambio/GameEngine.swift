import SwiftUI

final class GameEngine: ObservableObject {
  @Published private(set) var deck: [Card]
  @Published private(set) var pile: [Card] = []
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
  
  func flipAllCards(for player: Player) {
    guard let hand = hands[player] else { return }
    hand.forEach { $0.flip() }
  }
  
  func flipCardOntoPile() {
    guard let topCard = deck.popLast() else { return }
    let newCard = Card(rank: topCard.rank, suit: topCard.suit, isFaceUp: true)
    pile.append(newCard)
    print(pile.suffix(3))
  }
  
  func onCardSelected(_ card: Card) {
    guard let currentPlayersHand = hands[currentPlayer] else { return }
    if (currentPlayersHand.contains(where: { $0.id == card.id })) {
      guard let pileCard = pile.last else { return }
      if card.rank == pileCard.rank {
        print("Match!")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
          print("Removing card...")
          guard let currentPlayer = self?.currentPlayer else { return }
          self?.hands[currentPlayer]?.removeAll(where: { $0 == card })
          self?.currentPlayer = (currentPlayer == .north) ? .south : .north
          self?.flipCardOntoPile()
        })
      } else {
        print("No match!")
        self.currentPlayer = (currentPlayer == .north) ? .south : .north
        self.flipCardOntoPile()
      }
    } else {
      print("Not your go!!")
    }
  }
}
