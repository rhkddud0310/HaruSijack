// MARK: -- Description
/*
    Description : 캘린더 문제해결
    Author : Forrest DongGeun Park. (PDG)
    Generate Date :   2024.6.11
    Updates :
     * 2024.06. by Forrest DonGeun Park :
            -
    Details : -
*/



import SwiftUI

struct ContentView: View {
    var body: some View {
        
        // MARK: PROPERTIES
        @State var date : Date = Date()
        @Binding var currentDate : Date
        
        let days : [String] = ["일","월","화","수", "목","금","토"]
        
        VStack(content: {
            Text("Placeholder")
            HStack(content: {
                
            })
        })
    }
    //MARK: Functions
    func extractDateInformation() -> [String]{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYY MM"
        let date = formatter.string(from: currentDate)
        return date.components(separatedBy: " ")
    }
    
}// View

#Preview {
    ContentView()
}
