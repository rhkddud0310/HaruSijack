"""
## 📌 Project : 하루시작 프로젝트 Module functions  📌🔸🟦✅🆕🉐
## 📌 Description : 
    🔸  앱개발시 노선도 내에 역버튼 생성할때이미지 내에서의 위치를 알아아한다. 
    🔸 역의 개수가 상당히 많아 수작업으로 추출하기 어려움 
    🔸 cv, subporcess 등 라이브러릴 활용하여  만듬. 
    🔸 블로그 참고 : https://gaussian37.github.io/vision-opencv-coordinate_extraction/
## 📌 Author : Forrest Dpark
## 📌 Date : 2024.06.10 ~
## 📌 Detail : 
    🔸 사용 방법 : 터미널에서 본 파이썬 파일을 실행, 명령어 끝에 --path 이미지파일 을 붙여 실행하면 이미지가뜸
    이후에 이미지에서 마우스 클릭하면 색이 칠해지며 포지션 정보가 터미널에 뜸. 
    클릭을 다끝낸뒤에 n 을 누르면 파일이 꺼지면서 노선도 이미지가 저장되어있는 폴더안에 point.csv 파일이 자동저장됨 .
        
## 📌 Updates:
    🟦 2024.06.10 by pdg : blog code, gpt 활용하여 앱 만듬.
    🆕 2024.06.12 by pdg : 지하철 노선도가 큰 경우 줌해서 점을 클릭할수있도록 하는 기능 추가  

    2024.06.23 by pjh , pdg : 
        - 지하철 노선도 이미지 확대하여 좌표 값 추출 하도록 변경 
"""
import sys,subprocess,os,warnings,pandas as pd
from datetime import datetime
# zoom factor init
global zoom_factor, zoom_center
zoom_factor = 1.0
zoom_center = None


# 경고 무시 설정
warnings.filterwarnings("ignore", category=UserWarning, module='cv2')

# pip가 없으면 pip를 설치한다.
try:
    import pip
except ImportError:
    print("Install pip for python3")
    subprocess.call(['sudo', 'apt-get', 'install', 'python3-pip'])

# cv가 없으면 cv를 설치한다.
try:
    import cv2
except ModuleNotFoundError:
    print("Install opencv in python3")
    subprocess.call([sys.executable, "-m", "pip", "install", 'opencv-python'])
finally:
    import cv2

# argparse가 없으면 argparse를 설치한다.
try:
    import argparse
except ModuleNotFoundError:
    print("Install argparse in python3")
    subprocess.call([sys.executable, "-m", "pip", "install", 'argparse'])
finally:
    import argparse

# numpy가 없으면 numpy를 설치한다.
try:
    import numpy
except ModuleNotFoundError:
    print("Install numpy in python3")
    subprocess.call([sys.executable, "-m", "pip", "install", 'numpy'])
finally:
    import numpy as np

dir_del = None
clicked_points = []
clone = None

