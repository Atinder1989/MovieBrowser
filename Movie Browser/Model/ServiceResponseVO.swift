//
//  ServiceResponseVO.swift
//  Movie Browser
//
//  Created by Atinderpal Singh on 01/12/17.
//  Copyright © 2017 XYZ. All rights reserved.
//

import Foundation

struct ServiceResponseVO {
    
    var results         : [Movie]
    var page            : Int
    var total_results   : Int
    var total_pages     : Int
}

extension ServiceResponseVO : Codable {
    
    enum ServiceResponseVOCodingKeys : String , CodingKey {
        case results,total_results,total_pages,page
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: ServiceResponseVOCodingKeys.self)
        
        self.total_results  = try container.decode(Int.self, forKey: .total_results)
        self.total_pages    = try container.decode(Int.self, forKey: .total_pages)
        self.page           = try container.decode(Int.self, forKey: .page)
        self.results        = try container.decode([Movie].self, forKey: .results)
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
}
