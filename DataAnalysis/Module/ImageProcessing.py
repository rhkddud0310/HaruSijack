import sys
import subprocess
import os
from datetime import datetime
import warnings
import pandas as pd

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

    @staticmethod
    def MouseLeftClick(event, x, y, flags, param):
        # 왼쪽 마우스가 클릭되면 (x, y) 좌표를 저장한다.
        if event == cv2.EVENT_LBUTTONDOWN:
            clicked_points.append((y, x))
            print(f"Clicked at: ({x}, {y})")  # 클릭한 좌표를 터미널에 출력

            # 원본 파일을 가져 와서 clicked_points에 있는 점들을 그린다.
            image = clone.copy()
            for point in clicked_points:
                cv2.circle(image, (point[1], point[0]), 5, (100, 5, 95), thickness = -1)
            cv2.imshow("image", image)

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

            image_path = path + dir_del + image_name
            image = cv2.imread(image_path)

            clone = image.copy()

            flag = False

            while True:
                cv2.imshow("image", image)
                key = cv2.waitKey(0)

                if key == ord('n'):
                    # 클릭한 점들을 pandas 데이터프레임으로 저장
                    df = pd.DataFrame(clicked_points, columns=['y', 'x'])
                    csv_path = os.path.join(path, f'{image_name}_points.csv')
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

            if flag:
                break

        # 모든 window를 종료합니다.
        cv2.destroyAllWindows()
        

if __name__ == "__main__":
    ImageProcessing.main()
