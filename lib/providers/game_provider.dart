import 'dart:math';
import 'package:flutter/foundation.dart';

class GameProvider extends ChangeNotifier {
  int _numberOfPlayers = 2;
  int _goalScore = 30;
  List<int> _playerScores = [0, 0];
  int _currentPlayerIndex = 0;
  int _currentDiceValue = 1;
  bool _isRolling = false;
  int? _winnerIndex;
  final Random _random = Random();

  // Getters
  int get numberOfPlayers => _numberOfPlayers;
  int get goalScore => _goalScore;
  List<int> get playerScores => List.unmodifiable(_playerScores);
  int get currentPlayerIndex => _currentPlayerIndex;
  int get currentDiceValue => _currentDiceValue;
  bool get isRolling => _isRolling;
  int? get winnerIndex => _winnerIndex;
  bool get hasWinner => _winnerIndex != null;

  /// Initialize or reset a multiplayer match
  void setupGame({required int players, required int targetScore}) {
    _numberOfPlayers = players.clamp(2, 4);
    _goalScore = targetScore > 0 ? targetScore : 30;
    _playerScores = List.filled(_numberOfPlayers, 0);
    _currentPlayerIndex = 0;
    _currentDiceValue = 1;
    _isRolling = false;
    _winnerIndex = null;
    notifyListeners();
  }

  /// Reset the current game with the same player count and goal
  void resetGame() {
    setupGame(players: _numberOfPlayers, targetScore: _goalScore);
  }

  /// Roll the dice with realistic delay and turn progression
  Future<void> rollDice() async {
    if (_isRolling || hasWinner) return;

    _isRolling = true;
    notifyListeners();

    // Allow time for procedural 3D roll animation
    await Future.delayed(const Duration(milliseconds: 650));

    // Generate random value 1 - 6
    _currentDiceValue = _random.nextInt(6) + 1;

    // Update active player's score
    _playerScores[_currentPlayerIndex] += _currentDiceValue;

    // Check for win condition
    if (_playerScores[_currentPlayerIndex] >= _goalScore) {
      _winnerIndex = _currentPlayerIndex;
      _isRolling = false;
      notifyListeners();
      return;
    }

    // Advance to next player
    _currentPlayerIndex = (_currentPlayerIndex + 1) % _numberOfPlayers;
    _isRolling = false;
    notifyListeners();
  }
}
