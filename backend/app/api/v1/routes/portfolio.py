from fastapi import APIRouter

from app.schemas.portfolio import PortfolioResponse
from app.services.portfolio_service import get_portfolio


router = APIRouter(tags=["portfolio"])


@router.get("/portfolio", response_model=PortfolioResponse)
async def portfolio() -> PortfolioResponse:
    return get_portfolio()
