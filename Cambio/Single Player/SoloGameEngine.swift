import SwiftUI
import GameKit

final class SoloGameEngine: BaseGameEngine {
  
  @EnvironmentObject private var gameCenter: GameCenterManager
  
  private var canDrawFromPile: Bool = true
  
  override init(handSize: Int = SP_HAND_SIZE) {
    super.init(handSize: handSize)
  }
  
  override var isPlaying: Bool {
    return gameState != .gameOver
  }
  
  var hand: [Card] {
    return hands[.south] ?? []
  }
  
  private func drawCardAfterSmallDelay() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
      self?.drawViewingCardForCurrentPlayer()
    }
  }
  
  func draw(_ count: Int = 1) {
    super.draw(for: .south)
  }
  
  override func draw(_ count: Int = 1, for player: Player) {
    super.draw(count, for: .south)
  }
  
  func flipAllCards() {
    super.flipAllCards(for: .south)
  }
  
  override func onDeckTapped() {
    canDrawFromPile = true
    super.onDeckTapped()
  }
  
  override func onPileTapped() {
    guard canDrawFromPile else { return }
    super.onPileTapped()
  }
  
  override func onCardInHandTapped(_ selectedCard: Card) {
    guard isPlaying else { return }
    canDrawFromPile = false // You just discarded the top card in pile; so take-backs!
    super.onCardInHandTapped(selectedCard)
  }
  
  private func handleIncorrectMatch(_ card: Card) {
    draw(1, for: currentPlayer)
  }
  
  override func onCambioTapped() {
    guard isPlaying && viewingCard == nil else { return }
    setGameOverState()
    saveScore(getSouthScore())
  }
  
  override func switchPlayer() {
    // No need.
  }
  
  func saveScore(_ score: Int) {
    Task {
      try await GameCenterManager.shared.submitScore(score)
    }
  }

}
