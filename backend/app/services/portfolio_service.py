from typing import Optional

from app.repositories.portfolio_repository import PortfolioRepository
from app.schemas.portfolio import HoldingResponse, PortfolioResponse


def get_portfolio(
    repository: Optional[PortfolioRepository] = None,
) -> PortfolioResponse:
    portfolio_repository = repository or PortfolioRepository()
    snapshot = portfolio_repository.get_snapshot()

    holdings = [
        HoldingResponse(
            symbol=item["symbol"],
            name=item["name"],
            quantity=item["quantity"],
            avg_price=item["avg_price"],
            current_price=item["current_price"],
            daily_change_percent=item["daily_change_percent"],
        )
        for item in snapshot["holdings"]
    ]

    return PortfolioResponse(
        total_value=snapshot["total_value"],
        daily_change=snapshot["daily_change"],
        daily_change_percent=snapshot["daily_change_percent"],
        holdings=holdings,
    )
