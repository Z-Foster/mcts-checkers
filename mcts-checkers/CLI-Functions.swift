//
//  CLI-Functions.swift
//  mcts-checkers
//
//  Created by Zach Foster on 6/23/16.
//  Copyright © 2016 Zach Foster. All rights reserved.
//

import Foundation

func prompt(playerNumber: Int) {
  print("What AI would you like player \(playerNumber) to use?")
  print("1. Pure Random")
  print("2. Flat Monte-Carlo Tree Search")
  print("3. UCT Monte-Carlo Tree Search")
}

func aiSelection(inout player: Player) {
  if let answer = readLine(stripNewline: true) {
    switch answer {
    case "1":
      player.type = AIType.RandomMove
    case "2":
      player.type = AIType.FlatMCTS
      player.iterations = iterationSelection()
    case "3":
      player.type = AIType.UCT
      player.iterations = iterationSelection()
    default:
      print("Please enter 1, 2, or 3.")
      aiSelection(&player)
    }
  } else {
    print("Please enter 1, 2, or 3.")
    aiSelection(&player)
  }
}

func iterationSelection() -> Int? {
  print("How many iterations of the MCTS would you like to perform? (> 0)")
  if let answer = readLine(stripNewline: true) {
    if let number = Int(answer) {
      if number > 0 {
        return number
      } else {
        print("Number must be greater than 0.")
        iterationSelection()
      }
    } else {
      print("Please enter a number.")
      iterationSelection()
    }
  } else {
    print("Please enter a number.")
    iterationSelection()
  }
  return nil
}

func numberOfGamesSelection() -> Int? {
  print("How many games would you like to simulate? ( > 0 )")
  if let answer = readLine(stripNewline: true) {
    if let number = Int(answer) {
      if number > 0 {
        return number
      } else {
        print("Number must be greater than 0.")
        numberOfGamesSelection()
      }
    } else {
      print("Please enter a number.")
      numberOfGamesSelection()
    }
  } else {
    print("Please enter a number.")
    numberOfGamesSelection()
  }
  return nil
}
