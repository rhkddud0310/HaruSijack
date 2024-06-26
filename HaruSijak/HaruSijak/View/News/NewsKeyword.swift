
// MARK: -- Description
/*
    Description :  하루시작 뉴스 키워드 설정 페이지
    Date : 2024. 06. 26
    Author : Zen , pdg
    Detail :
    Updates :
        2024.06.26 by pdg, zen
            * 사용자 관심 키워드 버튼을 누르면 관심 단어 선택
            * 일단 세가지 키워드 정해서 서버에서 자연어처리 가능하도록 함.
        
 */
import SwiftUI

struct NewsKeyword: View {
    var  keyword1 : String = "자동차"
    var  keyword2 : String = "반도체"
    var  keyword3 : String = "IT"
    var body: some View {
        Text("\(keyword1)")
        Text("\(keyword2)")
        Text("\(keyword3)")
    }
}
#Preview {
    NewsKeyword()
}
