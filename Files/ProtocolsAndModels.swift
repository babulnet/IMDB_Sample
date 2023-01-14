//
//  ProtocolsAndModels.swift
//  PhonePeTest
//
//  Created by Babul Raj on 09/11/22.
//

import Foundation

struct Moviemodel {
    var title:String
    var imageURL:String
    var rating: Float
    var playListName: String?
    var id:Int
}

protocol InteractorProtocol {
    func getMoviewList(page:Int,completion: @escaping (Result<[Moviemodel],Error>)->())
    func updateList(playList: PlayList, id: Int)
    func getPlayList() -> [PlayList]
}

protocol MovieListPresenterProtocol {
    func getMovis(id:Int)
}
