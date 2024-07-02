"""
 ## Desc : chat bot service api 
## Author : harusizakc
## update: 
    * 2024.06.28 by J.park : service update
        - news 페이지 생성 및 초기 연결
"""

from fastapi import APIRouter
router = APIRouter()

# @app.post
@router.get("/")
async def read_root():
    ## sync 방식
    return {"message":"hello world!!!"}

@router.get("/news")
async def read_item( query_parameter: str = None):
    
    return {"message":" harusizack news service!"}
å



# uvicorn fastapi_02:app --reload