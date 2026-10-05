from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from api.ads import router as ads_router
from database import Base, engine

Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="Ads Aggregation & In-App Ad Server",
    description="Unified ad platform for social media and in-app ads",
    version="0.1.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(ads_router, prefix="/api/v1")


@app.get("/health")
def health_check():
    return {"status": "ok", "service": "ads-platform"}


@app.get("/")
def root():
    return {
        "message": "Ads platform API ready",
        "docs": "/docs",
        "health": "/health",
    }
