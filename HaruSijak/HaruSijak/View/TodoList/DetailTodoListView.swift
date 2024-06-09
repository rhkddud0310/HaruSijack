//
//  DetailTodoListView.swift
//  HaruSijak
//
//  Created by 신나라 on 6/2/24.
//

import SwiftUI

struct DetailTodoListView: View {
    
    
    @FocusState var isTextFieldFocused: Bool
    @State var todoList: TodoLists
//    @State var todo: String = ""
//    @State var startdate: Date = Date()
//    @State var enddate: Date = Date()
//    @State var status: Int = 0
//    @State var id: Int = 0
    
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
            TextField("", text : $todoList.todo)
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
                showDatePicker("시작일", variable: $todoList.startdate)
                Spacer()
            } // HStack
            .padding(.bottom, 10)
            
            // 종료일 달력
            HStack {
                Spacer()
                showDatePicker("종료일", variable: $todoList.enddate)
                Spacer()
            } // HStack
            .padding(.bottom, 60)
            
            
            // 버튼
            HStack {
                
                Button("수정하기", action: {
                    alertOpen.toggle()
                    isTextFieldFocused = false
                    
                    if todoList.todo.isEmpty{
                        showAlert(title: "경고", message: "데이터를 입력하세요.", button: "확인")
                    } else {
                        
                        
                        self.result = viewModel.updateDB(todo: todoList.todo, startdate: todoList.startdate, enddate: todoList.enddate, id: Int32(todoList.id))
                            isTextFieldFocused = false
                        
                        self.result
                            ? showAlert(title: "알림", message: "수정되었습니다.", button: "확인")
                            : (showAlert(title: "알림", message: "수정에 실패했습니다.", button: "확인"))
                        
                        alertOpen = true
                    }
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
                
                
                Button("삭제하기", action: {
                    alertOpen.toggle()
                    isTextFieldFocused = false
                    
                    if todoList.todo.isEmpty{
                        showAlert(title: "경고", message: "데이터를 입력하세요.", button: "확인")
                    } else {
                        
                        
                        self.result = viewModel.deleteDB(id: Int32(todoList.id))
                            isTextFieldFocused = false
                        
                        self.result
                            ? showAlert(title: "알림", message: "삭제되었습니다.", button: "확인")
                            : (showAlert(title: "알림", message: "삭제에 실패했습니다.", button: "확인"))
                        
                        
                        alertOpen = true
                    }
                }) //Button
                .tint(.white)
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .background(Color.pink)
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
                
                
            }//HStack
            
            
            
        })// Vstack
        .navigationTitle("할 일 수정")
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.large)
        
    } // body
    
    // alert창 실행 함수
    func showAlert(title: String, message: String, button: String) {
        alertTitle = "알리"
        alertMessage = message
        alertButton = "확인"
        alertOpen = true
        dismiss()
    }
}

#Preview {
    DetailTodoListView(todoList: TodoLists(id: 001, todo: "밥먹기", status: 0))
}
