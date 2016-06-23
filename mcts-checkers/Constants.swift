//
//  Constants.swift
//  mcts-checkers
//
//  Created by Zach Foster on 5/5/16.
//  Copyright © 2016 Zach Foster. All rights reserved.
//

import Foundation


let GRID_WIDTH = 8
let GRID_HEIGHT = 8

enum PlayerNumber: Int {
  case One = 1
  case Two = 2
  case None = -1
}

enum Result: Double {
  case Loss = 0
  case Win = 1
  case Draw = 0.5
}

enum SpaceType {
  case OffLimits
  case Empty
  case PlayerOne
  case PlayerTwo
}

enum Direction: Int {
  case PlayerOne = -1
  case PlayerTwo = 1
}

enum AIType: String {
  case RandomMove = "Random moves"
  case UCT = "UCT"
  case FlatMCTS = "Flat MCTS"
}

