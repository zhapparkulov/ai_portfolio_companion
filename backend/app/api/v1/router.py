from fastapi import APIRouter

from app.api.v1.routes import chat, insights, portfolio


api_router = APIRouter()
api_router.include_router(portfolio.router)
api_router.include_router(chat.router)
api_router.include_router(insights.router)
