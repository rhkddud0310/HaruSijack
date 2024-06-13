"""
---
## 📌 Project : 하루시작 프로젝트 Module functions  📌🔸🟦✅🆕🉐
## 📌 Description : 
    🔸  Data 정제를 위한 Fuction module
    🔸 백앤드 서비스를 위한 데이터 변환 및 머신러닝 서비스 function 
## 📌 Author : Forrest Dpark (분석 담당)
## 📌 Date : 2024.05.31 ~
## 📌 Detail : 
    🔸 모듈 사용 방법 : 
        1. [ directory 가 다를때 Server 에서 사용법 ]--
            #> from Functions  import Service   # module importing 
            #> Service.dataInfoProcessing(df)  # Data information 정보 출력 
            #> Service.plotSetting()           # OS 한글화 한 Matplotlib 
        2.[ directory 가 다를때 Server.py 에서 사용법 ]--
            #> import sys,os 
            #> parent_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
            #> sys.path.append(parent_dir)
            #> from Module.Functions import Service
        3. [ directory 갇 다를 때 Jupyter 에서 사용 법 ]
            #> import sys,os 
            #> parent_dir = os.path.dirname(os.getcwd())
            #> sys.path.append(parent_dir)
            #> from Module.Functions import Service
## 📌 Update:  
    🟦 2024.06.02 by pdg : multiprocessing import 
        ✅ Data frame column 정보 ( Null check, 중복체크 )플랏 
    🟦 2024.06.03 by pdg : datdaInfoProcessing 함수 생성
        ✅ DataInfoProcessing 함수의 printoutcolnumber 플랏할 칼럼 갯수를 선택할수있게 설정함. 
    🟦 2024.06.05 by pdg : 기타 함수 생성 
        ✅ plotSetting 함수 추가 
        ✅ reorder_columns 함수 추가 -> 칼럼의 순서를 바꾸어줌.
        ✅ currentPassengerCalc 함수 추가 현재 탑승객 및 량당 빈자리 추출(노인석 제외)
        ✅ stationDispatchBarplot 함수 추가 -> 지하철 역별 배차 지하철 수치 barplot check 
        ✅ dayToIntConvert  함수 추가
        ✅ date_Divid_Add_YMW_cols 함수추가 
        ✅ holidaysToIntConvert 함수 추가 
    🟦 2024.06.07 by pdg : validation 을 위한 데이터 시각화 함수 
        ✅ station_name_to_code 함수 추가
        ✅ sdtation_inout_lmplot 함수 추가
    🟦 2024.06.09 by pdg :  지하철 역명 처리 및 코드 중복처리 문제로 데이터 누락되는 이슈 해결 
        ✅ subway_info_table 함수추가 
        ✅ 함수 순서 바꿈, 주석 추가
        ✅ 호선당서비스불가역이름추출 함수 추가
        
        %%% 각 함수별로 어떤 주피터에서 작성되었는지 분류나눌것
        
    🟦 2024.06.10 by pdg : KNN regression model 저장 
        ✅ 함수 저장 하도록 바꿈
    🟦 2024.06.12 by pdg : 함수 정리 및 주석 정리 
    🟦 2024.06.13 by pdg : 
        ✅ color text 함수 추가
        ✅ subwayInfo 함수 수정 
        
    

---
"""
## project data processing functions 
# print(Service.colored_text(,'yellow'))
from multiprocessing import Process
import matplotlib.pyplot as plt, seaborn as sns
class Service:
    def __init__(self) -> None:
        pass
##### 기본 Setting 함수
    def colored_text(text, color='default'):
        '''
        #### 예시 사용법
        print(colored_text('저장 하지 않습니다.', 'red'))
        print(colored_text('저장 합니다.', 'green'))
        default,red,green,yellow,blue, magenta, cyan, white, rest
        '''
        colors = {
            'default': '\033[99m',
            'red': '\033[91m',
            'green': '\033[92m',
            'yellow': '\033[93m',
            'blue': '\033[94m',
            'magenta': '\033[95m', #보라색
            'cyan': '\033[96m',
            'white': '\033[97m',
            'bright_black': '\033[90m',  # 밝은 검정색 (회색)
            'bright_red': '\033[91m',  # 밝은 빨간색
            'bright_green': '\033[92m',  # 밝은 초록색
            'bright_yellow': '\033[93m',  # 밝은 노란색
            'bright_blue': '\033[94m',  # 밝은 파란색
            'bright_magenta': '\033[95m',  # 밝은 보라색
            'bright_cyan': '\033[96m',  # 밝은 청록색
            'bright_white': '\033[97m',  # 밝은 흰색
            'reset': '\033[0m'
        }
        
        color_code = colors.get(color, colors['default'])
        return f'{color_code}{text}{colors["reset"]}'        
    def plotSetting(pltStyle="seaborn-v0_8"):
        '''
        # Fucntion Description : Plot 한글화 Setting
        # Date : 2024.06.05
        # Author : Forrest D Park 
        # update : 
        '''
        # graph style seaborn
        import matplotlib.pyplot as plt # visiulization
        import platform
        from matplotlib import font_manager, rc # rc : 폰트 변경 모듈font_manager : 폰트 관리 모듈
        plt.style.use(pltStyle)
        plt.rcParams['axes.unicode_minus'] = False# unicode 설정
        if platform.system() == 'Darwin': rc('font', family='AppleGothic') # os가 macos
        elif platform.system() == 'Windows': # os가 windows
            path = 'c:/Windows/Fonts/malgun.ttf' 
            font_name = font_manager.FontProperties(fname=path).get_name()
            rc('font', family=font_name)
        else:
            print("Unknown System")
        print(Service.colored_text("___## OS platform 한글 세팅완료 ## ___",'magenta'))
