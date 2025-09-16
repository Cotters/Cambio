import SwiftUI

struct GameView: View {
  @Namespace private var cardNamespace
  @Namespace private var currentPlayerNamespace
  
  @StateObject var gameEngine: BaseGameEngine
  let onMenuTapped: () -> Void
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        GameBackground()
        
        VStack(spacing: 0) {
          // MARK: - North Player Section
          VStack(spacing: 8) {
            PlayerSectionHeader(
              namespace: currentPlayerNamespace,
              isCurrentPlayer: gameEngine.currentPlayer == .north
            )
            
            // North viewing card - positioned above hand
            ZStack {
              PlayerHand(
                namespace: cardNamespace,
                cards: gameEngine.hands[.north] ?? [],
                onCardSelected: { card in
                  onPlayerCardTapped(card, for: .north)
                },
                isOpponent: true
              )
              .animation(.easeInOut(duration: 0.4), value: gameEngine.hands[.north])
              
              if gameEngine.currentPlayer == .north, let card = gameEngine.viewingCard {
                VStack {
                  ViewingCardDisplay(card: card, namespace: cardNamespace)
                  Spacer()
                }
              }
            }
            .frame(height: HAND_CARD_HEIGHT + 40) // Fixed height to prevent movement
          }
          .padding(.horizontal, 16)
          .padding(.vertical, 12)
          .background(
            RoundedRectangle(cornerRadius: 16)
              .fill(Color(.secondarySystemBackground).opacity(0.8))
              .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
          )
          .padding(.horizontal, 16)
          
          Spacer()
          
          // MARK: - Center Game Area
          if gameEngine.isPlaying {
            GameCenterArea(
              namespace: cardNamespace,
              gameEngine: gameEngine,
              onDeckTapped: onDeckTapped,
              onPileTapped: onPileTapped
            )
            .padding(.horizontal, 16)
          } else {
            GameOverView(
              northScore: gameEngine.getNorthScore(),
              northPenalty: gameEngine.getNorthPenaltyPoints(),
              southScore: gameEngine.getSouthScore(),
              southPenalty: gameEngine.getSouthPenaltyPoints(),
              onRestartTapped: onRestartTapped,
              onMenuTapped: onMenuTapped,
            )
            .transition(.scale.combined(with: .opacity))
            .animation(.easeInOut, value: gameEngine.gameState)
          }
          
          Spacer()
          
          // MARK: - South Player Section (Player)
          VStack(spacing: 8) {
            ZStack {
              PlayerHand(
                namespace: cardNamespace,
                cards: gameEngine.hands[.south] ?? [],
                onCardSelected: { card in
                  onPlayerCardTapped(card, for: .south)
                },
                isOpponent: false
              )
              .animation(.easeInOut(duration: 0.4), value: gameEngine.hands[.south])
              
              if gameEngine.currentPlayer == .south, let card = gameEngine.viewingCard {
                VStack {
                  Spacer()
                  ViewingCardDisplay(card: card, namespace: cardNamespace)
                }
              }
            }
            .frame(height: HAND_CARD_HEIGHT + 40) // Fixed height to prevent movement
            
            PlayerSectionHeader(
              namespace: currentPlayerNamespace,
              isCurrentPlayer: gameEngine.currentPlayer == .south
            )
          }
          .padding(.horizontal, 16)
          .padding(.vertical, 12)
          .background(
            RoundedRectangle(cornerRadius: 16)
              .fill(Color(.secondarySystemBackground).opacity(0.8))
              .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
          )
          .padding(.horizontal, 16)
          .padding(.bottom, 16) // Add bottom padding for visibility
        }
      }
    }
    .onAppear(perform: beginGame)
  }
  
  private func beginGame() {
    Task {
      gameEngine.beginPlaying()
      dealInitialCardsAnimated()
      try? await Task.sleep(for: .milliseconds((150 * 8) * 2))
      flipAllCards()
      try? await Task.sleep(for: .milliseconds(1500))
      flipAllCards()
      try? await Task.sleep(for: .milliseconds(800))
      gameEngine.flipCardOntoPile()
    }
  }
  
  private func onRestartTapped() {
    gameEngine.restartGame()
    beginGame()
  }
  
  private func onPlayerCardTapped(_ card: Card, for player: Player) {
    withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
      gameEngine.onCardInHandTapped(card, for: player)
    }
  }
  
  private func onDeckTapped() {
    withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
      gameEngine.onDeckTapped()
    }
  }
  
  private func onPileTapped() {
    withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
      gameEngine.onPileTapped()
    }
  }
  
  private func dealInitialCardsAnimated() {
    Task {
      for player in Player.allCases {
        for _ in 0..<gameEngine.handSize {
          try? await Task.sleep(for: .milliseconds(150))
          withAnimation(.spring()) {
            gameEngine.draw(for: player)
          }
        }
      }
    }
  }
  
  private func flipAllCards() {
    for player in Player.allCases {
      withAnimation(.spring()) {
        gameEngine.flipAllCards(for: player)
      }
    }
  }
}

struct PlayerSectionHeader: View {
  let namespace: Namespace.ID
  let isCurrentPlayer: Bool
  
  var body: some View {
    HStack {
      if isCurrentPlayer {
        Image(systemName: "play.fill")
          .font(.system(size: 14, weight: .bold))
          .scaleEffect(isCurrentPlayer ? 1.2 : 1.0)
          .animation(
            .easeInOut(duration: 0.8),
//            .repeatForever(autoreverses: true),
            value: isCurrentPlayer
          )
      }
      Spacer()
    }
    .matchedGeometryEffect(id: isCurrentPlayer, in: namespace)
    .animation(.easeInOut(duration: 0.5), value: isCurrentPlayer)
    .transition(.slide) // TODO: Why does this only slide one-way?
    .frame(height: 8)
    .padding(.vertical, 2)
    .zIndex(100)
  }
}

struct ViewingCardDisplay: View {
  let card: Card
  let namespace: Namespace.ID
  
  var body: some View {
    FlippableCard(card: card, canFlip: false)
      .matchedGeometryEffect(id: card.id, in: namespace)
      .frame(height: HAND_CARD_HEIGHT * 0.9)
      .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 3)
      .animation(.easeInOut(duration: 0.4), value: card)
  }
}

#Preview {
  let engine = BaseGameEngine()
  GameView(gameEngine: engine, onMenuTapped: {})
}
