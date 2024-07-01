"""
 ## Desc : chat bot service api 
## Author : harusizakc
## update: 
    * 2024.06.28 by pdg : service update
        - nlp service update
        - news service update 
"""

from fastapi import APIRouter
router = APIRouter()

# @app.post
@router.get("/")
async def read_root():
    ## sync 방식
    return {"message":"hello world!!!"}

@router.get("/chatbot")
async def read_item( query_parameter: str = None):
    
    return {"message":" harusizack chat bot service!"}




# uvicorn fastapi_02:app --reload