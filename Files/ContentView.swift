//
//  ContentView.swift
//  PhonePeTest
//
//  Created by Babul Raj on 09/11/22.
//

import SwiftUI

extension Int:Identifiable {
    public var id: Int {
        return self
    }
}

struct MovieListView: View {
   @ObservedObject var presenter: MovieListPresenter
    @State var isPresented = false
    @State var selectedIndex:Int? = nil
    
    var body: some View {
        List(0..<presenter.movies.count, id:\.self) {
            index in
            VStack {
                AsyncImage(url: URL(string:presenter.movies[index].imageURL)!) { image in
                    image.resizable()
                        .frame(height:300)
                } placeholder: {
                    ProgressView()
                }

                
                HStack {
                    VStack(alignment:.leading) {
                        Text(presenter.movies[index].title)
                            .font(.largeTitle)
                        Text("Rating - \(presenter.movies[index].rating)")
                            .font(.headline)
                        if let text = presenter.movies[index].playListName {
                            Text(text)
                                .font(.subheadline)
                        }
                    }
                    .onAppear {
                        if presenter.shouldLoadData(id: index) {
                            presenter.getMovis(page: index)
                        }
                    }
                    
                    
                    Spacer()
                    Image(systemName: "star.fill")
                        .frame(width: 50, height: 50)
                        .onTapGesture {
                            isPresented = true
                            selectedIndex = index
                            print(index)
                        }
                        .sheet(item: $selectedIndex) { item in
                            BottomSheetView(presenter: presenter, newPlayListName: "") { string,id in
                                presenter.handleSelection(name: string, index: selectedIndex, id: id)
                                selectedIndex = nil
                            }
                        }
                }
            }
            
        }
        .onAppear {
            presenter.getMovis(page: 1)
        }
    }
}

struct BottomSheetView: View {
    var presenter: MovieListPresenter
    @State var newPlayListName: String
    var completion:(String?,Int?)->()
    
    
    var body: some View {
        VStack {
            List(0..<presenter.playLists.count, id:\.self) {
                index in
                Text(presenter.playLists[index].name)
                    .onTapGesture {
                       completion(nil, index)
                    }
            }
            TextField("Add New PlayList", text:$newPlayListName )
            Button("Save") {
                completion(newPlayListName,nil)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView(presenter: MovieListPresenter())
    }
}



