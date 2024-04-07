//
//  User.swift
//  remedi
//
//  Created by Rushil Madhu on 4/6/24.
//

import Foundation

struct User: Codable {
    let id: String
    let name: String
    let email: String
}

extension Encodable {
    func asDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else {
            return [:]
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            return json ?? [:]
        } catch {
            return [:]
        }
    }
}
