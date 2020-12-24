import SwiftUI
import RealmSwift


class Model: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var task = ""
    @objc dynamic var task2 = ""
    @objc dynamic var task3 = ""
    @objc dynamic var pick1 = 0
    @objc dynamic var isON = false
    @objc dynamic var date = Date()
}

struct ContentViewCellModel {
    let id: String
    let task: String
    let task2: String
    let task3: String
    let pick1: Int
    var isON: Bool
    let date: Date
}

class viewModel: ObservableObject {
    
    private var token: NotificationToken?
    private var myModelResults = try? Realm().objects(Model.self)
    @Published var cellModels: [ContentViewCellModel] = []

    init() {
        token = myModelResults?.observe { [weak self] _ in
            self?.cellModels = self?.myModelResults?.map { ContentViewCellModel(id: $0.id, task: $0.task, task2: $0.task2, task3: $0.task3, pick1: $0.pick1, isON: $0.isON, date: $0.date) } ?? []
        }
            }

    deinit {
        token?.invalidate()
    }
}
    
struct EnterView: View {
    
    @ObservedObject var profile = UserProfile()
    @ObservedObject var model = viewModel()
    @State private var task = ""
    @State private var task2 = ""
    @State private var task3 = ""
    @State private var date = Date()
    @State private var isON = false
    @State private var pick1 = 0
    @State private var toSave = false
    @State private var alert = false
    @State private var alert1 = false
    @Environment(\.presentationMode) var presentationMode
    
    @State private var sentakusi = ["練習・課題","出欠席","その他"]

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
            Form {
                Section(header: Text("Title & Doの入力")) {
                    TextField("[名前,タイトル]を入力してください", text: $task)
                    TextField("[内容,Do]を入力してください", text: $task2)
                    DatePicker(selection: $date, displayedComponents: .date,label: {Text("登録日時")} )
                    HStack {
                        Text("お気に入り")
                        Toggle(isOn: $isON) {
                        EmptyView()
                        }
                    }
                }
                Section(header: Text("カスタムタイプを選択")) {
                    
                    //-Picker--------------------------
                    Picker(selection: $pick1,
                           label: Text("")) {
                        Text("\(profile.username)").tag(0)
                        Text("\(profile.username2)").tag(1)
                        Text("\(profile.username3)").tag(2)
                    }.pickerStyle(SegmentedPickerStyle())
                    //-Picker--------------------------
                    
                }
                Section{
                    HStack{
                        Spacer()
                        Button(action: {
                            if self.task == "" {
                                self.alert = false
                                self.alert1.toggle()
                            }else{
                                self.alert1.toggle()
                                self.toSave = true
                //-書き込み--------------------------
                                let models = Realm9.Model()
                                models.task = task
                                models.task2 = task2
                                models.task3 = sentakusi[pick1]
                                models.pick1 = pick1
                                models.isON = isON
                                models.date = date
                                let realm = try? Realm()
                                try? realm?.write {
                                     realm?.add(models)
                                let Results = realm?.objects(Model.self).sorted(byKeyPath: "date", ascending: true)
                                    realm?.add(Results!)
                                }
                //-書き込み--------------------------
                                self.alert = true
                                }
                        }){
                    Text("確定")
                        }
                        .padding()
                        .alert(isPresented: $alert1) {
                            switch(alert) {
                                case false:
                                 return
                                    Alert(title: Text("注意"),
                                     message: Text("[名前,タイトル]を入力してください"),
                                     dismissButton: .default(Text("OK")))
                                case true:
                                 return
                                    Alert(title: Text("確認"),
                                          message: Text("\(task)さんの内容を登録しました。"),
                                    dismissButton: .default(Text("OK"),
                                    action: {
                                        task = ""
                                        task2 = ""
                                        task3 = ""
                                        isON = false
                                        self.presentationMode.wrappedValue.dismiss()
                                    }))
                             }
                        }
                    Spacer()
            }
        }
            }.navigationBarTitle("Enter The Info")
            }}
    }
    }


struct EnterView_Previews: PreviewProvider {
    static var previews: some View {
        EnterView()
    }
}
