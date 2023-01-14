//
//  PhonePeTestApp.swift
//  PhonePeTest
//
//  Created by Babul Raj on 09/11/22.
//

import SwiftUI

@main
struct PhonePeTestApp: App {
    var body: some Scene {
        WindowGroup {
            MovieListView(presenter: MovieListPresenter())
        }
    }
}
