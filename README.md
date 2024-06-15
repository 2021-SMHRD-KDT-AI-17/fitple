# FITPLE Chatbot

FITPLE Chatbot은 사용자의 운동 및 다이어트 계획을 추천해주는 AI 헬스 트레이너입니다. OpenAI의 GPT-4o 모델을 활용하여 사용자의 질문에 맞춤형 응답을 생성합니다.

## 주요 기능

- **운동 및 다이어트 추천**: 사용자의 요구에 맞춰 운동 루틴과 다이어트 식단을 추천합니다.
- **문서 유사도 검색**: FAISS를 사용하여 가장 유사한 문서를 검색하고, 이를 기반으로 답변을 생성합니다.
- **비동기 처리**: aiohttp와 asyncio를 활용하여 빠르고 효율적인 비동기 API 호출을 처리합니다.

## 설치 및 실행 방법

1. **필수 패키지 설치**

    ```bash
    pip install Flask Flask-Cors openai langchain faiss-cpu transformers flask-compress aiohttp
    ```

2. **환경 변수 설정**

    OpenAI API 키를 환경 변수로 설정합니다.

    ```bash
    export OPENAI_API_KEY='your_openai_api_key'
    ```

3. **코드 클론 및 실행**

    ```bash
    git clone https://github.com/yourusername/fitple-chatbot.git
    cd fitple-chatbot
    python app.py
    ```

4. **데이터 파일 준비**

    프로젝트 루트 디렉토리에 `full_workout_dataset.csv`와 `food.csv` 파일을 준비합니다.

## 사용 예시

서버를 실행한 후, POST 요청을 통해 질문을 보낼 수 있습니다.

```bash
curl -X POST http://localhost:5000/api/chatbot \
    -H "Content-Type: application/json" \
    -d '{"question": "어떤 운동을 해야 할까요?"}'
