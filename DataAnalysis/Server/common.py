# common.py
import os
from openai import OpenAI
from dataclasses import dataclass
from pprint import pprint

@dataclass(frozen=True)
class Model:
    basic: str = "gpt-3.5-turbo-1106"
    advanced: str = "gpt-4-1106-preview"

def get_model():
    return Model()

def get_client():
    return OpenAI(api_key=os.getenv("OPENAI_API_KEY"), timeout=30, max_retries=1)
