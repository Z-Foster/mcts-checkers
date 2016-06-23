//
//  Board.swift
//  mcts-checkers
//
//  Created by Zach Foster on 5/5/16.
//  Copyright © 2016 Zach Foster. All rights reserved.
//

import Foundation

/**
 The State protocol defines the set of functions and properties required to describe a game state.
 */
protocol State: AnyObject {
  /**
   Copies the state.
   - returns: A copy of the state.
   */
  func copy() -> State
  /**
   The current player of the state.
   */
  var currentPlayerNumber: PlayerNumber { get set }
  /**
   Returns the available moves of a state.
   - returns: Available moves
   */
  func getMoves() -> [Move]
  /**
   Makes a move and updates the state.
   */
  func makeMove(move: Move)
  /**
   Checks if the game is over.
   - returns: True if the game is over, false otherwise.
   */
  func gameIsOver() -> Bool
  /**
   Returns the result of a game, often a score.
   - parameter player: The player whom you are checking the results for.
   - returns: The results for the specified player. Nil if called on a non-terminal state.
   */
  func getResult(player: PlayerNumber) -> Result?
}