##### Index findeing
    def indexFind(colnamelist, search_target_word):
        import numpy as np
        # 해당 단어가 존재하는 칼럼의 이름이있는 칼럼의 indx를 출력합니다. 
        indices = np.where([search_target_word in col for col in colnamelist])[0]
        return indices
####  데이터 체크및 정제 관련 함수들 
    def dataInfoProcessing(df, replace_Nan=False, PrintOutColnumber = 6,nanFillValue=0):
        ''' 
        📌 Fucntion Description :  Data frame 의 정제해야할 부분을 체크해주는 함수 
        📌 Date : 2024.06.02 
        📌 Author : Forrest D Park 
        📌 update : 
            🟦 2024.06.02 by pdg: 일별 데이터 정제 
                ✅ 데이터에 null 이 있음을 발견, data 정제 함수 update 
                ✅ 함수에서 replace_Nan 아규 멘트 받아서 true 일경우 nan 을 0 으로 대체 하게 만듬. 
            🟦 2024.06.04 by pdg : 함수변경
                ✅ 관심 칼럼이 많을때 칼럼 개수를 조정할수있게 함. 
        '''
        print("--"*110)
        print(Service.colored_text(f" <<< dataInfoProcessing. >>>",'yellow'))
        print(Service.colored_text(f"  1️⃣ Data row/colum numbers : {len(df.index)}/{len(df.columns)}",'red'))
        #print(subway.columns)
        #print(subway.info())
        null_message =f"총 {df.isnull().sum().sum()}개의 null 이 있습니다!" if df.isnull().sum().sum() else "Null 없는 clean data!"
        print(Service.colored_text(f"  2️⃣ null ceck 결과{null_message}",'red'))
        ### Null 이 있는 칼럼 추출
        haveNullColumn =[]
        for idx, col in enumerate(df.columns):
            if df[f"{col}"].isnull().sum():
                print(f"   => {idx}번째.[{col}]컬럼 : ",f"null {df[f'{col}'].isnull().sum()} 개,\t not null {df[f'{col}'].notnull().sum()} 개")
                ## Null data fill
        if replace_Nan : ## nan 을 0 으로 대체 
            df[col].fillna(value=nanFillValue, inplace=True)  
            
        
        print(Service.colored_text("  3️⃣ Column  Information (중복체크)",'red'))
        print( "\tidx.columName |\t\t\t\t |Colum Info(dtype)|** ")
        print( "\t","--"*len("columIdx |\t\t\t\t **|Col(dtype)|** "))
        for idx, col in enumerate(df.dtypes.keys()):
            if idx< PrintOutColnumber:
                if len(f"\t{idx}.[{col}({df.dtypes[col]})]:")<20:
                    print(f"\t{idx}.[{col}({df.dtypes[col]})]:",\
                        f"{len(df[col].unique())}/{len(df[col])} [uniq/raw]", sep=" \t\t\t")
                else:
                        print(f"\t{idx}.[{col}({df.dtypes[col]})]:",\
                        f"{len(df[col].unique())}/{len(df[col])} [uniq/raw]", sep=" \t\t")

        else: 
            print(f"\t ...etc (추가로 {len(df.dtypes.keys())-PrintOutColnumber}개의 칼럼이 있습니다 )")
        return df
    def reorder_columns(df, col_name, target_idx):
        """
        📌 Description : Reorder columns in a DataFrame by moving a specific column to a target index.
        📌 Date : 2024.06.05
        📌 Author : Forrest Dpark
        # Detail:
            * df (pandas.DataFrame): The input DataFrame.
            * col_name (str): The name of the column to be moved.
            * target_idx (int): The target index where the column should be placed.
            * Returns: pandas.DataFrame: The DataFrame with the column reordered.
        """
        print(Service.colored_text(f'{col_name}을 {target_idx}로 이동함','yellow'))
        cols = list(df.columns)
        current_idx = cols.index(col_name)
        cols.pop(current_idx)
        cols.insert(target_idx, col_name)
        # print("--"*110)
        return df[cols]

