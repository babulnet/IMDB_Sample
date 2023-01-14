//
//  MovieListPresenter.swift
//  PhonePeTest
//
//  Created by Babul Raj on 09/11/22.
//

import Foundation

class PlayList {
    var name: String
    var list: [Int] //moview ids
    
     init(_ name: String, _ list: [Int]) {
        self.name = name
        self.list = list
    }
}

class MovieListPresenter: ObservableObject {
    var interactor: InteractorProtocol = Interactor()
    @Published var movies:[Moviemodel] = []
    @Published var isLoading = false
    private var page = 1
    @Published var playLists:[PlayList] = []
    
    func getMovis(page:Int) {
        self.interactor.getMoviewList(page: page) { result in
            switch result {
            case .success(let movies):
                self.playLists = self.interactor.getPlayList()
                self.movies.append(contentsOf: movies)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func shouldLoadData(id:Int) -> Bool {
        if movies.count - 2 == id {
            page += 1
            
            return true
        }
        return false
    }
    
    func handleSelection(name:String?,index:Int?, id: Int?) {
        if let id = id, let index = index {
            self.playLists[id].list.append(self.movies[index].id)
            movies[index].playListName = playLists[id].name
            self.interactor.updateList(playList: self.playLists[id], id: self.movies[index].id)
        } else if let index = index, let name = name {
            let newPlayList = PlayList(name, [movies[index].id])
            movies[index].playListName = name
            playLists.append(newPlayList)
            self.interactor.updateList(playList: newPlayList, id: movies[index].id)
        }
        
    }
}
