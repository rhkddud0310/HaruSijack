// MARK: -- Description
/*
    Description : test 페이지 Flask 응답 용 및 스위프트 Review 용 페이지
    Author : Forrest DongGeun Park. (PDG)
    Generate Date :   2024.6.10
    Updates :
     * 2024.05. by Forrest DonGeun Park :
            - Flask 에서 무언가를 받아서 alert 를 뿌려 주는 기능을 실현해본다.
 
    Details : -
*/

import SwiftUI


struct test2_pdg: View {
    //MARK: --- Properties
    @FocusState var isTextFieldFocused : Bool

    //MARK: --- Body
    var body: some View {
        Test(Apptitle: "Hello World")
        .padding()
    }// body
    // Functions
    // delete items
    func deleteItem(at offsets: IndexSet ){
        //animalList.remove(atOffsets: offsets)
    }
}//CV
//MARK: -- View Structs

// MARK: -- TEST
struct Test : View{
    var Apptitle : String = ""
    var body: some View{
        VStack( content:{
                        Text(" \(Apptitle)")
                            .bold()
                            .onAppear(perform: {test()})
                    })// VStack
    }
    func test(){
        print("-- App Start--")
    }
}

//MARK: Alert
struct BasicAlert : View{
    /*  Function : Basic Alert
        Author  : Forrest Park
        Update  :2024.0610 by pdg :
            *  Alert
     */
    @State var isAlert = false
    var body: some View{
        Button("Alert", action:{
            isAlert = true
        })//B
        // Alert Action
        .alert("title", isPresented: $isAlert, actions: {
            Button("Action Default",role: .none, action: {
                //print("Action Default")
            })
            Button("Action dstructive", role: .destructive, action: {
                //print("Action destructive")
            })
            Button("Action Cancel", role: .cancel , action:{
                //print(" Cancel")
            })
        },
        message: {
            Text("Message")
        })
    }
}

//MARK: ActionSheet
struct BasicActionSheet : View{
    @State var isActionSheet = false
    var body: some View{
        Button("ActionSheet", action:{
            isActionSheet = true
        })
        .confirmationDialog("Title", isPresented: $isActionSheet, titleVisibility: .visible, actions: {
            Button("Action Default",role: .none, action: {
                //print("Action Default")
            })
            Button("Action dstructive", role: .destructive, action: {
                //print("Action destructive")
            })
            Button("Action Cancel", role: .cancel , action:{
                //print(" Cancel")
            })
        }, message: {
            Text("Message")
        })
    }
}

//MARK: date picker
struct BasicDatePicker : View{
    // Properties
    @State var currentDate = Date()
    let timer = Timer.publish( every: 1, on: .main, in: .default).autoconnect()
    var dateFormatter: DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd EEE HH:mm:ss"
        return formatter
    }
    // Date picker variables
    //@State var selectDate = Date()
    @State var selectDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
    var body: some View{
        VStack( content:{
                //bgColor.ignoresSafeArea()
            Text("현재시간 : \(currentDate, formatter: dateFormatter)")
                .onReceive(timer, perform: { input in
                    currentDate = input
                })

            DatePicker("", selection: $selectDate, in: Date()..., displayedComponents: [.date,.hourAndMinute ]   )
                .labelsHidden()
                .datePickerStyle(.wheel)
                .padding()
            Text("선택시간 : \(selectDate, formatter: dateFormatter)")
        })// VStack
        .padding() // safe area setting
    }
}
// Picker
struct BasicPicker: View{
    @State var selectedHeight : Int = 0
    @State var start : Int = 100
    @State var end : Int = 100
    
    var body: some View{
        Picker("", selection: $selectedHeight, content: {
            ForEach(start...end, id:\.self, content: { index in
                Text("\(index)")
                
            }) //F
        })// P
        .labelsHidden()
        .pickerStyle(.wheel)
        .onAppear(perform: {
            selectedHeight = end-start/2
        })
        .padding()
    }// body
}

