//
//  AddTodoListView.swift
//  HaruSijak
//
//  Created by 신나라 on 6/2/24.
//

import SwiftUI

struct AddTodoListView: View {
    
    @FocusState var isTextFieldFocused: Bool
    @State var todo: String = ""
    @State var startdate: Date = Date()
    @State var enddate: Date = Date()
    @State var status: Int = 0
    
    // alert 관련 property
    @State var alertTitle: String = ""          // 확인 alert창 제목
    @State var alertMessage: String = ""        // 확인 alert창 메세지
    @State var alertButton: String = ""         // 확인 alert창 버튼
    @State var alertOpen: Bool = false          // 확인 alert창 bool
    
    @State var result: Bool = true              // addaction 결과값
    @Environment(\.dismiss) var dismiss         // 창 사라지게
    
    var viewModel = TodoListDB() // VM instance
    
    
    var body: some View {
        VStack(content: {

            //할 일 Text
            Text("할 일 :")
                .bold()
                .padding(.trailing, 170)
            
            // 할일 TextField
            TextField("", text : $todo)
                .padding()
                .frame(width: 250)
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.leading)
                .keyboardType(.default)
                .focused($isTextFieldFocused)
                .padding(.bottom, 60)
            
            // 시작일 달력
            HStack {
                Spacer()
                showDatePicker("시작일", variable: $startdate)
                Spacer()
            } // HStack
            .padding(.bottom, 10)
            
            // 종료일 달력
            HStack {
                Spacer()
                showDatePicker("종료일", variable: $enddate)
                Spacer()
            } // HStack
            .padding(.bottom, 60)
            
            
            // 버튼
            Button("추가하기", action: {
                alertOpen.toggle()
                isTextFieldFocused = false
                
                if todo.isEmpty{
                    showAlert(title: "경고", message: "데이터를 입력하세요.", button: "확인")
                } else {
                    self.result = viewModel.insertDB(todo: todo, startdate: startdate, enddate: enddate, status: 0)
                    
                    if self.result {
                        showAlert(title: "알림", message: "추가되었습니다.", button: "확인")
                    } else {
                        showAlert(title: "알림", message: "추가에 실패했습니다.", button: "확인")
                    }
                    
                    alertOpen = true
                }
                // 초기화
                self.todo = ""
                startdate = Date.now
                enddate = Date.now
            }) //Button
            .tint(.white)
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            .background(Color("myColor"))
            .cornerRadius(30)
            .controlSize(.large)
            .frame(width: 200, height: 50) // 버튼의 크기 조정
            .alert(isPresented: $alertOpen, content: {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text(alertButton), action: {
                        alertOpen = false
                    })
                )
            })//alert
            
        })// Vstack
        .navigationTitle("할 일 추가")
        .navigationBarTitleDisplayMode(.large)
        
    } // body
    
    // alert창 실행 함수
    func showAlert(title: String, message: String, button: String) {
        alertTitle = title
        alertMessage = message
        alertButton = button
        alertOpen = true
        dismiss()
    }
}

#Preview {
    AddTodoListView()
}
