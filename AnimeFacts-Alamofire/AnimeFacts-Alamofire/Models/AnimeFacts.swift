//
//  AnimeFacts.swift
//  AnimeFacts-Alamofire
//
//  Created by Малиль Дугулюбгов on 18.01.2022.
//

struct AnimeFacts: Decodable {
    let success: Bool?
    let total_facts: Int?
    let anime_img: String?
    let data: [AnimeFact]?
}

struct AnimeFact: Decodable {
    let fact_id: Int?
    let fact: String?
}
