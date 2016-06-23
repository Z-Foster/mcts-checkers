//
//  BoardLocation.swift
//  mcts-checkers
//
//  Created by Zach Foster on 5/7/16.
//  Copyright © 2016 Zach Foster. All rights reserved.
//

import Foundation

struct BoardLocation {
  var x: Int
  var y: Int
}

func == (lhs: BoardLocation, rhs: BoardLocation) -> Bool{
  return (lhs.x == rhs.x) && (lhs.y == rhs.y)
}