#### 지하철 역사 정보 정제 후 저장
    def  subway_info_table(subway, save=False,saveFileName=""):
        import pandas as pd, numpy as np
        """
        📌 Description :  승하차 인원 데이터에서 각 역에대한 정보 ( 역사코드 호선 등)를 추출한 테이블을 반환
        📌 Date : 2024.06.13
        📌 Author : Forrest Dpark
        📌 Detail:
            🔸 Returns: 
        📌 Updates : 
            2024.06.13 by pdg : 프린트에 색깔입힘. 
            
        """
        print(Service.colored_text(
        """\n 🔸🔸🔸지하철 역정보 테이블 함수 실행🔸🔸🔸 """,'magenta'))
           
        print("  |- 첫 수송일자 :",list(subway['수송일자'])[0])
        print("  |- 마지막 수송일자 :",list(subway['수송일자'])[-1])
        ## 역명에서 () 빼버리기 
        정제된역명 = [i.split("(")[0] for i in subway['역이름']]
        subway['역이름']= 정제된역명
        
        # if subway.reorder_columns 
        
        subway_test = subway.rename({'고유역번호(외부역코드)':'역사코드'},axis=1)
        ### 역코드 obj -> int 로 변환  ** 아무것도 없는 데이터는 000 으로 변환 
        new_stationCode = []
        issued_index =[]
        for i, code in enumerate(subway_test['역사코드']):
            # print(str(i).replace(" ",""))
            try : 
                new_stationCode.append(int(str(code)))
            except ValueError : 
                print(f"{i}번째 데이터 {code}" ,"<-value errer: ")
                new_stationCode.append(000)
                issued_index.append(i)
                continue
        print(f"{issued_index}는 값에러 0 으로 대체함" if len(new_stationCode)== len(subway_test) else "대체 안됨")
        #0,광명사거리,7,1 이 코드가 문제됨..
        subway_test['역사코드'] = new_stationCode
        
        # 역사코드에 해당하는 역이름과 호선을 테이블로 만들고 싶다.
        # 중복 제거 후 역 번호, 역 이름, 호선 정보를 추출
        unique_stations = subway_test.drop_duplicates(subset=['역사코드', '역이름', '호선'])
        #역명 코드가 0 이면 행 drop 
        unique_stations = unique_stations[unique_stations['역사코드'] != 0]
        subway_info =unique_stations[['역사코드', '역이름', '호선']]
        subway_info.reset_index(inplace=True,drop=True)

        ## 환승역 여부 칼럼을 추가한 StationInfo data 만들자 .

        test1 = dict(subway_info['역이름'].value_counts())
        to_merge_df_exchange = pd.DataFrame(
            {
            '역이름':list(test1.keys()),
            '환승역수':list(test1.values())
            }
        )
        merged_table = pd.merge(
            subway_info,to_merge_df_exchange,
            on='역이름'
        )
        to_saveDataframe = merged_table[['역사코드','역이름','호선','환승역수']]
        if save: 
        # to_saveDataframe.to_csv(f"../Data/StationInfo.csv",index=None)

            print(f'\033[92m >>{saveFileName}으로 저장합니다.\033[0m') 
            to_saveDataframe.to_csv(f"../Data/{saveFileName}.csv",index=None)
        else:
            print('\033[91m >>저장 하지 않습니다.\033[0m')

        return to_saveDataframe

