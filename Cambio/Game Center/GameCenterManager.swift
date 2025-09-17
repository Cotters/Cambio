import GameKit
import SwiftUI

fileprivate let buildNumber: Int = 12092025

@MainActor
class GameCenterManager: ObservableObject {
  static let shared = GameCenterManager()
  
  @Published var isAuthenticated = false
  @Published var authenticationError: Error?
  
  private init() {}
  
  func authenticatePlayer() async {
    GKLocalPlayer.local.authenticateHandler = { vc, error in
      if error == nil {
        self.isAuthenticated = true
      } else {
        print("(GameCenterManager) Error authenticating GK player.")
        print(error?.localizedDescription ?? "")
        self.authenticationError = error
        self.isAuthenticated = false
        return
      }
    }
  }
  
  func submitScore(_ score: Int, context: Int64 = 0) async throws {
    guard isAuthenticated else {
      print("Cannot save score; not authenticated.")
      throw NSError(domain: "GameCenter", code: -1, userInfo: [NSLocalizedDescriptionKey: "Cannot save score; not authenticated."])
    }
    
    try await GKLeaderboard.submitScore(
      score,
      context: buildNumber,
      player: GKLocalPlayer.local,
      leaderboardIDs: [MAIN_LEADERBOARD_ID]
    )
  }
}
