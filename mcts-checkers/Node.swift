//
//  Node.swift
//  mcts-checkers
//
//  Created by Zach Foster on 5/5/16.
//  Copyright © 2016 Zach Foster. All rights reserved.
//

import Foundation

/**
 The Node class represents a node in a Monte-Carlo search tree.
 */
class Node {
  
  var playerNumber: PlayerNumber
  var moves: [Move]
  var root: Bool
  
  var parent: Node?
  var move: Move?
  
  var children = [Node]()
  var wins = 0.0
  var visits = 0
  
  
  /**
   Initializer for the root node
   
   - Parameter state: Current state of the game being played.
   */
  init(state: State) {
    self.playerNumber = state.currentPlayerNumber
    self.moves = state.getMoves()
    self.parent = nil
    self.root = true
  }
  
  /**
   Initializer for child nodes.
   
   - Parameter state: Current state of the game being played.
   - Parameter move: The move that leads to the state of this node.
   - Parameter parent: Parent Node.
   */
  init(state: State, move: Move, parent: Node){
    self.playerNumber = state.currentPlayerNumber
    self.moves = state.getMoves()
    self.move = move
    self.parent = parent
    self.root = false
  }
  
  
  /**
   Expands the search tree.
   
   - parameter move: The move the leads from the current node to the new node.
   - parameter state: State of the game of the new node.
   - returns: The newly expanded node.
   */
  func expand(move: Move, state: State) -> Node {
    let newChild = Node(state: state, move: move, parent: self)
    if let index = moves.indexOf({ $0 == move }) {
      moves.removeAtIndex(index)
    }
    children.append(newChild)
    return newChild
  }
  
  /**
   Updates win and visit properties during backpropagation.
   
   - Parameter result: The result of the simulation that is backpropagating.
   */
  func update(result: Result){
    visits += 1
    wins += result.rawValue
  }
}