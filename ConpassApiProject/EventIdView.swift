//
//  EventIdView.swift
//  ConpassApiProject
//
//  Created by cmStudent on 2023/01/20.
//

import SwiftUI

//TODO: このviewはまだ使わない
struct EventIdView: View {
    @State private var event = [Event]()
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [])
    var history: FetchedResults<History>
    @Binding var numbers: String
    @State var valueArray: [String] = []
//    init(valueArray: Binding<[String]> = .constant([""])) {
//        self._valueArray = valueArray
//    }
    
    var body: some View {
        
        List {
//            ForEach(event) { list in
//                VStack {
//                    Text("タイトル：\(list.title)")
//                    Text("ハッシュタグ： \(list.hashTag)")
//                    Text("アドレス： \(list.address)")
//                    Text("開始時間: \(list.startDate)")
//                    Text("終了時間： \(list.endDate)")
//                    Link("ページに飛ぶ",destination: URL(string: list.eventUrl)!)
//
//                }
//            }
            ForEach(valueArray, id: \.self) { item in
                VStack{
                    Text(item)
                }
            }
        }
        .onAppear(perform:  {
            valueArray.append(numbers)
        })
    }
    
    func loadData(str: String) {
        print("えす\(str)")
        let url = URL(string: "https://connpass.com/api/v1/event/?event_id=" + str)!
        print(url)
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, responce, error in
            if let data = data {//データ取得チェック
                let decoder = JSONDecoder()
                guard let decoderResponce = try? decoder.decode(Responce.self, from: data) else {
                    print("Json decodeエラー")
                    return
                }
                
                DispatchQueue.main.async {
                    event = decoderResponce.events
                }
                
                
            }else {
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            }
            
        }.resume()
    }
    
    func addHistory() {
        
    }
}
    

//struct EventIdView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventIdView()
//    }
//}
