import GameKit

extension GKLocalPlayer {
  func authenticate() async throws {
    if isAuthenticated { return }
    
    return try await withCheckedThrowingContinuation { continuation in
      authenticateHandler = { _, error in
        if let error = error {
          continuation.resume(throwing: error)
        } else {
          continuation.resume()
        }
      }
    }
  }
}
