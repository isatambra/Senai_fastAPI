#Fase 1 
FROM python:3.11-slim as builder

WORDIR /app

RUN pip install --upgrade pip
COPY requirements.txt

RUN pip install -r requirements.txt

#Fase 2 -build
FROM python:3.11-slim

WORDIR /app

# criar usuario não-root para segurança
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /usr/local/bin/uvicorn /usr/local/bin/uvicorn

#copiar o APP
COPY app/ ./app/
  
USER appuser
EXPOSE 8080
CMD [ "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080" ]
