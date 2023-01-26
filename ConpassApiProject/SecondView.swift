//
//  SecondView.swift
//  ConpassApiProject
//
//  Created by cmStudent on 2023/01/12.
//


import SwiftUI
import UIKit

struct Responce: Decodable {
    var events: [Event]
}//JSON読み込み


struct Event: Decodable, Identifiable {
    var id: Int
    var title: String
    var eventUrl: String
    var hashTag: String
    var startDate: String
    var endDate: String
    var address: String
    var ownerDisplayName: String
    
    enum CodingKeys: String, CodingKey {
        case id = "event_id"
        case title = "title"
        case eventUrl = "event_url"
        case hashTag = "hash_tag"
        case startDate = "started_at"
        case endDate = "ended_at"
        case address = "address"
        case ownerDisplayName = "owner_display_name"
    }
    
}//JSON読み込み

struct SecondView: View {
    @State private var event = [Event]()
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [])
    var history: FetchedResults<History>
    @Binding var keyWord: String
    @State var numbers: String = ""
    @State var valueArray: [String] = []
    @State var userDefaults = UserDefaults.standard//インスタンス生成

    
    var body: some View {
        NavigationView {
            List(event) { list in

                VStack(alignment: .leading) {
                    Text("タイトル：\(list.title)")
                    Text("ハッシュタグ： \(list.hashTag)")
                    Text("アドレス： \(list.address)")
                    Text("開始時間: \(list.startDate)")
                    Text("終了時間： \(list.endDate)")
                    Link("ページに飛ぶ",destination: URL(string: list.eventUrl)!)
                }
                
            }
            .navigationTitle(Text("検索結果"))
        }.onAppear(perform:  {
            loadData(str: keyWord)
        })
    }


    func loadData(str: String) {
    let url = URL(string:"https://connpass.com/api/v1/event/?keyword=" + str)!
        print(url)
    
    //URLリクエストの生成
    let request = URLRequest(url: url)
    
    
    URLSession.shared.dataTask(with: request) { data, responce, error in
        
        if let data = data {
            let decoder: JSONDecoder = JSONDecoder()
            guard let decodeResponce = try? decoder.decode(Responce.self,from: data) else {
                print("Json decode エラー")
                
                return
            }
            
            DispatchQueue.main.async {
                event = decodeResponce.events
            }
        } else {
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }
    }.resume()
   }
    func SaveData() {
        //Contextの中にデータを作る記述
        let newHistory = History(context: viewContext)
        newHistory.number = numbers
        do {
            //saveを試みて上手くいけばデータをContextからPersistentStoreー＞データベースへとデータを送る
            try viewContext.save()
        } catch {
            fatalError("セーブに失敗")
        }
    }
  //TODO: これからこのメソッド使うかも
//    func saveArray(number: String) {
//        let newArray = History(context: viewContext)
//        newArray.numberArray = number as NSObject
//        do {
//            try viewContext.save()
//
//        }catch{
//            fatalError("セーブに失敗")
//        }
//
//    }
    
  
}
    



struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        SecondView(keyWord: .constant(""), numbers: "")
    }
}
