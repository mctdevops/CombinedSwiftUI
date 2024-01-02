import Combine
import SwiftUI
import PlaygroundSupport

// Class Person
final class Person {
    
    // Variables that will be notified every time they changes
    var name: String = ""
    var surname: String = ""
    
    init(name: String, surname: String) {
        self.name = name
        self.surname = surname
    }
}

final class PeopleViewModel: ObservableObject {
    
    @Published var people = [Person]()
    var subscriptions = Set<AnyCancellable>()
    
    init(){
        $people
            .sink (receiveValue: {
                guard let last = $0.last else {return}
                print("Last recieved: \(String(describing: last.name)) \(String(describing: last.surname))")
            })
            .store(in: &subscriptions)
    }
    
}

struct ContentView: View {
    
    // Variables
    @ObservedObject var peopleModel: PeopleViewModel = PeopleViewModel()
    @State var name: String = ""
    @State var surname: String = ""
    
    
    // View body
    var body: some View {
        VStack(alignment: .center, spacing: 25){
            Text("Hello, enter a contact")
                .padding(.bottom, 50)
            HStack(alignment: .center, spacing: 2){
                VStack{
                    Text("New name: ")
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 30)
                VStack{
                    TextField("Name", text: $name)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                
            }
            HStack(alignment: .center, spacing: 2){
                VStack{
                    Text("New surname: ")
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 30)
                VStack{
                    TextField("Surname", text: $surname)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
            }
            // Triggers the publisher
            Button(action: {
                self.peopleModel.people.append(Person(name: self.name, surname: self.surname))
            }) {
                Text("Update")
            }
            // Once this button is pressed, publisher won't work anymore
            Button(action: {
                self.peopleModel.subscriptions.removeAll()
            }) {
                Text("Cancel subscriptions")
            }
        }
    }
}

// To display the view in playground
PlaygroundPage.current.setLiveView(ContentView())
