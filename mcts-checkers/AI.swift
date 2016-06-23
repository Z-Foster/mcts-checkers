//
//  UCT.swift
//  mcts-checkers
//
//  Created by Zach Foster on 5/7/16.
//  Copyright © 2016 Zach Foster. All rights reserved.
//

import Foundation

/**
 Performs a Flat Monte-Carlo tree search for the specified amount of iterations in a two player game.
 - parameter root: The root state. The state we are looking for the best move for.
 - parameter iterations: The number of iterations to perform while building the search tree.
 - returns: The move with the best
 */
func AI(rootState: State, iterations: Int?, aiType: AIType) -> Move? {
  // If AI is simple random move selection, return a random move.
  if aiType == AIType.RandomMove {
    let moves = rootState.getMoves()
    if !moves.isEmpty {
      let randomIndex = Int(arc4random() % UInt32(moves.count))
      return moves[randomIndex]
    } else {
      return nil
    }
  }
  
  // Begin MCTS.
  let rootNode = Node(state: rootState)
  guard let iterations = iterations else {
    print("Iterations not set on AIType that requires it.")
    return nil
  }
  for _ in 0..<iterations {
    var node = rootNode
    let state = rootState.copy()
    
    // Selection - Perfrom selection stage of MCTS Algorithm, this is where UCT and FlatMCTS differ.
    while node.moves.isEmpty && !node.children.isEmpty {
      switch aiType {
      case .UCT:
        guard let selectedNode = selectUCT(node) else {
          print("Problem selecting UCT child node")
          return nil
        }
        node = selectedNode
      case .FlatMCTS:
        guard let selectedNode = selectFlat(node) else {
          print("Problem selecting Flat child node")
          return nil
        }
        node = selectedNode
      default:
        print("Problem selecting node")
        return nil
      }
      guard let move = node.move else {
        print("Problem selecting child node. Move unset.")
        return nil
      }
      state.makeMove(move)
    }
    
    // Expansion
    if !node.moves.isEmpty {
      //      print("Expansion")
      let randomIndex = Int(arc4random() % UInt32(node.moves.count))
      let move = node.moves[randomIndex]
      state.makeMove(move)
      node = node.expand(move, state: state)
    }
    
    // Rollout
    while !state.gameIsOver() {
      //      print("Rollout")
      let moves = state.getMoves()
      let randomIndex = Int(arc4random() % UInt32(moves.count))
      state.makeMove(moves[randomIndex])
    }
    
    // Backpropagation
    var backpropagating = true
    while backpropagating {
      //      print("Backpropagation")
      var player = PlayerNumber.One
      if node.playerNumber == PlayerNumber.One {
        player = PlayerNumber.Two
      }
      guard let result = state.getResult(player) else {
        print("Problem during backpropagation")
        return nil
      }
      node.update(result)
      if let parentNode = node.parent {
        node = parentNode
      } else {
        backpropagating = false
      }
    }
  }
  guard let bestMove =
    rootNode.children.sort({ $0.wins/Double($0.visits) > $1.wins/Double($1.visits) }).first?.move
    else {
      print("Couldn't find best move.")
      return nil
  }
  return bestMove
}

/**
 Selects a child node based on UCT: wins/visits + sqrt(2*log(self.visits)/visits)
 
 - Returns: The child node with the highest UCT value. Nil if no children exist.
 */
func selectUCT(node: Node) -> Node? {
  // Swift says it can't complete this function in reasonable time. Have to split it up.
  //    let uctValues = children.map{ return Double($0.wins)/Double($0.visits) +
  //                                         sqrt(2 * log(Double(self.visits/$0.visits))) }
  
  let uctPartOne = node.children.map{ return Double($0.wins)/Double($0.visits) }
  let uctPartTwo = node.children.map{ return 1/sqrt(2) * sqrt(2 * log(Double(node.visits))/Double($0.visits)) }
  
  // Add uctPartOne and uctPartTwo
  let uctValues = zip(uctPartOne, uctPartTwo).map{ $0.0 + $0.1 }
  
  // Tuple UCT values w/ corresponding node.
  let uctValuesWithNodes = zip(uctValues, node.children)
  // Select node w/ largest UCT value.
  return uctValuesWithNodes.sort{$0.0 > $1.0}.first?.1
}

/**
 Randomly selects a child node with uniform probability.
 - returns: A random child node. Nil if no children exist.
 */
func selectFlat(node: Node) -> Node? {
  let randomIndex = Int(arc4random() % UInt32(node.children.count))
  return node.children[randomIndex]
}

