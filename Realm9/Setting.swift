import SwiftUI

struct Setting: View {
    @ObservedObject var profile = UserProfile()
    
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
                Section(header: Text("UserDetting")) {
                    TextField("選択肢1", text: $profile.username)
                    TextField("選択肢2", text: $profile.username2)
                    TextField("選択肢3", text: $profile.username3)
                    Stepper(value: $profile.level, in: 1...10) {
                        Text("Level : \(profile.level)")
                    }
                }
            }
            .navigationTitle("Setting")
            }} .background(NavigationConfigurator { nc in
                nc.navigationBar.barTintColor = #colorLiteral(red: 0.9033463001, green: 0.9756388068, blue: 0.9194290638, alpha: 1)
                nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
               })
    }
    }


class UserProfile: ObservableObject {
    /// 選択肢１
    @Published var username: String {
        didSet {
            UserDefaults.standard.set(username, forKey: "username")
        }
    }
    
    /// 選択肢２
    @Published var username2: String {
        didSet {
            UserDefaults.standard.set(username2, forKey: "username2")
        }
    }

    /// 選択肢３
    @Published var username3: String {
        didSet {
            UserDefaults.standard.set(username3, forKey: "username3")
        }
    }

    /// レベル
    @Published var level: Int {
        didSet {
            UserDefaults.standard.set(level, forKey: "level")
        }
    }
    
    /// 初期化処理
    init() {
        username = UserDefaults.standard.string(forKey: "username") ?? ""
        username2 = UserDefaults.standard.string(forKey: "username2") ?? ""
        username3 = UserDefaults.standard.string(forKey: "username3") ?? ""
        level = UserDefaults.standard.object(forKey: "level") as? Int ?? 1
    }
}

struct Setting_Previews: PreviewProvider {
    static var previews: some View {
        Setting()
    }
}
