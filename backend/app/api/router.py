from fastapi import APIRouter
from app.api.endpoints import auth

api_router = APIRouter()

api_router.include_router(auth.router, prefix="/auth", tags=["auth"])

@api_router.get("/health")
async def health_check():
    """Health check endpoint"""
    return {"status": "healthy"}
