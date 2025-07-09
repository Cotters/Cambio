import SwiftUI

final class GameEngine: ObservableObject {
  @Published private(set) var deck: [Card] = Card.fullDeck.shuffled()
  @Published private(set) var pile: [Card] = []
  @Published private(set) var hands: [Player: [Card]] = [:]
  @Published private(set) var currentPlayer: Player = .south
  let handSize: Int

  init(handSize: Int = HAND_SIZE) {
    self.handSize = handSize
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
  
  func flipAllCards(for player: Player) {
    guard let hand = hands[player] else { return }
    for card in hand { card.flip() }
  }
  
  func flipCardOntoPile() {
    guard let topCard = deck.popLast() else { return }
    pile.append(topCard)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      topCard.flip()
    }
    print(pile.suffix(3))
  }
  
  func onCardSelected(_ card: Card) {
    guard let currentPlayersHand = hands[currentPlayer] else { return }
    if (currentPlayersHand.contains(card)) {
      guard let pileCard = pile.last else { return }
      card.flip()
      checkMove(card, against: pileCard)
    } else {
      print("Not your go!!")
    }
  }
  
  private func checkMove(_ card: Card, against pileCard: Card) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
      if card.rank == pileCard.rank {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: { [weak self] in
          self?.handleMatch(card)
        })
      } else {
        card.flip()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
          self?.handleIncorrectMatch(card)
        })
      }
    })
  }
  
  private func handleMatch(_ card: Card) {
    removeCardFromCurrentPlayer(card)
    switchPlayer()
    flipCardOntoPile()
  }
  
  private func handleIncorrectMatch(_ card: Card) {
    drawCardForCurrentPlayer()
    switchPlayer()
    flipCardOntoPile()
  }
  
  private func removeCard(_ card: Card, from player: Player) {
    hands[player]?.removeAll(where: { $0 == card })
  }
  
  private func removeCardFromCurrentPlayer(_ card: Card) {
    hands[currentPlayer]?.removeAll(where: { $0 == card })
  }
  
  private func switchPlayer() {
    self.currentPlayer = (currentPlayer == .north) ? .south : .north
  }
}
