"""
## Projectr : 하루시작 프로젝트 Module functions  
## Description : 
    -  Data 정제를 위한 Fuction modul e
## Author : Forrest Dpark (분석 담당)
## Date : 2024.05.31 ~
## Detail : 
    - 사용 방법 : 
        // from Functions  import Service   # module importing 
            Service.dataInfoProcessing(df)  # Data information 정보 출력 
            Service.plotSetting()           # OS 한글화 한 Matplotlib Setting 
## Update:  
    - 2024.06.02 by pdg : multiprocessing import 
        * Data frame column 정보 ( Null check, 중복체크 )플랏 
    - 2024.06.03 by pdg : datdaInfoProcessing 함수 생성
        * DataInfoProcessing 함수의 printoutcolnumber 플랏할 칼럼 갯수를 선택할수있게 설정함. 
    - 2024.06.05 by pdg : 기타 함수 생성 
        * plotSetting 함수 추가 
        * reorder_columns 함수 추가 -> 칼럼의 순서를 바꾸어줌.
        * currentPassengerCalc 함수 추가 현재 탑승객 및 량당 빈자리 추출(노인석 제외)
        * stationDispatchBarplot 함수 추가 -> 지하철 역별 배차 지하철 수치 barplot check 

"""
## project data processing functions 
from multiprocessing import Process
import matplotlib.pyplot as plt, seaborn as sns

class Service:
    def __init__(self) -> None:
        pass
    def dataInfoProcessing(df, replace_Nan=False, PrintOutColnumber = 10):
        ''' 
        # Fucntion Description :  Data frame 의 정제해야할 부분을 체크해주는 함수 
        # Date : 2024.06.02 
        # Author : Forrest D Park 
        # update : 
            * 2024.06.02 by pdg: 일별 데이터 정제 
                - 데이터에 null 이 있음을 발견, data 정제 함수 update 
                - 함수에서 replace_Nan 아규 멘트 받아서 true 일경우 nan 을 0 으로 대체 하게 만듬. 
            * 2024.06.04 by pdg : 함수변경
                -관심 칼럼이 많을때 칼럼 개수를 조정할수있게 함. 
        '''
        print("\n1. Data colum numbers : ",len(df.columns))
        #print(subway.columns)
        #print(subway.info())
        null_message =f"총 {df.isnull().sum().sum()}개의 null 이 있습니다!" if df.isnull().sum().sum() else "Null 없는 clean data!"
        print("\n2. null ceck 결과",null_message)
        ### Null 이 있는 칼럼 추출
        haveNullColumn =[]
        for idx, col in enumerate(df.columns):
            if df[f"{col}"].isnull().sum():
                print(f"   => {idx}번째.[{col}]컬럼 : ",f"null {df[f'{col}'].isnull().sum()} 개,\t not null {df[f'{col}'].notnull().sum()} 개")
                ## Null data fill
        if replace_Nan : ## nan 을 0 으로 대체 
            df[col].fillna(value=0, inplace=True)  
        
        print("\n3. Column  Information (중복체크)")
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
        print("___## OS platform 한글 세팅완료 ## ___")
    def reorder_columns(df, col_name, target_idx):
        """
        # Description : Reorder columns in a DataFrame by moving a specific column to a target index.
        # Date : 2024.06.05
        # Author : Forrest Dpark
        # Detail:
            * df (pandas.DataFrame): The input DataFrame.
            * col_name (str): The name of the column to be moved.
            * target_idx (int): The target index where the column should be placed.
            * Returns: pandas.DataFrame: The DataFrame with the column reordered.
        """
        cols = list(df.columns)
        current_idx = cols.index(col_name)
        cols.pop(current_idx)
        cols.insert(target_idx, col_name)
        return df[cols]


    def currentPassengerCalc(stations,pass_in,pass_out,dispached_subway_number):
        """
        # Description : 각 역에서의 추정 탑승인원 수 
        # Date : 2024.06.05
        # Author : Forrest Dpark
        # Detail:
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
                '역명': stations,
                '승차인원': pass_in,
                '하차인원': pass_out,
                '변동인원': diff_arr,
                '탑승자수': presentPassenger,
                '배차당탑승자수': presentPassenger/dispached_subway_number,
                '량당빈좌석수' :42 -(presentPassenger/dispached_subway_number) #42 개 6*7 노약자 제외 
            }
        )
        return result

    def stationDispatchBarplot(df,row,title_columnName):
        """
        # Description : 역들의 지하철 배차 수(싱헹과 하행이 거의 비슷하다는 가정하에 추정수치임)
        # Date : 2024.06.05
        # Author : Forrest Dpark
        # Detail:
            * df pd.DataFrame:(역사코드와 역명, 평균 배차수 를 가지고 있는 데이터 프레임 )
            * row (int): 주중 행 , row+1 은 주말 행임. 
            * title_columnName (string) : 역이름 알수있는 칼럼. 
            * Returns: -
        """
        # fig =plt.figure(figsize=(20,5))
        fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(20, 5))
        bar1 = sns.barplot(
            data=df.iloc[row,8:]//2,
            color='orange',
            ax= ax1
        )
        ax1.set_title(f"{df[title_columnName].iloc[row]}역 시간대별 배차 수 분포[{'주중' if df['DAY'].iloc[row] ==True else '주말'}]")
        ax1.set_ylabel("지하철 배차 수")
        bar1.bar_label(bar1.containers[0])
        
        bar2 = sns.barplot(
            data=df.iloc[row+1,8:]//2,
            color='green',
            ax= ax2,
            
        )
        bar2.bar_label(bar2.containers[0])
        
        ax2.set_title(f"{df[title_columnName].iloc[row+1]}역 시간대별 배차 수 분포[{'주중' if df['DAY'].iloc[row+1] ==True else '주말'}]")
        ax2.set_ylabel("지하철 배차 수")
        maxlim=(max((df.iloc[row,8:]//2).to_numpy()))
        print(maxlim)
        ax2.set_ylim([0,maxlim])
        # bar2.set_ylim =[0,maxlim]
        plt.show()
if __name__ == '__main__':
    print("main stdart")
    # 프로세스를 생성
    # p0 = Process(target=start_get, args=(0, 100000000)) ## cpu1에서 돌아간다. 
    # p1 = Process(target=start_get, args=(100000001, 200000000))  # cpu2에서 돌아간다. 
    # p2 = Process(target=start_get, args=(200000001, 300000000)) # cpu3에서 돌아간다. 


