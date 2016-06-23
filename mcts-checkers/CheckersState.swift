//
//  CheckersState.swift
//  mcts-checkers
//
//  Created by Zach Foster on 5/7/16.
//  Some game logic taken from Steven Materra's implementation of CheckersLite.

//Copyright (c) 2015, Steven Mattera
//All rights reserved.
//
//Redistribution and use in source and binary forms, with or without modification,
//are permitted provided that the following conditions are met:
//
//Redistributions of source code must retain the above copyright notice, this
//list of conditions and the following disclaimer.
//
//Redistributions in binary form must reproduce the above copyright notice,
//this list of conditions and the following disclaimer in the documentation
//and/or other materials provided with the distribution.
//
//Neither the name of the organization nor the names of its contributors may
//be used to endorse or promote products derived from this software without
//specific prior written permission.
//
//THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
//ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import Foundation

/**
 The CheckersState class represents the state of a checkers game.
 */
class CheckersState: State, CustomStringConvertible {
  var boardData = [[SpaceType]]()
  var currentPlayerNumber = PlayerNumber.None
  var description: String {
    var output = ""
    for y in boardData {
      for x in y {
        if x == SpaceType.Empty {
          output += "| - |"
        } else if x == SpaceType.PlayerOne {
          output += "| 1 |"
        } else if x == SpaceType.PlayerTwo {
          output += "| 2 |"
        } else {
          output += "| X |"
        }
      }
      output += "\n"
    }
    return output
  }
  
  func copy() -> State {
    let copy = CheckersState()
    copy.boardData = self.boardData
    copy.currentPlayerNumber = self.currentPlayerNumber
    return copy
  }
  
  /**
   Sets the initial state of the board and should be called once per checkers game. Not implemented
   in init() because we will be making many copies of the state, but initial setup is only needed
   once.
   */
  func setupBoard() {
    currentPlayerNumber = PlayerNumber.One
    for y in 0..<GRID_HEIGHT {
      boardData.append(Array(count:GRID_WIDTH, repeatedValue:SpaceType.OffLimits))
      for x in 0..<GRID_WIDTH {
        if (y % 2 == 0 && x % 2 != 0) || (y % 2 != 0 && x % 2 == 0) {
          if y < 3 {
            boardData[y][x] = SpaceType.PlayerTwo
          }
          else if y > 4 {
            boardData[y][x] = SpaceType.PlayerOne
          }
          else {
            boardData[y][x] = SpaceType.Empty
          }
        }
      }
    }
  }
  
  /**
   Gets all moves available to be made in the current state.
   - returns: A list of possible moves.
   */
  func getMoves() -> [Move] {
    var availableJumps = [Move]()
    var availableMoves = [Move]()
    
    var yDirection: Int
    var playerSpace: SpaceType
    var enemySpace: SpaceType
    
    // Set direction and player and enemy SpaceTypes
    if currentPlayerNumber == PlayerNumber.One {
      yDirection = Direction.PlayerOne.rawValue
      playerSpace = SpaceType.PlayerOne
      enemySpace = SpaceType.PlayerTwo
    } else {
      yDirection = Direction.PlayerTwo.rawValue
      playerSpace = SpaceType.PlayerTwo
      enemySpace = SpaceType.PlayerOne
    }
    
    for y in 0..<GRID_HEIGHT {
      for x in 0..<GRID_WIDTH {
        // A space owned by our player.
        if self.boardData[y][x] == playerSpace {
          
          // Can move left?
          if y + yDirection > 0 && y + yDirection < GRID_HEIGHT && x - 1 >= 0 {
            
            // If space is empty?
            if self.boardData[y + yDirection][x - 1] == SpaceType.Empty {
              let fromLoc = BoardLocation(x: x, y: y)
              let toLoc = BoardLocation(x: x - 1, y: y + yDirection)
              let move = Move(fromLocation: fromLoc, toLocation: toLoc, isJump: false)
              availableMoves.append(move)
            }
              
              // If space is enemy and next place over is available and empty? (Jumpable)
            else if self.boardData[y + yDirection][x - 1] == enemySpace &&
              y + (yDirection * 2) > 0 && y + (yDirection * 2) < GRID_HEIGHT && x - 2 >= 0 &&
              self.boardData[y + (yDirection * 2)][x - 2] == SpaceType.Empty {
              
              let fromLoc = BoardLocation(x: x, y: y)
              let toLoc = BoardLocation(x: x - 2, y: y + (yDirection * 2))
              let move = Move(fromLocation: fromLoc, toLocation: toLoc, isJump: true)
              availableJumps.append(move)
            }
          }
          
          // Can move Right?
          if y + yDirection > 0 && y + yDirection < GRID_HEIGHT && x + 1 < GRID_WIDTH {
            // If space is empty?
            if self.boardData[y + yDirection][x + 1] == SpaceType.Empty {
              let fromLoc = BoardLocation(x: x, y: y)
              let toLoc = BoardLocation(x: x + 1, y: y + yDirection)
              let move = Move(fromLocation: fromLoc, toLocation: toLoc, isJump: false)
              availableMoves.append(move)
            }
              
              // If space is enemy and next place over is available and empty? (Jumpable)
            else if self.boardData[y + yDirection][x + 1] == enemySpace &&
              y + (yDirection * 2) > 0 && y + (yDirection * 2) < GRID_HEIGHT && x + 2 < GRID_WIDTH &&
              self.boardData[y + (yDirection * 2)][x + 2] == SpaceType.Empty {
              
              let fromLoc = BoardLocation(x: x, y: y)
              let toLoc = BoardLocation(x: x + 2, y: y + (yDirection * 2))
              let move = Move(fromLocation: fromLoc, toLocation: toLoc, isJump: true)
              availableJumps.append(move)
            }
          }
        }
      }
    }
    if availableJumps.isEmpty{
      return availableMoves
    } else {
      return availableJumps
    }
  }

