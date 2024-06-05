"""
## Projectr : 하루시작 프로젝트 Module functions  
## Description : 
    -  Data 정제를 위한 Fuction modul e
## Author : Forrest Dpark (분석 담당)
## Date : 2024.05.31 ~
## Detail : 
    - 사용 방법 : 
        // from Functions  import Service   # module importing 
            service = Service()             # class instance 생성
            service.dataInfoProcessing(df)  # Data information 정보 출력 
            service.plotSetting()           # OS 한글화 한 Matplotlib Setting 
## Update:  
    - 2024.06.02 by pdg : multiprocessing import 
        * Data frame column 정보 ( Null check, 중복체크 )플랏 
    - 2024.06.03 by pdg : datdaInfoProcessing 함수 생성
        * DataInfoProcessing 함수의 printoutcolnumber 플랏할 칼럼 갯수를 선택할수있게 설정함. 
    - 2024.06.05 by pdg :  
        *  

"""
## project data processing functions 
from multiprocessing import Process
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

              


if __name__ == '__main__':
    print("main stdart")
    # 프로세스를 생성
    # p0 = Process(target=start_get, args=(0, 100000000)) ## cpu1에서 돌아간다. 
    # p1 = Process(target=start_get, args=(100000001, 200000000))  # cpu2에서 돌아간다. 
    # p2 = Process(target=start_get, args=(200000001, 300000000)) # cpu3에서 돌아간다. 

    



