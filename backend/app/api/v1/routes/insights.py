from fastapi import APIRouter

from app.schemas.insights import InsightsResponse
from app.services.insights_service import get_insights


router = APIRouter(tags=["insights"])


@router.get("/insights", response_model=InsightsResponse)
async def insights() -> InsightsResponse:
    return get_insights()
