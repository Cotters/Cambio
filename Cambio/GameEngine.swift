import SwiftUI

final class GameEngine: ObservableObject {
  @Published private(set) var deck: [Card] = Card.fullDeck.shuffled()
  @Published private(set) var pile: [Card] = []
  @Published private(set) var hands: [Player: [Card]] = [:]
  @Published private(set) var currentPlayer: Player = .south
  
  @Published private(set) var viewingCard: Card? = nil
  
  private var currentPlayersHand: [Card]? {
    return hands[currentPlayer]
  }
  
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
    guard viewingCard == nil else { return }
    let topCard = getTopCardFromDeck()
    topCard?.flip()
    viewingCard = topCard
  }
  
  private func getTopCardFromDeck() -> Card? {
    return deck.popLast()
  }
  
  func draw(_ count: Int = 1, for player: Player) {
    guard deck.count >= count else { return }
    var hand = hands[player] ?? []
    guard hand.count < handSize else { return }
    hand.append(contentsOf: deck.prefix(count))
    deck.removeFirst(count)
    hands[player] = hand
  }
  
  func onDeckTapped() {
    drawCardForCurrentPlayer()
  }
  
  func onPileTapped() {
    if let card = viewingCard {
      pile.append(card)
      viewingCard = nil
      switchPlayer()
    } else if (pile.count > 0) {
      viewingCard = pile.popLast()
    }
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
    if (pile.count > 1) { return }
    print("North hand: \(hands[.north] ?? [])\nSouth hand: \(hands[.south] ?? [])\n")
  }
  
  func onCardSelected(_ selectedCard: Card) {
    guard let currentPlayersHand = hands[currentPlayer] else { return }
    if let viewingCard = self.viewingCard, let indexOfSelectedCard = currentPlayersHand.firstIndex(of: selectedCard) {
      selectedCard.flip()
      pile.append(selectedCard)
      hands[currentPlayer]?.remove(at: indexOfSelectedCard)
      viewingCard.flip()
      hands[currentPlayer]?.insert(viewingCard, at: indexOfSelectedCard)
      self.viewingCard = nil
      switchPlayer()
    } else if (hands[.north]?.contains(selectedCard) == true) { // TODO: Refactoring
      guard let pileCard = pile.last else { return }
      selectedCard.flip()
      // Check the move after a delay to allow flip animation
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
        self?.checkMove(selectedCard, against: pileCard, for: .north)
      }
    } else if (hands[.south]?.contains(selectedCard) == true) {
      guard let pileCard = pile.last else { return }
      selectedCard.flip()
      // Check the move after a delay to allow flip animation
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
        self?.checkMove(selectedCard, against: pileCard, for: .south)
      }
    }
  }
  
  func skipTurn() {
    switchPlayer()
  }
  
  private func checkMove(_ card: Card, against pileCard: Card, for player: Player) {
    if card.rank == pileCard.rank {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
        self?.handleMatch(card, for: player)
      }
    } else {
      card.flip()
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
        self?.handleIncorrectMatch(card, for: player)
      }
    }
  }
  
  private func handleMatch(_ card: Card, for player: Player) {
    pile.append(card)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in // Waiting for animation to finish
      self?.remove(card, from: player)
    }
  }
  
  private func handleIncorrectMatch(_ card: Card, for player: Player) {
    draw(1, for: player)
  }
  
  private func removeCard(_ card: Card, from player: Player) {
    hands[player]?.removeAll(where: { $0 == card })
  }
  
  private func removeCardFromCurrentPlayer(_ card: Card) {
    hands[currentPlayer]?.removeAll(where: { $0 == card })
  }
  
  private func remove(_ card: Card, from player: Player) {
    hands[player]?.removeAll(where: { $0 == card })
  }
  
  private func switchPlayer() {
    self.currentPlayer = (currentPlayer == .north) ? .south : .north
  }
}