#### 지하철 배차표 호선별 테이블 정제 함수 
    def dispatch_table_forML(line_배치, save=False, saveFileName=""):
        """
        #### 📌 Description : 특정 호선에대한 배치표 정보를 받아서 pivotable 로시간대별 칼럼생성후 배차 수를 계산
        #### 📌 Date : 2024.06.09
        #### 📌 Author : Forrest Dpark
        #### 📌 Detail:
            * line_배치 (df)
            * Returns: pivotable for machine learning (df)
        """
        import warnings ; warnings.filterwarnings('ignore')
        # 새로운 테이블 만들기
        line_배치['열차시간계산']=line_배치['열차도착시간'].str.split(':').str[0]
        # '역사명'과 '시간'이 같은 데이터 그룹화
        grouped = line_배치.groupby(['역사코드', '열차시간계산','주중주말','방향'])
        # 각 그룹의 크기(개수) 계산
        count = grouped.size().rename('차량수')
        # 결과를 DataFrame으로 변환
        interval = count.reset_index()
        # return interval['역사코드'].unique()
        # 열 이름 지정
        interval.columns = ['역사코드', '시간', '주중주말','방향','배차수']
        interval['역사코드'] = interval['역사코드'].astype('int64')
        # 역사코드(=),주중주말(=)을 기준으로 방향이 다른 배차수를 합친 후 새로운 로우 생성후 방향 컬럼 삭제한 새로운 데이터 셋 만들기
        # 방향 별로 배차수 합치기
        
        interval = interval.groupby(['역사코드', '시간', '주중주말'])['배차수'].sum().reset_index()
        interval['배차수']=interval['배차수']/2
        
        # 피벗 테이블 생성
        pivot_df = interval.pivot_table(index=['역사코드', '주중주말'], columns='시간', values='배차수', aggfunc='mean')

        # # 인덱스를 열로 리셋
        interval = pivot_df.reset_index()
        # return interval
        # # 첫 번째 인덱스 열을 추가하여 새로운 데이터프레임 생성
        # interval['역사코드2'] = interval['호선']
        # interval.drop(columns=['역사코드2'],inplace=True)
        # interval.index = interval['역사코드']
        interval.fillna(0, inplace=True)
        cols = interval.columns.tolist()
        cols.append(cols.pop(cols.index('00')))
        interval = interval[cols]

        interval.rename(columns={'00': '24'}, inplace=True)
        interval['호선']=line_배치['호선'].unique()[0] 
        interval=Service.reorder_columns(col_name='호선',df=interval,target_idx=1)
        print(Service.colored_text(f" 🔸{line_배치['호선'].unique() }호선 에 대한 배차 테이블 표정제 결과",'green'))
        
        if save: 
            print(Service.colored_text('배차정보를 저장합니다.','red'))
            interval.to_csv(f'../Data/지하철배차시간데이터/{saveFileName}_호선배차.csv',index =None)
        else:
            print(Service.colored_text('배차정보를 저장하지 않습니다','red'))
        return interval
    def table_merge_subwayInfo_dispatch(subwayInfo,line_배치,histPlot = False):
        import pandas as pd 
        print(Service.colored_text('--- 배차시간표 + 역사정보 ---','yellow'))
        print(Service.colored_text(f"{line_배치['호선'].unique() }호선 배차시간표 역사코드 개수 :{len(line_배치['역사코드'].unique())}",'yellow'))
        test_merged_interval= pd.merge(subwayInfo,line_배치, on= ['역사코드','호선'])
        print(Service.colored_text(f"{line_배치['호선'].unique()}호선테이블 병합후 서비스가능한 총 역 개수",'yellow'),len(test_merged_interval['역사코드'].unique()))
        ## 주중 주말  카테고리를 0,1 로 바꾸어줌 주말일경우 1 주중일경우 0  ->onehot encoding 
        test_mi = test_merged_interval.copy()
        # test_mi.rename({'주중주말':'주말'}, axis=1,inplace=True)
        test_mi_week_dummies = pd.get_dummies(test_mi['주중주말'])


        test_mi_week_dummies.head()
        test_ = pd.concat([test_mi,test_mi_week_dummies], axis=1)
        # 주말 칼럼 삭제 , day -> 주중, sat -> 주말 로 변경 
        # test_.drop('주말', axis=1, inplace=True)
        # for idx, col in enumerate(list(test_.columns)):
        #     print(idx, col)
        # 인덱스 2의 값을 인덱스 4로 이동

        test_ =Service.reorder_columns(test_,'SAT',4)
        test_ =Service.reorder_columns(test_,'DAY',5)
        ## 배차시간 칼럼 이름 변경 
        # t1=pd.concat([test_.columns[:8].to_series(),test_.columns[8:].to_series()+'시배차'])
        # test_.columns =t1
        test_.rename(
            {
                'SAT':'주말',
                'DAY':'주중'
            }, axis=1, inplace=True
        )
        print(Service.colored_text('SAT,DAY -> 주말,주중'))
        if histPlot:
            print("예시히스토그램 1개만 플랏합니다(나머지는 저장됨)")
            for i in range(0,len(test_[:2]),2): ## 예시로 2개
                Service.stationDispatchBarplot(test_,i, title_columnName='역이름',startColNum=9)
        print(Service.colored_text("최종 병합된 테이블을 출력합니다",'yellow'))
        return test_
    def data_preprocessing_toAnalysis(data_dict,key_data):
        """
            # 📌 Description : 데이터 통합 정제 함수!!!
            # 📌 Date : 2024.06.13
            # 📌 Author : Forrest Dpark
            # 📌 Detail:
                * key_data(str) : 예를 들면 subway_23_0 이라는데이터에서 23_0 을 의미함!
                * data_dict : 승하차 데이터를 포함하고 있는 dictionary
                * 사용시 이상한부분 문의 => 010-7722-15920
                * Returns: colum 이름들을 정제하고 Nan을 제거한 정제 데이터 table
        """
        import pandas as pd, numpy as np
        # 필수 항목 check 
        # coloum check 
        saveFileName = "StationInfo_"+key_data.split("subway")[-1]
        test = data_dict[key_data] # 예시-> subway_dict_22_23['subway23_0']
        print(Service.colored_text("columns ---👇", 'green'))
        print(test.columns.tolist())
        # 호선, 역사번호,역명, 승하차구분
        # 연번은 drop 한다. 
        if '연번' in test.columns.tolist():
            print(" 1. 연번을 삭제합니다. ")
            test.drop('연번',axis=1,inplace = True)
            # print(test.columns)
        # 역명 -> 역이름
        if '역명' in test.columns.tolist():
            print(' 2."역명" ->"역이름", "역번호"->"역사코드 ".')
            test.rename({
                '날짜': '수송일자',
                '역번호':'역사코드',
                '역명':'역이름'}
                ,axis = 1
                ,inplace = True 
                )
        # 역번호 -> 역사번호 
        # 호선 데이터가 integer 인지 확인 
        if str(test['호선'].dtype)=='object':
            print(' 3. 호선 데이터가 object 입니다. ')
            for idx,line in enumerate(test['호선'].unique()):
                print("   -",line)
                if idx==2:
                    print(" ..")
                    break
            line_int=[int(linename.split("호선")[0]) for linename in test['호선']]
            print(" 😀호선을 integer 로 만듭니다.")
            print(" 3-1. 호선 을 제거한 이름 unique : ",*np.unique(line_int),sep=", ")
            test['호선'] = line_int
            print(" ✅변경된 호선 칼럼의 data type :",test['호선'].dtype)
        else : 
            print('3. 호선 데이터가 integer 입니다.')
            for idx,line in enumerate(test['호선'].unique()):
                print(" -",line)
                if idx==2:
                    print(" ..")
                    break
        ## null check -> 없다고 가정 
        subway=Service.dataInfoProcessing(test,replace_Nan=True,nanFillValue=0 )
        #역코드 개수 체크 -> 상관없음
        stationInfo = Service.subway_info_table(
            subway,
            save=True,
            saveFileName=saveFileName
            )
        print(subway.iloc[:4,:6])
        stationInfo

        station= pd.read_csv(f'../Data/{saveFileName}.csv')
        subway_dispatch = pd.read_csv("../Data/지하철배차시간데이터/서울교통공사_서울 도시철도 열차운행시각표_20240305.csv", encoding='euc-kr')

        for i in range(1,8):
            _ = Service.호선당서비스불가역이름추출(i,station, subway_dispatch)
        print("배차 시간 제공 역 개수: ",len(subway_dispatch['역사명'].unique())) # 총 394개의 역에대한 배차 시간데이터가 있다. 
        print(" 호선 ->",*np.sort(subway_dispatch['호선'].unique())) #1, 2, 3, 4, 5, 6, 7, 8, 9  -> 9호선 데이터 까지 있음

        ## line 별로 테이블을 따로 만든다, 
        # line1_배치= subway_dispatch[subway_dispatch['호선']==1]

        line_배치_dict = {}

        for i in range(1,9):
            line_배치_dict[f"{i}호선"] =subway_dispatch[subway_dispatch['호선']==i]
            interval= Service.dispatch_table_forML(
                line_배치_dict[f"{i}호선"],
                save=True,
                saveFileName=saveFileName+f"_{i}"
                )
            print(interval.iloc[0:3,:6].head(3))
        #정제후 데이터 출력
        return subway

