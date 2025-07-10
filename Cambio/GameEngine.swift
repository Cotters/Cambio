import SwiftUI

final class GameEngine: ObservableObject {
  @Published private(set) var deck: [Card] = Card.fullDeck.shuffled()
  @Published private(set) var pile: [Card] = []
  @Published private(set) var hands: [Player: [Card]] = [:]
  @Published private(set) var currentPlayer: Player = .south
  
  @Published private(set) var viewingCard: Card? = nil
  
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

  func draw(for player: Player, count: Int = 1) {
    guard deck.count >= count else { return }
    var hand = hands[player] ?? []
    guard hand.count < handSize else { return }
    hand.append(contentsOf: deck.prefix(count))
    deck.removeFirst(count)
    hands[player] = hand
  }
  
  func onDeckTapped() {
    
  }
  
  func onPileTapped() {
    if let card = viewingCard {
      pile.append(card)
      viewingCard = nil
    } else if let takenCard = pile.last {
      takenCard.flip()
      addCardToPlayersHand(takenCard)
    }
    switchPlayer()
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
      viewingCard.flip()
      hands[currentPlayer]?.remove(at: indexOfSelectedCard)
      self.viewingCard = nil
      switchPlayer()
    } else if (currentPlayersHand.contains(selectedCard)) { // TODO: Change this to allow any user's hand as anyone can match at any time!
      guard let pileCard = pile.last else { return }
      selectedCard.flip()
      // Check the move after a delay to allow flip animation
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
        self?.checkMove(selectedCard, against: pileCard)
      }
    } else {
      print("Not your go!!")
    }
  }
  
  func skipTurn() {
    switchPlayer()
  }
  
  private func checkMove(_ card: Card, against pileCard: Card) {
    if card.rank == pileCard.rank {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
        self?.handleMatch(card)
      }
    } else {
      card.flip()
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
        self?.handleIncorrectMatch(card)
      }
    }
  }
  
  private func handleMatch(_ card: Card) {
    pile.append(card)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in // Waiting for animation to finish
      self?.removeCardFromCurrentPlayer(card)
      self?.switchPlayer()
    }
  }
  
  private func handleIncorrectMatch(_ card: Card) {
    drawCardForCurrentPlayer()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
      self?.switchPlayer()
      self?.flipCardOntoPile()
    }
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