class ImageProcessing:
    def __init__(self) -> None:
        pass
    # 외쪽 버튼 클릭시 좌표 반환
    @staticmethod
    def MouseLeftClick(event, x, y, flags, param):
        global zoom_factor, zoom_center, clicked_points, clone
        if event == cv2.EVENT_LBUTTONDOWN:
            # 확대된 좌표를 원본 좌표로 변환
            if zoom_center is not None:
                orig_x = int((x - zoom_center[0]) / zoom_factor + zoom_center[0])
                orig_y = int((y - zoom_center[1]) / zoom_factor + zoom_center[1])
            else:
                orig_x, orig_y = x, y
            
            clicked_points.append((orig_y, orig_x))
            print(f"Clicked at: ({orig_x}, {orig_y})")

            # 원본 이미지에 점 찍기
            image = clone.copy()
            for point in clicked_points:
                cv2.circle(image, (point[1], point[0]), 5, (100, 5, 95), thickness=-1)
            
            # 확대된 이미지 표시
            zoomed = ImageProcessing.zoom_image(image, zoom_factor, zoom_center)
            cv2.imshow("image", zoomed)
    ## zoom 된 이미지를 반환
    @staticmethod
    def zoom_image(image, factor=1.0, center=None):
        h, w = image.shape[:2]
        if center is None:
            center = (w//2, h//2)
        M = cv2.getRotationMatrix2D(center, 0, factor)
        zoomed = cv2.warpAffine(image, M, (w, h))
        return zoomed
    
    @staticmethod
    def GetArgument():
        ap = argparse.ArgumentParser()
        ap.add_argument("--path", required=True, help="Enter the image files path")
        ap.add_argument("--sampling", default=1, help="Enter the sampling number.(default = 1)")
        args = vars(ap.parse_args())
        path = args['path']
        sampling = int(args['sampling'])
        return path, sampling

    @staticmethod
    def main():
        global clone, clicked_points
        global zoom_factor, zoom_center
        print("\n")
        print("1. 입력한 파라미터인 이미지 경로(--path)에서 이미지들을 차례대로 읽어옵니다.")
        print("2. 키보드에서 'n'을 누르면(next 약자) 다음 이미지로 넘어갑니다. 이 때, 작업한 점의 좌표가 저장 됩니다.")
        print("3. 키보드에서 'b'를 누르면(back 약자) 직전에 입력한 좌표를 취소한다.")
        print("4. 이미지 경로에 존재하는 모든 이미지에 작업을 마친 경우 또는 'q'를 누르면(quit 약자) 프로그램이 종료됩니다.")
        print("\n")
        print("출력 포맷 : 이미지명,점의갯수,y1,x1,y2,x2,...")
        print("\n")

        # 이미지 디렉토리 경로를 입력 받는다.
        path, sampling = ImageProcessing.GetArgument()
        # path의 이미지명을 받는다.
        image_names = os.listdir(path)
        # path를 구분하는 delimiter를 구한다.
        if len(path.split('\\')) > 1:
            dir_del = '\\'
        else :
            dir_del = '/'

        # path에 입력된 마지막 폴더 명을 구한다.    
        folder_name = path.split(dir_del)[-1]

        # 결과 파일을 저장하기 위하여 현재 시각을 입력 받는다.
        now = datetime.now()
        now_str = "%s%02d%02d_%02d%02d%02d" % (now.year - 2000, now.month, now.day, now.hour, now.minute, now.second)   

        # 새 윈도우 창을 만들고 그 윈도우 창에 click_and_crop 함수를 세팅해 줍니다.
        cv2.namedWindow("image")
        cv2.setMouseCallback("image", ImageProcessing.MouseLeftClick)

        for idx, image_name in enumerate(image_names):
            if (idx % sampling != 0):
                continue

            image_path = path + dir_del + "Z노선도_국문.jpg"
            print(image_path)
            image = cv2.imread(image_path)

            print("--------------------")
            print(image)
            clone = image.copy()
            flag = False

            while True:
                cv2.imshow("image", image)
                key = cv2.waitKey(0)

                if key == ord('n'):
                    # 클릭한 점들을 pandas 데이터프레임으로 저장
                    df = pd.DataFrame(clicked_points, columns=['y', 'x'])
                    csv_path = os.path.join(path, f'{image_name.splite(".")[0]}_points1.csv')
                    df.to_csv(csv_path, index=False)
                    
                    # 클릭한 점 초기화
                    clicked_points = []
    
                    break

                if key == ord('b'):
                    if len(clicked_points) > 0:
                        clicked_points.pop()
                        image = clone.copy()
                        for point in clicked_points:
                            cv2.circle(image, (point[1], point[0]), 2, (0, 255, 255), thickness = -1)
                        cv2.imshow("image", image)

                if key == ord('q'):
                    # 프로그램 종료
                    flag = True
                    break

                elif key == ord('+') or key == ord('='):  # 확대
                    zoom_factor *= 1.1
                    print(zoom_factor)
                    if zoom_center is None:
                        h, w = image.shape[:2]
                        zoom_center = (w//2, h//2)
                    print("zoom 됨")
                    zoomed_image = ImageProcessing.zoom_image(image, zoom_factor, zoom_center)
                    cv2.imshow("image", zoomed_image)

                elif key == ord('-') or key == ord('_'):  # 축소
                    zoom_factor /= 1.1
                    print(zoom_factor)
                    if zoom_factor < 1:
                        zoom_factor = 1
                        zoom_center = None
                    zoomed_image = ImageProcessing.zoom_image(image, zoom_factor, zoom_center)
                    cv2.imshow("image", zoomed_image)
                    

                elif key == ord('r'):  # 리셋
                    zoom_factor = 1
                    zoom_center = None
                    # 즉시 리셋된 이미지를 표시
                    cv2.imshow("image", image)

                # WASD로 이미지 이동
                elif key == ord('w'):
                    if zoom_center: 
                        zoom_center = (zoom_center[0], max(0, zoom_center[1]-10))
                        zoomed_image = ImageProcessing.zoom_image(image, zoom_factor, zoom_center)
                        cv2.imshow("image", zoomed_image)
                elif key == ord('s'):
                    if zoom_center: 
                        zoom_center = (zoom_center[0], min(image.shape[0], zoom_center[1]+10))
                        zoomed_image = ImageProcessing.zoom_image(image, zoom_factor, zoom_center)
                        cv2.imshow("image", zoomed_image)
                elif key == ord('a'):
                    if zoom_center: 
                        zoom_center = (max(0, zoom_center[0]-10), zoom_center[1])
                        zoomed_image = ImageProcessing.zoom_image(image, zoom_factor, zoom_center)
                        cv2.imshow("image", zoomed_image)
                elif key == ord('d'):
                    if zoom_center: 
                        zoom_center = (min(image.shape[1], zoom_center[0]+10), zoom_center[1])
                        zoomed_image = ImageProcessing.zoom_image(image, zoom_factor, zoom_center)
                        cv2.imshow("image", zoomed_image)



                if flag:
                    break
                
                

        # 모든 window를 종료합니다.
        cv2.destroyAllWindows()
        

if __name__ == "__main__":
    ImageProcessing.main()
