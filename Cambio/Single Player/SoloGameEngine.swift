import SwiftUI
import GameKit

final class SoloGameEngine: BaseGameEngine {
  
  @EnvironmentObject private var gameCenter: GameCenterManager
  
  private var timer: Timer? = nil
  @Published var timeLeft: Float = 0.0
  
  private var canDrawFromPile: Bool = true
  
  override init(handSize: Int = SP_HAND_SIZE) {
    super.init(handSize: handSize)
  }
  
  override func restartGame(deck: Deck = Deck.standardWithJokers.shuffled()) {
    canDrawFromPile = true
    super.restartGame(deck: deck)
  }
  
  override var isPlaying: Bool {
    return gameState == .playing
  }
  
  var hand: [Card] {
    return hands[.south] ?? []
  }
  
  func beginPlaying(gameMode: SoloGameMode) {
    beginPlaying()
    startTimer(gameMode: gameMode)
  }

  private func startTimer(gameMode: SoloGameMode) {
    startGameTimer(time: gameMode.rawValue)
  }
  
  private func startGameTimer(time: TimeInterval) {
    timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    if let newTimer = timer {
      RunLoop.current.add(newTimer, forMode: .common)
    }
    timeLeft = Float(time)
  }
  
  @objc func timerFired() {
    timeLeft -= 0.1
    if (timeLeft <= 0) {
      onGameEnded()
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
  
  override func onCardInHandTapped(_ selectedCard: Card, for player: Player) {
    guard isPlaying else { return }
    canDrawFromPile = false // You just discarded the top card in pile; so take-backs!
    super.onCardInHandTapped(selectedCard, for: .south)
  }
  
  private func handleIncorrectMatch(_ card: Card) {
    draw(1, for: currentPlayer)
  }
  
  override func onCambioTapped() {
    guard isPlaying && viewingCard == nil else { return }
    onGameEnded()
  }
  
  private func onGameEnded() {
    timer?.invalidate()
    setGameOverState(delayed: false)
    saveScoreToGameCenter(getSouthScore())
  }
  
  override func switchPlayer() {
    // No need.
  }
  
  func saveScoreToGameCenter(_ score: Int) {
    // TODO: Update for game types.
    Task {
      try await GameCenterManager.shared.submitScore(score)
    }
  }
  
  deinit {
    timer?.invalidate()
  }

}