  /**
   Performs a move on the current state.
   - parameter move: The move to be made.
   */
  func makeMove(move: Move) {
    // Move the peice.
    self.boardData[move.toLocation.y][move.toLocation.x] =
      self.boardData[move.fromLocation.y][move.fromLocation.x]
    self.boardData[move.fromLocation.y][move.fromLocation.x] = SpaceType.Empty
    
    // Remove enemy peice if a jump occurred.
    if move.isJump {
      if move.toLocation.x > move.fromLocation.x && move.toLocation.y > move.fromLocation.y {
        removePiece(BoardLocation(x: move.fromLocation.x + 1, y: move.fromLocation.y + 1))
      } else if move.toLocation.x > move.fromLocation.x && move.toLocation.y < move.fromLocation.y {
        removePiece(BoardLocation(x: move.fromLocation.x + 1, y: move.fromLocation.y - 1))
      } else if move.toLocation.x < move.fromLocation.x && move.toLocation.y < move.fromLocation.y {
        removePiece(BoardLocation(x: move.fromLocation.x - 1, y: move.fromLocation.y - 1))
      } else {
        removePiece(BoardLocation(x: move.fromLocation.x - 1, y: move.fromLocation.y + 1))
      }
    }
    // Change the current player.
    if currentPlayerNumber == PlayerNumber.One {
      currentPlayerNumber = PlayerNumber.Two
    } else {
      currentPlayerNumber = PlayerNumber.One
    }
  }
  
  /**
   Checks if the game is over.
   - returns: True if the game is over, false otherwise.
   */
  func gameIsOver() -> Bool {
    return getMoves().isEmpty
  }
  
  /**
   Returns result of the game from the viewpoint of 'player'.
   - parameter player: The player you are checking the result for.
   - returns: The result of the game. nil if game is not over.
   - requires: A terminal state. Otherwise returns nil
   */
  func getResult(player: PlayerNumber) -> Result? {
    if gameIsOver() {
      var playerOnePieceCount = 0
      var playerTwoPieceCount = 0
      
      for row in boardData {
        for space in row {
          if space == SpaceType.PlayerOne {
            playerOnePieceCount += 1
          } else if space == SpaceType.PlayerTwo {
            playerTwoPieceCount += 1
          }
        }
      }
      
      if playerOnePieceCount > playerTwoPieceCount {
        if player == PlayerNumber.One {
          return Result.Win
        } else {
          return Result.Loss
        }
      } else if playerOnePieceCount < playerTwoPieceCount {
        if player == PlayerNumber.One {
          return Result.Loss
        } else {
          return Result.Win
        }
      } else {
        return Result.Draw
      }
    }
    return nil
  }
  
  /**
   - parameter location: A location on the checkers board. 
   - returns: The type of space located at the specified BoardLocation.
   */
  func getSpaceType(location: BoardLocation) -> SpaceType {
    if location.x >= 0 && location.x < GRID_WIDTH && location.y >= 0 && location.y < GRID_HEIGHT {
      return self.boardData[location.y][location.x]
    }
    
    return SpaceType.OffLimits;
  }
  
  /**
   Remove a piece from the checkers board.
   - parameter location: A location on the checkers board.
   */
  func removePiece(location: BoardLocation) {
    if self.boardData[location.y][location.x] != SpaceType.OffLimits {
      self.boardData[location.y][location.x] = SpaceType.Empty
    }
  }
}