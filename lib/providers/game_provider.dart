import 'dart:math';
import 'package:flutter/foundation.dart';

class GameProvider extends ChangeNotifier {
  bool _isSinglePlayer = false;
  int _numberOfPlayers = 2;
  int _goalScore = 30;
  List<int> _playerScores = [0, 0];
  int _currentPlayerIndex = 0;
  int _currentDiceValue = 1;
  bool _isRolling = false;
  bool _isAiRolling = false;
  int? _winnerIndex;
  final Random _random = Random();

  // Getters
  bool get isSinglePlayer => _isSinglePlayer;
  int get numberOfPlayers => _numberOfPlayers;
  int get goalScore => _goalScore;
  List<int> get playerScores => List.unmodifiable(_playerScores);
  int get currentPlayerIndex => _currentPlayerIndex;
  int get currentDiceValue => _currentDiceValue;
  bool get isRolling => _isRolling;
  bool get isAiRolling => _isAiRolling;
  int? get winnerIndex => _winnerIndex;
  bool get hasWinner => _winnerIndex != null;

  /// Check if the active turn belongs to the AI bot
  bool get isAiTurn => _isSinglePlayer && _currentPlayerIndex == 1;

  /// Initialize multiplayer match
  void setupGame({required int players, required int targetScore}) {
    _isSinglePlayer = false;
    _numberOfPlayers = players.clamp(2, 4);
    _goalScore = targetScore > 0 ? targetScore : 30;
    _resetInternalState();
    notifyListeners();
  }

  /// Initialize single player match against AI
  void setupSinglePlayer({required int targetScore}) {
    _isSinglePlayer = true;
    _numberOfPlayers = 2; // Player 1 (Human), Player 2 (AI Bot)
    _goalScore = targetScore > 0 ? targetScore : 30;
    _resetInternalState();
    notifyListeners();
  }

  void _resetInternalState() {
    _playerScores = List.filled(_numberOfPlayers, 0);
    _currentPlayerIndex = 0;
    _currentDiceValue = 1;
    _isRolling = false;
    _isAiRolling = false;
    _winnerIndex = null;
  }

  /// Reset the active game maintaining single/multiplayer settings
  void resetGame() {
    if (_isSinglePlayer) {
      setupSinglePlayer(targetScore: _goalScore);
    } else {
      setupGame(players: _numberOfPlayers, targetScore: _goalScore);
    }
  }

  /// Roll the dice with procedural delay, win check, and AI handoff
  Future<void> rollDice() async {
    if (_isRolling || hasWinner) return;

    _isRolling = true;
    notifyListeners();

    // Procedural 3D roll spin delay
    await Future.delayed(const Duration(milliseconds: 650));

    // Roll random number 1 to 6
    _currentDiceValue = _random.nextInt(6) + 1;

    // Update current player's score
    _playerScores[_currentPlayerIndex] += _currentDiceValue;

    // Check win condition
    if (_playerScores[_currentPlayerIndex] >= _goalScore) {
      _winnerIndex = _currentPlayerIndex;
      _isRolling = false;
      _isAiRolling = false;
      notifyListeners();
      return;
    }

    // Advance to next player
    _currentPlayerIndex = (_currentPlayerIndex + 1) % _numberOfPlayers;
    _isRolling = false;
    notifyListeners();

    // If it is now AI's turn in Single Player mode, trigger automated turn
    if (_isSinglePlayer && _currentPlayerIndex == 1 && !hasWinner) {
      _triggerAiTurn();
    }
  }

  /// Automated AI turn with simulated thinking delay
  Future<void> _triggerAiTurn() async {
    _isAiRolling = true;
    notifyListeners();

    // Simulate AI thinking / decision pause
    await Future.delayed(const Duration(milliseconds: 1400));

    if (!_isSinglePlayer || _currentPlayerIndex != 1 || hasWinner) {
      _isAiRolling = false;
      notifyListeners();
      return;
    }

    // AI rolls the dice
    _isRolling = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 650));

    _currentDiceValue = _random.nextInt(6) + 1;
    _playerScores[1] += _currentDiceValue;

    if (_playerScores[1] >= _goalScore) {
      _winnerIndex = 1;
      _isRolling = false;
      _isAiRolling = false;
      notifyListeners();
      return;
    }

    // Pass turn back to human player (Player 1)
    _currentPlayerIndex = 0;
    _isRolling = false;
    _isAiRolling = false;
    notifyListeners();
  }
}
