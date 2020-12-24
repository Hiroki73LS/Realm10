import SwiftUI
import RealmSwift
struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }
    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }
}
struct ContentView: View {
    @ObservedObject var profile = UserProfile()
    @ObservedObject var model = viewModel()
    @State private var idDetail = ""
    @State private var taskDetail = ""
    @State private var task2Detail = ""
    @State private var task3Detail = ""
    @State private var pickname1Detail = ""
    @State private var pickname2Detail = ""
    @State private var pickname3Detail = ""
    @State private var dateDetail = Date()
    @State private var isONDetail = false
    @State private var pick1Detail = 0
    @State private var toSave = false
    @State private var alert = false
    @State private var alert1 = false
    @State private var isShown: Bool = false
    @State private var isShown2: Bool = false
    @State private var showingAlert = false
    @State private var showAlert = false
    var dateFormat: DateFormatter {
        let dformat = DateFormatter()
        dformat.dateFormat = "yyyy/M/d h:mm"
        return dformat
    }
    
    let backGroundColor = LinearGradient(gradient: Gradient(colors: [Color.white, Color.green]), startPoint: .top, endPoint: .bottom)
    
    init() {
            UITableView.appearance().backgroundColor = .clear
            UITableViewCell.appearance().backgroundColor = .clear
        }
    
    var body: some View {
        NavigationView {
        ZStack{
            backGroundColor.edgesIgnoringSafeArea(.all)
            VStack{
                    List{
                        ForEach(model.cellModels, id: \.id) {
                                cellModel in
                            Button(action: {
                                idDetail = cellModel.id
                                taskDetail = cellModel.task
                                task2Detail = cellModel.task2
                                task3Detail = cellModel.task3
                                pick1Detail = cellModel.pick1
                                pickname1Detail = profile.username
                                pickname2Detail = profile.username2
                                pickname3Detail = profile.username3
                                isONDetail = cellModel.isON
                                dateDetail = cellModel.date
                                self.showAlert = true
                                            }, label: {
                                                
                            NavigationLink(destination: EditView(task: $taskDetail, task2: $task2Detail, task3: $task3Detail, date: $dateDetail, isON: $isONDetail, pick1: $pick1Detail), isActive: $showAlert) {
                                    HStack{
                                        VStack(alignment:.leading) {
                                                Text(cellModel.task)
                                                .font(.title)
                                                Spacer()
                                            VStack{
                                                HStack{
                                                    Text(cellModel.task2)
                                                        .foregroundColor(Color.gray)
                                                    Spacer()
                                                }
                                                HStack{
                                                    Text(cellModel.task3)
                                                    .foregroundColor(Color.gray)
                                                    Spacer()
                                                    Text(dateFormat.string(from: cellModel.date))
                                                }
                                            }
                                            .padding(0.0)
                                        }
                                        if cellModel.isON == true {
                                            Image(systemName: "heart.circle.fill")
                                                .foregroundColor(.pink)
                                                .onTapGesture {
                                                    try? Realm().write {
//                                                        cellModel.isON = false
                                                    }}
                                        } else {
                                            Image(systemName: "heart.circle.fill")
                                                .foregroundColor(.secondary)
                                                .onTapGesture {
                                                    try? Realm().write {
//                                                        cellModel.isON = true
                                                    }}
                                        }
                                    }
                            }.listRowBackground(Color.clear)
                            }).background(Color.clear)
                        }
                        .onDelete { indexSet in
                            let realm = try? Realm()
                            let index = indexSet.first
                            let target = realm?.objects(Model.self).filter("id = %@", self.model.cellModels[index!].id).first
                                print(target!)
                                try? realm?.write {
                                realm?.delete(target!)
                                                }
                                            }
                        .listRowBackground(Color.clear)
                     }
            }
            .background(NavigationConfigurator { nc in
             nc.navigationBar.barTintColor = #colorLiteral(red: 0.9033463001, green: 0.9756388068, blue: 0.9194290638, alpha: 1)
             nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
            })
            }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading:
            Button(action: {
                    self.isShown2 = true
            }) {
           Image(systemName: "gearshape")
            .padding()
            .background(Color.clear)
            } .sheet(isPresented: self.$isShown2) {
                //モーダル遷移した後に表示するビュー
                Setting()
            },
            trailing:
            HStack {
                Button(action: {
                    self.isShown = true
                }) {
                    Image(systemName: "square.and.pencil")
                        .padding()
                        .background(Color.clear)
                } .sheet(isPresented: self.$isShown) {
                    //モーダル遷移した後に表示するビュー
                    EnterView()
                }
            })
        }
}}

func rowRemove(offsets: IndexSet) {
    let ttt = "AAA"
    let realm = try! Realm()            // ① realmインスタンスの生成
    let targetEmployee = realm.objects(Model.self).filter("task == %@", ttt)  // ② 削除したいデータを検索する
    
    print(targetEmployee)
    do{                                 // ③ 部署を更新する
      try realm.write{
        realm.delete(targetEmployee)
      }
    }catch {
      print("Error \(error)")
    }
            }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
