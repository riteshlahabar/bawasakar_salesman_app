/// Notified when the backend rejects the stored credentials.
///
/// The API client knows nothing about routing or GetX; it only reports that
/// the session died. Whoever wires the app decides what that means (clear the
/// session, bounce to login), which keeps the network layer free of UI
/// dependencies and satisfies the single-responsibility rule.
abstract class SessionExpiryHandler {
  Future<void> onSessionExpired();
}
