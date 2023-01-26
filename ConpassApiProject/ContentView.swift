//
//  ContentView.swift
//  ConpassApiProject
//
//  Created by cmStudent on 2023/01/06.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("", systemImage: "checkmark.circle")
                }
            // TODO: これからviewを増やして機能を追加していく
//            EventIdView(numbers: .constant(""))
//                .tabItem {
//                    Label("", systemImage: "checkmark.circle")
//                }
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