#### 현재탑승객수 추정 및 배차 간격 시각화 
    def currentPassengerCalc(stations,pass_in,pass_out,dispached_subway_number):
        """
        # 📌 Description : 각 역에서의 추정 탑승인원 수 
        # 📌 Date : 2024.06.05
        # 📌 Author : Forrest Dpark
        # 📌 Detail:
            * stations (list): 한 호선의 역코드 or 역 이름 배열 
            * pass_in (list): 각 역당 승차 인원수 배열 
            * pass_out (list): 각 역당 하차 인원수 배열
            * dispached_subway_number (int): 배차대수
            * Returns: dataframe table
        """
        import pandas as pd , numpy as np
        # 승하차 정보 없을때 랜덤 승하차 인원 데이터 생성 
        if pass_in ==[] and pass_out ==[]:
            pass_in = np.zeros(shape=(len(stations)), dtype=int)
            pass_out = np.zeros(shape=(len(stations)), dtype=int)
            presentPassenger= np.zeros(shape=(len(stations)), dtype=int)
            for i,station in enumerate(stations):
                    pass_in[i]= np.random.randint(1,100) if i !=len(stations)-1 else 0
                
                    if i >0:
                        pass_out[i]= np.random.randint(1,presentPassenger[i-1])
                        presentPassenger[i] = presentPassenger[i-1] +pass_in[i]-pass_out[i]
                    else:
                        presentPassenger[i] = pass_in[i]
                    # print(station, f"역 => 승차: {input_pasasengers_rand[i]} ,하차 :{output_pasasengers_rand[i]}")
                    # print('현재탑승인원 : ',presentPassenger)
        #역별 변동인원
        
        diff_arr = np.asarray(pass_in) - np.asarray(pass_out)

        print(f"{dispached_subway_number}개 지하철이 배차되었을때 ")
        result = pd.DataFrame(
            {
                '역이름': stations,
                '승차인원': pass_in,
                '하차인원': pass_out,
                '변동인원': diff_arr,
                '탑승자수': presentPassenger,
                '배차당탑승자수': presentPassenger/dispached_subway_number,
                '량당빈좌석수' :42 -(presentPassenger/dispached_subway_number)/8 #42 개 6*7 노약자 제외 , 7호선은 8량
            }
        )
        return result
    def stationDispatchBarplot(df,row,title_columnName,startColNum):
        """
        ### 📌 Description : 역들의 지하철 배차 수(싱헹과 하행이 거의 비슷하다는 가정하에 추정수치임)
        ### 📌 Date : 2024.06.05
        ### 📌 Author : Forrest Dpark
        ### 📌 Detail:
            * df pd.DataFrame:(역사코드와 역이름, 평균 배차수 를 가지고 있는 데이터 프레임 )
            * row (int): 주중 행 , row+1 은 주말 행임. 
            * title_columnName (string) : 역이름 알수있는 칼럼. 
            * Returns: -
        """
        # fig =plt.figure(figsize=(20,5))
        fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(20, 5))
        bar1 = sns.barplot(
            data=df.iloc[row,startColNum:],
            color='orange',
            ax= ax1
        )
        ax1.set_title(f"{df[title_columnName].iloc[row]}역 시간대별 배차 수 분포[{'주중' if df['주중'].iloc[row] ==True else '주말'}]")
        ax1.set_ylabel("지하철 배차 수")
        bar1.bar_label(bar1.containers[0])
        
        bar2 = sns.barplot(
            data=df.iloc[row+1,startColNum:],
            color='green',
            ax= ax2,
            
        )
        bar2.bar_label(bar2.containers[0])
        
        ax2.set_title(f"{df[title_columnName].iloc[row+1]}역 시간대별 배차 수 분포[{'주중' if df['주중'].iloc[row+1] ==True else '주말'}]")
        ax2.set_ylabel("지하철 배차 수")
        maxlim=(max((df.iloc[row,startColNum:]).to_numpy()))
        # print(maxlim)
        ax2.set_ylim([0,maxlim])
        # bar2.set_ylim =[0,maxlim]
        plt.show()