//MARK: -- Toggle
struct BasicToggle: View{
    @State var toggleStatus : Bool = false
    var action: () -> Void // 클로저 타입의 프로퍼티 추가
    var body: some View{
        Toggle("", isOn: $toggleStatus)
            .labelsHidden()
            .padding(.trailing , 10)
            // 바뀌었을 때 함수를 실행해 주는 기능 -> onchange
            .onChange(of: toggleStatus, action)
    }
}

//MARK: -- Button
struct BasicButton: View{
    var btnTitle : String = "Button"
    var action: () -> Void // 클로저 타입의 프로퍼티 추가
    var width : CGFloat = 120
    var height : CGFloat = 50
    var foreColor : Color = .white
    var bgColor : Color  = .blue
    
    var body: some View{
        Button(btnTitle, action: action)
        .bold()
        .frame(width: width, height: height)
        .background(bgColor)
        .foregroundColor(foreColor)
        .clipShape(.buttonBorder)
        .padding()
    }
}
// MARK: -- Text
struct BasicText :View{
    var textStr : String
    var fontSize : CGFloat = 20.0
    var isBold : Bool = false
    var textPadding : CGFloat = 0
    var body: some View{
        Text(textStr)
            .bold(isBold)
            .frame(minWidth: 80, alignment: .leading)
            .font(.system(size: fontSize))
            .padding(textPadding)
    }
}
// MARK: -- TextEditor
struct BasicTextEditor :View{
    @State var enteredText : String = ""
    var body: some View{
        TextEditor(text: $enteredText)
            .frame(minWidth: 0,
                   maxWidth: .infinity,
                   minHeight: 0,
                   maxHeight: .infinity)
            .foregroundStyle(.black).bold()
            .colorMultiply(.gray.opacity(0.3))
            .clipShape(.rect(cornerRadius: 15))
    }
}
// MARK: -- textfield
struct BasicTextField : View{
    var isDisabled : Bool
    var tfPlaceHolder = ""
    @State var text : String
    @FocusState var isTextfieldFocused :Bool
    var multilineTextAlignment: TextAlignment
    var keyboardType: UIKeyboardType
    var body: some View{
        TextField(tfPlaceHolder, text: $text)
            .frame(width: 120)
            .textFieldStyle(.roundedBorder)
            .disabled(isDisabled)
            .multilineTextAlignment(multilineTextAlignment)
            .keyboardType(keyboardType)
            .focused($isTextfieldFocused)
    }
}
// MARK:  Basic Image setting view
struct BasicImage : View{
    /* Description:
        기본 그림 세팅
        */
    var iamgeTitle : String
    var imageWidth : CGFloat = 50
    var imageHeight : CGFloat = 50
    var cornerRadius : CGFloat = 5
    var body: some View{
        Image(iamgeTitle)
            .resizable()
            .frame(width: imageWidth, height: imageHeight)
            .fixedSize()
            .padding(10)
            //.clipShape(.rect(cornerRadius: 20))
            .scaledToFit()
            .cornerRadius(cornerRadius)
              /* Move
            .offset(x: 100, y: -175 )
            .overlay(content: {
                RoundedRectangle(cornerRadius: 10.0)
                      .stroke(.red, lineWidth: 5)
                      .offset(x:100, y:-175)
                    })
             */
    }
}
// MARK: table iamge row
struct TableImageTitleRow : View{
    var imagesize : CGFloat = 50.0
    var imageCorner : CGFloat = 5.0
    var tableCellImage : String
    var TableCellText : String
    var body: some View{
        HStack(content: {
            Image(tableCellImage)
                .resizable()
                .frame(width: imagesize, height: imagesize)
                .scaledToFit()
                .cornerRadius(imageCorner)
            Text(TableCellText)
                .bold()
        })
    }
}

#Preview {
    test2_pdg()
}
