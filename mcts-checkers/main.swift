//
//  main.swift
//  mcts-checkers
//
//  Created by Zach Foster on 5/7/16.
//  Copyright © 2016 Zach Foster. All rights reserved.
//

import Foundation

var playerOne = Player(number: PlayerNumber.One)
var playerTwo = Player(number: PlayerNumber.Two)

print("Welcome to the checkers simulator.")
prompt(1)
aiSelection(&playerOne)
prompt(2)
aiSelection(&playerTwo)

var numberOfGames = numberOfGamesSelection()

guard let playerOneType = playerOne.type else { exit(1) }
guard let playerTwoType = playerTwo.type else { exit(1) }
guard let numberOfGames = numberOfGames else { exit(1) }

print("Simulating. This may take a while.")
for i in 0..<numberOfGames {
  let state = CheckersState()
  state.setupBoard()
  while !state.gameIsOver() {
    var nextMove: Move
    if state.currentPlayerNumber == playerOne.number {
      var playerOneClock = clock()
      if let move = AI(state, iterations: playerOne.iterations, aiType: playerOneType) {
        if playerOne.ticks != nil {
          playerOne.ticks! += clock() - playerOneClock
        } else {
          playerOne.ticks = clock() - playerOneClock
        }
        nextMove = move
        playerOne.moves += 1
      } else {
        print("Problem in Player One.")
        exit(0)
      }
    } else {
      var playerTwoClock = clock()
      if let move = AI(state, iterations: playerTwo.iterations, aiType: playerTwoType) {
        if (playerTwo.ticks != nil) {
          playerTwo.ticks! += clock() - playerTwoClock
        } else {
          playerTwo.ticks = clock() - playerTwoClock
        }
        nextMove = move
        playerTwo.moves += 1
      } else {
        print("Problem in Player Two.")
        exit(0)
      }
    }
    state.makeMove(nextMove)
  }

  if state.getResult(PlayerNumber.One) == Result.Win {
    playerOne.wins += 1
  } else if state.getResult(PlayerNumber.Two) == Result.Win {
    playerTwo.wins += 1
  } else {
    playerOne.draws += 1
    playerTwo.draws += 1
  }
  playerOne.aveTicks = Int(playerOne.ticks!)/(playerOne.moves)
  playerTwo.aveTicks = Int(playerTwo.ticks!)/(playerTwo.moves)
}

print("Player One:\nType: \(playerOne.type!.rawValue)")
print("Wins: \(playerOne.wins)")
print("Average ticks per move: \(playerOne.aveTicks)\n")
print("Player Two:\nType: \(playerTwo.type!.rawValue)")
print("Wins: \(playerTwo.wins)")
print("Average ticks per move: \(playerTwo.aveTicks)\n")
print("Draws: \(playerOne.draws)")
