import Combine

enum TutorialStep {
  case intro
  case deal
  case drawCard
  case gameplay
  case cambio
}

class TutorialGameEngine: SoloGameEngine {
  
  @Published private(set) var tutorialStep: TutorialStep = .intro
  @Published private(set) var canProceed: Bool = true
  
  override init(handSize: Int = 4) {
    super.init(handSize: handSize)
    restartGame(deck: Deck.standard)
  }
  
  func restartTutorial() {
    canProceed = true
    tutorialStep = .intro
    restartGame(deck: Deck.standard)
  }
  
  override func beginPlaying(gameMode: SoloGameMode) {
    canProceed = false
    tutorialStep = .deal
    super.beginPlaying(gameMode: gameMode)
  }
  
  override func flipCardOntoPile() {
    canProceed = true
  }
  
  func hideCards() {
    tutorialStep = .drawCard
    canProceed = false
    super.flipCardOntoPile()
  }
  
  func startGameplay() {
    tutorialStep = .gameplay
    canProceed = false
  }
  
  override func onDeckTapped() {
    guard tutorialStep == .drawCard || tutorialStep == .gameplay else { return }
    canProceed = true
    super.onDeckTapped()
  }
  
  override func onPileTapped() {
    guard tutorialStep == .gameplay else { return }
    super.onPileTapped()
  }
  
  override func onCardInHandTapped(_ selectedCard: Card, for player: Player) {
    guard tutorialStep == .gameplay else { return }
    canProceed = true
    super.onCardInHandTapped(selectedCard, for: player)
  }
  
  func enableCambio() {
    tutorialStep = .cambio
  }
  
  override func onCambioTapped() {
    setGameOverState(delayed: false)
  }
  
}
