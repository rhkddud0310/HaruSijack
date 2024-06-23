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
import sys, subprocess, os, warnings, pandas as pd
from datetime import datetime
import cv2
import argparse
import numpy as np

warnings.filterwarnings("ignore", category=UserWarning, module='cv2')

class ImageProcessing:
    zoom_factor = 1.0
    zoom_center = None
    clicked_points = []
    clone = None
    current_image = None
    is_dragging = False
    drag_start_pos = None

    @staticmethod
    def MouseCallback(event, x, y, flags, param):
        if event == cv2.EVENT_LBUTTONDOWN:
            if ImageProcessing.zoom_center is not None:
                orig_x = int((x - ImageProcessing.zoom_center[0]) / ImageProcessing.zoom_factor + ImageProcessing.zoom_center[0])
                orig_y = int((y - ImageProcessing.zoom_center[1]) / ImageProcessing.zoom_factor + ImageProcessing.zoom_center[1])
            else:
                orig_x, orig_y = x, y
            
            ImageProcessing.clicked_points.append((orig_y, orig_x))
            ImageProcessing.update_image()
            print(f"Clicked at: ({orig_x}, {orig_y})")
            print("image updated!!")


        elif event == cv2.EVENT_RBUTTONDOWN:
            ImageProcessing.is_dragging = True
            ImageProcessing.drag_start_pos = (x, y)

        elif event == cv2.EVENT_RBUTTONUP:
            ImageProcessing.is_dragging = False

        elif event == cv2.EVENT_MOUSEMOVE:
            if ImageProcessing.is_dragging and ImageProcessing.zoom_center is not None:
                dx = (x - ImageProcessing.drag_start_pos[0]) / ImageProcessing.zoom_factor
                dy = (y - ImageProcessing.drag_start_pos[1]) / ImageProcessing.zoom_factor
                h, w = ImageProcessing.current_image.shape[:2]
                ImageProcessing.zoom_center = (
                    max(0, min(w, ImageProcessing.zoom_center[0] - dx)),
                    max(0, min(h, ImageProcessing.zoom_center[1] - dy))
                )
                ImageProcessing.drag_start_pos = (x, y)
                ImageProcessing.update_image()

    @staticmethod
    def zoom_image(image, factor=1.0, center=None):
        h, w = image.shape[:2]
        if center is None:
            center = (w//2, h//2)
        M = cv2.getRotationMatrix2D(center, 0, factor)
        zoomed = cv2.warpAffine(image, M, (w, h))
        return zoomed

    @staticmethod
    def update_image():
        image = ImageProcessing.clone.copy()
        for point in ImageProcessing.clicked_points:
            cv2.circle(image, (point[1], point[0]), 5, (100, 5, 95), thickness=-1)
        
        zoomed = ImageProcessing.zoom_image(image, ImageProcessing.zoom_factor, ImageProcessing.zoom_center)
        cv2.imshow("image", zoomed)
        cv2.waitKey(1)  # 이 줄을 추가합니다

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
        print("\n")
        print("1. 입력한 파라미터인 이미지 경로(--path)에서 이미지들을 차례대로 읽어옵니다.")
        print("2. 키보드에서 'n'을 누르면(next 약자) 다음 이미지로 넘어갑니다. 이 때, 작업한 점의 좌표가 저장 됩니다.")
        print("3. 키보드에서 'b'를 누르면(back 약자) 직전에 입력한 좌표를 취소합니다.")
        print("4. 이미지 경로에 존재하는 모든 이미지에 작업을 마친 경우 또는 'q'를 누르면(quit 약자) 프로그램이 종료됩니다.")
        print("5. '+' 또는 '='로 확대, '-' 또는 '_'로 축소, 'r'로 리셋할 수 있습니다.")
        print("6. 마우스 오른쪽 버튼을 누른 채로 드래그하여 이미지를 이동할 수 있습니다.")
        print("\n")
        print("출력 포맷 : 이미지명,점의갯수,y1,x1,y2,x2,...")
        print("\n")

        path, sampling = ImageProcessing.GetArgument()
        image_names = [f for f in os.listdir(path) if f.endswith('.jpg') or f.endswith('.png')]
        
        # cv2.namedWindow("image")
        
        cv2.namedWindow("image", cv2.WINDOW_AUTOSIZE | cv2.WINDOW_KEEPRATIO | cv2.WINDOW_GUI_EXPANDED)

        cv2.setMouseCallback("image", ImageProcessing.MouseCallback)

        for idx, image_name in enumerate(image_names):
            if (idx % sampling != 0):
                continue

            image_path = os.path.join(path, image_name)
            ImageProcessing.current_image = cv2.imread(image_path)

            if ImageProcessing.current_image is None:
                print(f"Error: Unable to read image {image_path}")
                continue

            ImageProcessing.clone = ImageProcessing.current_image.copy()
            ImageProcessing.clicked_points = []
            ImageProcessing.zoom_factor = 1.0
            ImageProcessing.zoom_center = None

            while True:
                ImageProcessing.update_image()
                key = cv2.waitKey(1) & 0xFF

                if key == ord('n'):
                    df = pd.DataFrame(ImageProcessing.clicked_points, columns=['y', 'x'])
                    csv_path = os.path.join(path, f'{os.path.splitext(image_name)[0]}_points.csv')
                    df.to_csv(csv_path, index=False)
                    break

                elif key == ord('b'):
                    if ImageProcessing.clicked_points:
                        ImageProcessing.clicked_points.pop()
                        ImageProcessing.update_image()

                elif key == ord('q'):
                    cv2.destroyAllWindows()
                    return

                elif key in [ord('+'), ord('=')]:
                    ImageProcessing.zoom_factor *= 1.1
                    if ImageProcessing.zoom_center is None:
                        h, w = ImageProcessing.current_image.shape[:2]
                        ImageProcessing.zoom_center = (w//2, h//2)
                    ImageProcessing.update_image()
                    cv2.waitKey(1)

                elif key in [ord('-'), ord('_')]:
                    ImageProcessing.zoom_factor = max(1.0, ImageProcessing.zoom_factor / 1.1)
                    if ImageProcessing.zoom_factor == 1.0:
                        ImageProcessing.zoom_center = None
                    ImageProcessing.update_image()
                    cv2.waitKey(1)

                elif key == ord('r'):
                    ImageProcessing.zoom_factor = 1.0
                    ImageProcessing.zoom_center = None
                    ImageProcessing.update_image()
                cv2.waitKey(1)



        cv2.destroyAllWindows()

if __name__ == "__main__":
    ImageProcessing.main()