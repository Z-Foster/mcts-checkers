//
//  Move.swift
//  mcts-checkers
//
//  Created by Zach Foster on 5/5/16.
//  Copyright © 2016 Zach Foster. All rights reserved.
//

import Foundation

struct Move {
  var fromLocation: BoardLocation
  var toLocation: BoardLocation
  var isJump: Bool
}

func == (lhs: Move, rhs: Move) -> Bool {
  return (lhs.fromLocation == rhs.fromLocation) && (lhs.toLocation == rhs.toLocation) &&
         (lhs.isJump == rhs.isJump)
}