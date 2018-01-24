//
//  Movie.swift
//  Movie Browser
//
//  Created by Atinderpal Singh on 03/12/17.
//  Copyright © 2017 XYZ. All rights reserved.
//

import Foundation

struct Movie : Decodable
{
    var id                  : UInt
    var title               : String
    var popularity          : Double
    var vote_average        : Double
    var poster_path         : String?
    var overview            : String
    var release_date        : String
    var original_title      : String
}