#### 날짜 를 정제하는 함수
    def dayToIntConvert(df, dayCol):
        # 수송일자 날짜형으로 변환
        import pandas as pd
        ## 요일 컬럼 생성
        df['요일'] = pd.to_datetime(df[dayCol], format='%Y-%m-%d').dt.day_name().values
        # 요일을 영어에서 한국어로 변환
        day_name_mapping = {
            'Sunday': 0,
            'Monday': 1,
            'Tuesday': 2,
            'Wednesday': 3,
            'Thursday': 4,
            'Friday': 5,
            'Saturday': 6
        }
        df['요일'] = df['요일'].map(day_name_mapping)
        return df
    def date_Divid_Add_YMW_cols(df,DateColName):
        import pandas as pd
        from datetime import datetime, timedelta
        years = []
        weeks = []
        months = []
        for data in df[DateColName] :
            date_obj = pd.to_datetime(data)
            year, week, _ = date_obj.isocalendar()
            month = date_obj.month
            years.append(year)
            weeks.append(week)
            months.append(month)
        df['년도'] = years
        df['월'] = months
        df['주차'] = weeks
        return df
    def date_string_to_MonthWeekHolyDayname(date_str):
        from datetime import datetime,timedelta
        # 날짜 문자열을 datetime 객체로 변환
        date_object = datetime.strptime(date_str, '%Y-%m-%d')
        year = date_object.year
        # 해당 날짜의 첫 번째 날이 속한 주의 첫 번째 날짜를 찾음
        first_day_of_year = datetime(year, 1, 1)
        first_day_of_year_weekday = first_day_of_year.weekday()  # 해당 년도의 1월 1일의 요일
        first_week_start_date = first_day_of_year - timedelta(days=first_day_of_year_weekday)
        
        # 해당 날짜가 몇 번째 주인지 계산
        week_number = ((date_object - first_week_start_date).days // 7) + 1
        import holidays
        kr_holidays = holidays.KR()
        is_holi =  1 if date_object in kr_holidays else 0


        
        day_name = date_object.strftime('%A')
        month_number = date_object.month
        day_name_mapping = {
            'Sunday': 0,
            'Monday': 1,
            'Tuesday': 2,
            'Wednesday': 3,
            'Thursday': 4,
            'Friday': 5,
            'Saturday': 6
        }
        dayname_code = day_name_mapping.get(day_name)
        return month_number, week_number, is_holi,dayname_code
    def holidaysToIntConvert(df,DateColName):
        # !pip install holidays
        import holidays
        kr_holidays = holidays.KR()
        df['공휴일'] = df[DateColName].apply(lambda x: 0 if x in kr_holidays else 1)
        return df

####  머신러닝 관련 함수 
    def MultiOutputRegressorFunc_KNN(training_table, target_table,saveFileName) :
    
        """
        # Description : train, target데이터에 대한 MultiOutputRegressor model
        # Date : 2024.06.05
        # Author : Shin Nara + pdg
        # Detail:
            * training_table (df): train data
            * target_table (df): target data
            * Returns: - 
        # Updata:
            2024.06.07 by pdg :머신러닝 함수 업데이트 
                * 주석 달았음. 
            2024.06.09 by pdg : 
                * 함수화 완료
        """
        import pandas as pd, numpy as np
        import matplotlib.pyplot as plt 
        from sklearn.model_selection import train_test_split
        from sklearn.multioutput import MultiOutputRegressor
        from sklearn.neighbors import KNeighborsRegressor

        train_input, test_input, train_target, test_target = \
            train_test_split(training_table,
                            target_table, 
                            test_size=0.2,
                            random_state=42)
        ## KNN regression model 
        knn_regressor = KNeighborsRegressor(n_neighbors=3)
        ## Multi Output Setting
        multi_output_regressor = MultiOutputRegressor(knn_regressor)
        multi_output_regressor.fit(train_input, train_target)
        
        score = multi_output_regressor.score(test_input, test_target)
        print(f'Model score: {score}')
        
        predictions = multi_output_regressor.predict(test_input)
        # print(test_target.columns)
        # print(predictions[:5])
        print("주차     요일 시간대별 예측 :",*[f"{i}시" for i in range(5,25)], sep='\t')
        for idx,시간대별예측 in enumerate(predictions):
            주차 = test_input.to_numpy()[idx][1]
            요일 =test_input.to_numpy()[idx][3]
            실제치 = test_target.to_numpy()[idx]
            match 요일:
                case 요일 if 요일 == 0: 요일_str = '일'; 
                case 요일 if 요일 == 1: 요일_str = '월'; 
                case 요일 if 요일 == 2: 요일_str = '화'; 
                case 요일 if 요일 == 3: 요일_str = '수'; 
                case 요일 if 요일 == 4: 요일_str = '목'; 
                case 요일 if 요일 == 5: 요일_str = '금'; 
                case 요일 if 요일 == 6: 요일_str = '토'; 
                case _:print()
            print(f"{주차}주차 {요일_str}요일 시간대별 예측 :", *list(map(int,(시간대별예측))), sep='\t')
            print(f"{주차}주차 {요일_str}요일 시간대별 실제 :", *실제치, sep='\t')
            print("---"*200)
        import joblib ## model 저장 용 함수 
        filename = f'../Server/MLModels/{saveFileName}.h5'
        print(f"😀😀😀😀{filename} 을 저장합니다 😀😀😀")
        joblib.dump(multi_output_regressor, filename)
        
        return multi_output_regressor
    def station_name_to_code(line,station_name):
        """
            # Description : 역이름을 코드로 반환하는 함수
            # Date : 2024.06.07
            # Author : pdg
            # Detail:
                * line, station_name : '7호선', '중곡'
                * Returns: 해당 지하철 역사 코드 
            # Updata:
                * 2024.06.07 by pdg : 역사코드 반환함수 
                * 2024.06.09 by pdg : 중복 역사코드일경우 배열 반환?
                    - 만약에 종로3가처럼 코드가 여러개인 역사인경우 
                * 2024.06.10 by pdg : swift 로 api service 할때 코드 반환안되는 문제 해결 
                    -기존의 StationInfo.csv 에서 호선 칼럼이 숫자가아니라 ~호선 으로 데이터가 바뀌어 정제되어있음.
                    - 결과 반영하여 수정함. 
                2024.06.11 by pdg :  디렉토리 변경한후에 subwayInfo.csv 파일을 찾을수 없다는 에러가뜸..
                    - 상대경로를 인식할 수있도록 datapath 설정 변경 
                
        """
        import pandas as pd
        import os

        # 현재 파일(Functions.py)의 절대 경로를 기준으로 프로젝트 폴더 경로를 찾는다.
        module_dir = os.path.dirname(os.path.abspath(__file__))
        project_dir = os.path.dirname(module_dir)
        data_path = os.path.join(project_dir, 'Data', 'StationInfo.csv')
        
        # print("아하 라인 테스트 type : ",type(line),line)
        stations = pd.read_csv(data_path) ## 역정보 csv 
        # print(stations['호선'])
        target_line_stations = stations[stations['호선']==line] ## line select
        #print(target_line_stations)
        row = target_line_stations[station_name == target_line_stations['역이름']]
        # print(f"{station_name}의 역사 코드는 {row['역사코드'].values[0]}입니다")
        print("row의 내용: ",row.to_numpy())
        if len(row.to_numpy().tolist()) > 1:
            print('환승역입니다')
            print(f"{station_name}의 역사 코드는 {row['역사코드']}입니다")
            return row['역사코드'].tolist()
        if len(row.to_numpy().tolist())==0:
            print('찾을수 없는 역입니다')
        if len(row.to_numpy().tolist())==1:
            print(f"단일역입니다.{row['역사코드'].tolist()}")
            return row['역사코드'].values[0]
        
        print('어디서또 호출되니?')
    def sdtation_inout_lmplot(mlTable, line, station_name, time_passenger):
        """
            # Description : train, target데이터에 대한 회귀 모델 
            # Date : 2024.06.07
            # Author : pdg
            # Detail:
                * mlTable : training + target column concated table 
                line, station_name : 호선 ,이름 
                time_passenger ('string): 시간대 이름 target colomn 이름 
                ex) 7호선', '중곡', '08시인원'
                * Returns: - 
            # Updata:
                2024.06.07 by pdg :회귀함수 함수 업데이트  
        """
        
        import pandas as pd
        import matplotlib.pyplot as plt
        import seaborn as sns
        from sklearn.linear_model import LinearRegression
        from sklearn.metrics import r2_score
        # 코드에서 데이터를 불러오고, 서비스나 다른 클래스들은 인식하지 못해서 그대로 남겨두었습니다.
        code = Service.station_name_to_code(line, station_name)
        test = mlTable[mlTable['역사코드'] == code]
        
        # 숫자로 된 요일을 요일 이름으로 매핑
        day_mapping = {
            0: '일요일',
            1: '월요일',
            2: '화요일',
            3: '수요일',
            4: '목요일',
            5: '금요일',
            6: '토요일',
            7: '일요일'  # 0과 7이 모두 일요일이라고 가정
        }

        # '요일' 컬럼을 요일 이름으로 매핑
        test['요일'] = test['요일'].map(day_mapping)
        
        # 요일별로 색깔을 지정하기 위해 팔레트를 설정
        unique_days = test['요일'].unique()
        palette = sns.color_palette("hls", 8)

        day_to_color = dict(zip(unique_days, palette))
        # print(day_to_color)
        # DataFrame을 저장할 리스트 생성
        regression_lines = []
        
        # 요일별로 플롯을 나누기 위해 FacetGrid 사용
        g = sns.FacetGrid(test, col='요일', col_wrap=4, height=4, aspect=1, palette=palette)
        g.map_dataframe(sns.scatterplot, '주차', time_passenger, hue='요일', palette=palette)

        for ax in g.axes.flatten():
                day = ax.get_title().split('=')[-1].strip()
                day_data = test[test['요일'] == day]
                sns.regplot(
                    x='주차',
                    y=time_passenger,
                    data=day_data,
                    scatter=False,
                    ax=ax,
                    color=palette[list(day_mapping.values()).index(day)]
                )
                day_data = test[test['요일'] == day]
                # 회귀 모델 학습
                X = day_data[['주차']]
                y = day_data[time_passenger]
                reg = LinearRegression().fit(X, y)
                
                # 회귀 모델의 결정 계수 (R-squared) 계산
                r2 = 1 - r2_score(y, reg.predict(X))
                
                # 회귀 모델의 계수와 절편
                coef = reg.coef_[0]
                intercept = reg.intercept_
                
                # 회귀식을 문자열로 저장
                equation = f'y = {coef:.2f}x + {intercept:.2f}'
                
                # 회귀 모델의 수식을 DataFrame에 추가
                regression_lines.append({'요일': day, '계수': coef, '절편': intercept, 'R2 스코어': r2})
                # 회귀 모델의 수식 플롯

                ax.text(0.5, 0.9, f'R2 Score: {r2:.2f}\n{equation}', horizontalalignment='center', verticalalignment='center', transform=ax.transAxes, fontsize=10)
        
        # DataFrame으로 변환
        regression_df = pd.DataFrame(regression_lines)
        
        # 제목 설정
        g.set_titles(col_template="{col_name}")
        g.set_axis_labels('주차', '인원수(단위 : 명)')
        title = f'{line} {station_name}역 : 요일 별 {time_passenger} 주차 vs 인원수'
        plt.subplots_adjust(top=0.9)
        g.fig.suptitle(title)
        
        plt.show()
        
        # DataFrame 반환
        return regression_df
    def regression_predict(mlTable,line, station_name, week_index, dayName_int,target_colName= '08시인원'):
        """
        # Description : train, target데이터에 대한 회귀 모델  예측 
        # Date : 2024.06.07
        # Author : pdg
        # Detail:
            * mlTable : training + target column concated table 
            line, station_name : 호선 ,이름 
            time_passenger ('string): 시간대 이름 target colomn 이름 
            ex) 7호선', '중곡', '08시인원'
            * Returns: 주차 10에 월요일 8시 대한 회귀 모델의 예측값
        # Updata:
            2024.06.07 by pdg :회귀함수 함수 업데이트  
            - 사용 예시 : pred_result = regression_predict(test,'7호선', '중곡',10,1,'08시인원')
        """
        print(line, station_name, week_index)
        from Project.HaruSijack.DataAnalysis.Module.Functions import Service
        test_code= Service.station_name_to_code(line,station_name)
        print(test_code)
        
        print(f'{line} {station_name}역 [{test_code}] {week_index}주차 요일 별 {target_colName} ')
        test_중곡 = mlTable[mlTable['역사코드']== test_code]
        
        regression_df = Service.sdtation_inout_lmplot(mlTable, line, station_name, target_colName)
        regression_equation = regression_df.loc[regression_df.index[dayName_int]]  # 마지막 행의 회귀식
        # 회귀식에서 계수와 절편 추출
        intercept = regression_equation['절편']
        slope = regression_equation['계수']
        # 주어진 주차에 대한 예측값 계산
        prediction = intercept + slope * week_index
        print(f"주차 {week_index}에 월요일 8시 대한 회귀 모델의 예측값:", prediction)
        target_table = test_중곡[test_중곡['주차']==week_index][['요일',target_colName]]
        print(" ----실제 인원 ------")
        print(target_table.loc[target_table.index[dayName_int]])

        return prediction

### 데이터 신뢰성 판단 관련 함수
    def 호선당서비스불가역이름추출(line,승하차_역정보테이블, 배차역정보_테이블):
        """
        # 📌 Description :  승하차 데이터에 존재하지않는 서비스불가 역의 리스트를 출력함. 
        # 📌 Date : 2024.06.09
        # 📌 Author : pdg
        # 📌 Detail:
            🔸 line (int)
            🔸 승하차_역정보테이블 (df)
            🔸 배차역정보_테이블(df)
            🔸 Returns: 서비스불가 역의 리스트
        # 📌 Update:

        """

        result =[]
        try :
            승하차_역사코드 = 승하차_역정보테이블[승하차_역정보테이블['호선']==line]['역사코드']
            배차역_역사코드 = 배차역정보_테이블[배차역정보_테이블['호선']==line]['역사코드']
            service_disable_station =list(map(int,list(set(배차역_역사코드)- set(승하차_역사코드)))) ## service 불가 지역 리스트 
            print(service_disable_station)
            uniq_배차=배차역정보_테이블[['역사코드','역사명','호선']].drop_duplicates().reset_index(drop=True)
            target_line_subway= uniq_배차[uniq_배차['호선']==line]
            print(service_disable_station)
            if service_disable_station !=[]:
                print(Service.colored_text(f"⬇--{line}호선 서비스불가 역사코드 . 및 역사명--⬇", 'red'))
                i = 0
                for idx, row in enumerate(target_line_subway.to_numpy()):
                    for j in service_disable_station:
                        if  row[0] == j :
                            print(f" {i+1}.{int(row[0])} {row[1]} 역")
                            result.append([int(row[0]), row[1], row[2]])
                            i +=1
                print("-"*20)
        except:
            pass
        finally :return result
        ''' 함수 사용 예시!!
        for i in range(1,8):
            _ = Service.호선당서비스불가역이름추출(i,station, subway_dispatch) 
        '''



if __name__ == '__main__':  
    print("main stdart")
    # 프로세스를 생성
    # p0 = Process(target=start_get, args=(0, 100000000)) ## cpu1에서 돌아간다. 
    # p1 = Process(target=start_get, args=(100000001, 200000000))  # cpu2에서 돌아간다. 
    # p2 = Process(target=start_get, args=(200000001, 300000000)) # cpu3에서 돌아간다. 



