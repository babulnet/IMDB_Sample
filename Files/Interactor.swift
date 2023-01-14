//
//  Interactor.swift
//  PhonePeTest
//
//  Created by Babul Raj on 09/11/22.
//

import Foundation
import SwiftUI


struct MoviesNetworkModel: Codable {
    let dates: Dates?
    let page: Int?
    let results: [Movies]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Dates
struct Dates: Codable {
    let maximum, minimum: String?
}

// MARK: - Result
struct Movies: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int
    let originalLanguage, originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}


class Interactor: InteractorProtocol {
    
    func getMoviewList(page:Int,completion: @escaping (Result<[Moviemodel],Error>)->() ) {
        
        //Netwerok if
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=38a73d59546aa378980a88b645f487fc&language=en-US&page=1") else {
            return
        }
        
        let session = URLSession.shared
        session.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print(error)
            } else {
                do {
                    let data = try JSONDecoder().decode(MoviesNetworkModel.self, from: data!)
                    let movies = self.transformNetworkmodel(data)
        
                    DispatchQueue.main.async {
                        completion(.success(movies))
                    }
                   // DispatchQueue.main.async { [weak self] in
                    
//                        if let movies = self.transformNetworkmodel(data) {
//                        completion(.success(movies))
//                        } else {
//                            print("error")
//                        }
                   // }
                } catch {
                    print("error parsing")
                }
            }
            
        }.resume()
    }
    
    private func transformNetworkmodel(_ model: MoviesNetworkModel) -> [Moviemodel] {
        var moviewResult:[Moviemodel] = []
        let playlist = getPlayList()
        guard let result = model.results else {return moviewResult}
        for item in result {
            let movie = Moviemodel(title: item.title ?? "",
                                   imageURL: "https://image.tmdb.org/t/p/w500\(item.backdropPath ?? "")",
                                   rating: Float(item.voteAverage ?? 0),
                                   playListName: playlist.first(where: { playList in
                playList.list.contains(Int(item.id ?? 0))
            })?.name,
                                   id: item.id)
            moviewResult.append(movie)
        }
       
        return moviewResult
    }
    
    func updateList(playList:PlayList, id: Int) {
        if let result = CoredataManager.shared.fetchObjects(attributes: ["name":playList.name], inputType: PlayListStorage.self), result.count > 0 {
            let strHolder = StringHolder(context: CoredataManager.shared.context)
            strHolder.string = "\(id)"
            result.first?.addToList(strHolder)
            CoredataManager.shared.saveContext()
        } else {
            let strHolder = StringHolder(context: CoredataManager.shared.context)
            strHolder.string = "\(id)"
            let newPlayList = PlayListStorage(context: CoredataManager.shared.context)
            newPlayList.name = playList.name
            newPlayList.addToList(NSSet(object: strHolder))
            CoredataManager.shared.saveContext()
        }
    
//        let fetchRequest = PlayListStorage.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "name == %@ ", playList.name)
//        do {
//            let playListStorageArray =  try CoredataManager.shared.context.fetch(fetchRequest)
//            if let fisrst = playListStorageArray.first {
//                let strHolder = StringHolder(context: CoredataManager.shared.context)
//                strHolder.string = "\(playList.list[0].id)"
//                fisrst.addToList(strHolder)
//                CoredataManager.shared.saveContext()
//            } else {
//                let strHolder = StringHolder(context: CoredataManager.shared.context)
//                strHolder.string = playList.name
//                let newPlayList = PlayListStorage(context: CoredataManager.shared.context)
//                newPlayList.name = playList.name
//                newPlayList.addToList(NSSet(object: strHolder))
//                CoredataManager.shared.saveContext()
//            }
//
//        } catch {
//            print(error)
//        }
//
//        CoredataManager.shared.saveContext()
    }
    
    func getPlayList() -> [PlayList] {
        var playList:[PlayList] = []
        do {
            if let items = try CoredataManager.shared.context.fetch(PlayListStorage.fetchRequest()) as? [PlayListStorage] {
                for item in items {
                    var ids: [Int] = []
                    if  let id = item.list as? Set<StringHolder> {
                        ids = id.map{Int($0.string ?? "") ?? 0}
                    }
                    let playlistItem = PlayList(item.name ?? "", ids)
                    playList.append(playlistItem)
                }
                
                return playList
            }

        } catch {
            print(error)
        }
       return []
    }
}

