FROM python:3.9

WORKDIR /app

ENV NAME=your_name

COPY /app .

RUN pip install -r requirements.txt 

CMD ["python", "hello_world.py"]
