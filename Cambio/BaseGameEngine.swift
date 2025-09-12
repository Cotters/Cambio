import SwiftUI

enum GameState: Equatable {
  case start
  case playing
  case cambioCalled
  case gameOver
  case animating
}

let EMPTY_PENALTIES: [Player: Int] = [.north : 0, .south: 0]

// Base class for game engines
class BaseGameEngine: ObservableObject {
  @Published private(set) var deck: Deck = Deck.standardWithJokers.shuffled()
  @Published private(set) var pile: [Card] = []
  @Published private(set) var viewingCard: Card? = nil
  
  @Published private(set) var hands: [Player: [Card]] = [:]
  @Published private(set) var currentPlayer: Player = .south
  
  @Published private(set) var penalties: [Player: Int] = EMPTY_PENALTIES
  
  @Published private(set) var gameState: GameState = .start
  
  let handSize: Int
  
  var isPlaying: Bool {
    gameState == .playing || gameState == .cambioCalled
  }
  
  var canDrawCard: Bool {
    gameState != .gameOver && viewingCard == nil
  }
  
  private var currentPlayersHand: [Card]? {
    return hands[currentPlayer]
  }

  init(handSize: Int = HAND_SIZE) {
    self.handSize = handSize
  }
  
  init(handSize: Int = HAND_SIZE, deck: Deck = Deck.standardWithJokers.shuffled()) {
    self.handSize = handSize
  }
  
#if DEBUG
  init() {
    self.handSize = 4
    deck = Deck.standardWithJokers.shuffled().suffix(12)
    restartGame(deck: deck)
  }
#endif
  
  func restartGame(deck: Deck = Deck.standardWithJokers.shuffled()) {
    self.deck = deck
    pile = []
    hands = [:]
    penalties = EMPTY_PENALTIES
    viewingCard = nil
    currentPlayer = .south
    gameState = .start
  }
  
  func beginPlaying() {
    gameState = .playing
  }
  
  func drawViewingCardForCurrentPlayer() {
    guard canDrawCard else { return }
    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    impactFeedback.impactOccurred()
    let topCard = getTopCardFromDeck()
    topCard?.flip()
    viewingCard = topCard
    if (deck.count == 0) {
      gameState = .cambioCalled
    }
  }
  
  private func getTopCardFromDeck() -> Card? {
    return deck.removeFirst()
  }
  
  func draw(_ count: Int = 1, for player: Player) {
    guard canDrawCard && deck.count >= count else { return }
    var hand = hands[player] ?? []
    guard hand.count < handSize else { return }
    let newCards = deck.prefix(count)
    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    impactFeedback.impactOccurred()
    deck.removeFirst(count)
    hand.append(contentsOf: newCards)
    hands[player] = hand
  }
  
  func onDeckTapped() {
    guard isPlaying else { return }
    drawViewingCardForCurrentPlayer()
  }
  
  func onPileTapped() {
    guard isPlaying else { return }
    if let card = viewingCard {
      pile.append(card)
      viewingCard = nil
      switchPlayer()
    } else if (pile.count > 0) {
      viewingCard = pile.popLast()
    }
  }
  
  func flipAllCards(for player: Player) {
    guard isPlaying else { return }
    guard let hand = hands[player] else { return }
    for card in hand { card.flip() }
  }
  
  func turnCardsFaceUp(for player: Player) {
    guard isPlaying else { return }
    guard let hand = hands[player] else { return }
    for card in hand {
      if (!card.isFaceUp) {
        card.flip()
      }
    }
  }
  
  func flipCardOntoPile() {
    guard isPlaying else { return }
    guard let topCard = deck.popLast() else { return }
    pile.append(topCard)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      topCard.flip()
    }
    if (pile.count > 1) { return }
    print("North hand: \(hands[.north] ?? [])\nSouth hand: \(hands[.south] ?? [])\n")
  }
  
  func onCardInHandTapped(_ selectedCard: Card) {
    guard isPlaying else { return }
    if let viewingCard = self.viewingCard {
      swapViewingCard(viewingCard, forPlayerCard: selectedCard)
      switchPlayer()
    } else {
      onMatchAttepmted(selectedCard)
    }
  }
  
  private func swapViewingCard(_ viewingCard: Card, forPlayerCard selectedCard: Card) {
    guard let indexOfSelectedCard = currentPlayersHand?.firstIndex(of: selectedCard) else { return }
    selectedCard.flip()
    pile.append(selectedCard)
    hands[currentPlayer]?.remove(at: indexOfSelectedCard)
    viewingCard.flip()
    hands[currentPlayer]?.insert(viewingCard, at: indexOfSelectedCard)
    self.viewingCard = nil
  }
  
  private func onMatchAttepmted(_ selectedCard: Card) {
    let isNorthMatching = hands[.north]?.contains(selectedCard) ?? false
    let isSouthMatching = hands[.south]?.contains(selectedCard) ?? false
    guard isNorthMatching || isSouthMatching else { return }
    guard let pileCard = pile.last else { return }
    selectedCard.flip()
    // Check the move after a delay to allow flip animation
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
      self?.checkMove(selectedCard, against: pileCard, for: isNorthMatching ? .north : .south)
    }
  }
  
  private func checkMove(_ card: Card, against pileCard: Card, for player: Player) {
    if card.rank == pileCard.rank {
      handleMatch(card, for: player)
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
    let hand = hands[player] ?? []
    if hand.count < handSize {
      draw(1, for: player)
    } else {
      penalties[player]? += 1
    }
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
  
  func switchPlayer() {
    if (gameState == .cambioCalled) {
      setGameOverState()
    } else {
      self.currentPlayer = (currentPlayer == .north) ? .south : .north
    }
  }
  
  func onCambioTapped() {
    guard isPlaying && viewingCard == nil else { return }
    switchPlayer()
    gameState = .cambioCalled
  }
  
  func getNorthScore() -> Int {
    let baseScore = hands[.north]?.getScore() ?? 0
    return baseScore + getNorthPenaltyPoints()
  }
  
  func getNorthPenaltyPoints() -> Int {
    return (penalties[.north] ?? 0)
  }
  
  func getSouthScore() -> Int {
    let baseScore = hands[.south]?.getScore() ?? 0
    return baseScore + getSouthPenaltyPoints()
  }
  
  func getSouthPenaltyPoints() -> Int {
    return (penalties[.south] ?? 0)
  }
  
  func setGameOverState() {
//    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in // TODO: Give time for cards to settle?
      turnCardsFaceUp(for: .north)
      turnCardsFaceUp(for: .south)
      gameState = .gameOver
//    }
  }

}

fileprivate extension Array where Element == Card {
  func getScore() -> Int {
    return self.reduce(0) { (partialResult, card) in
      partialResult + card.points
    }
  }
}
