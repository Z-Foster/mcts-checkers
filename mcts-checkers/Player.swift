//
//  Player.swift
//  mcts-checkers
//
//  Created by Zach Foster on 6/23/16.
//  Copyright © 2016 Zach Foster. All rights reserved.
//

import Foundation

struct Player {
  let number: PlayerNumber
  var type: AIType?
  var iterations: Int?
  
  var ticks: clock_t?
  var aveTicks = 0
  
  var moves = 0
  var wins = 0
  var draws = 0
  
  init(number: PlayerNumber){
    self.number = number
  }
}
