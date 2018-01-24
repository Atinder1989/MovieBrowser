//
//  JSONParsing.swift
//  hplus-sports
//
//  Created by Atinderpal Singh on 18/07/17.
//  Copyright © 2017 Lynda.com. All rights reserved.
//

import Foundation

typealias JSONObject = [String:Any]

protocol JSONDecodable {
    init(_ decoder:JSONDecoder) throws
}

enum JSONParsingError: Error {
    case missingKey(key:String)
    case typeMismatch(key:String)
}

class JSONDecoder {
    let jsonObject: JSONObject
    
    static let defaultDateFormat = "dd/MM/yyyy HH:mm:ss"
    private lazy var dateFormatter = DateFormatter()
    
    init(_ jsonObject: JSONObject) {
    self.jsonObject = jsonObject
    }
    
    func value<T>(forKey key:String)throws -> T {
        guard let value =  jsonObject[key] else {
            throw JSONParsingError.missingKey(key:key)
        }
        guard let finalValue = value as? T else {
            throw JSONParsingError.typeMismatch(key:key)
        }
        return finalValue
    }
    
    func value(forKey key:String,format: String = JSONDecoder.defaultDateFormat )throws -> Date {
        let dateValue: String = try value(forKey: key)
        dateFormatter.dateFormat = format
        guard let returnValue = dateFormatter.date(from: dateValue) else {
            throw JSONParsingError.typeMismatch(key: key)
        }
        return returnValue
    }
}

func decode<T>(_ jsonObject: JSONObject) throws -> T where T: JSONDecodable
{
    return try T.init(JSONDecoder(jsonObject))
}

func parse<T>(_ data: Data) throws -> T where T: JSONDecodable
{
    let jsonObject:JSONObject = try deserializeInDictionary(data)
    return try decode(jsonObject)
}

func deserializeInDictionary(_ data: Data) throws -> JSONObject
{
    let json = try JSONSerialization.jsonObject(with: data, options: [])
    guard let object = json as? JSONObject else
    {
        return[:]
    }
    return object
}

func parseForArray<T>(_ data: Data) throws -> [T] where T: JSONDecodable
{
    let jsonObjects:[JSONObject] = try deserializeForArray(data)
    return try jsonObjects.map(decode)
}

func deserializeForArray(_ data: Data)throws -> [JSONObject]
{
    let json = try JSONSerialization.jsonObject(with: data, options: [])
    guard let objects = json as? [JSONObject] else { return[] }
    return objects
}
