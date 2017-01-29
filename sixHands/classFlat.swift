//
//  classFlat.swift
//  sixHands
//
//  Created by Илья on 29.01.17.
//  Copyright © 2017 Владимир Марков. All rights reserved.
//

import Foundation
class Flat{
    var imageOfFlat: String
    var avatarImage: String
    var flatSubway:String
    var numberOfRoomsInFlat:String
    var flatMutualFriends:String
    var flatPrice:String
    
    init(imageOfFlat: String,avatarImage: String,flatSubway:String, numberOfRoomsInFlat:String, flatMutualFriends:String,flatPrice:String ){
    self.imageOfFlat = imageOfFlat
    self.avatarImage = avatarImage
    self.flatSubway = flatSubway
    self.numberOfRoomsInFlat = numberOfRoomsInFlat
    self.flatMutualFriends = flatMutualFriends
    self.flatPrice = flatPrice
    }
}
