from typing import Optional

from app.repositories.portfolio_repository import PortfolioRepository
from app.schemas.insights import InsightAction, InsightResponse, InsightsResponse
from app.services.portfolio_service import get_portfolio


def get_insights(
    repository: Optional[PortfolioRepository] = None,
) -> InsightsResponse:
    portfolio = get_portfolio(repository or PortfolioRepository())
    tech_symbols = {"AAPL", "MSFT", "NVDA", "GOOGL", "TSLA"}
    holdings_value = sum(holding.value for holding in portfolio.holdings)
    tech_value = sum(
        holding.value
        for holding in portfolio.holdings
        if holding.symbol in tech_symbols
    )
    tech_exposure = (tech_value / holdings_value * 100) if holdings_value else 0

    insights = [
        InsightResponse(
            title="Rebalancing Opportunity",
            badge_label="PRIORITY",
            severity="priority",
            body=(
                f"Your Tech exposure is about {tech_exposure:.0f}% of tracked "
                "holdings. Consider shifting 7% into Consumer Staples or "
                "Healthcare to reduce sector concentration."
            ),
            actions=[
                InsightAction(label="Execute Rebalance", primary=True),
            ],
        ),
        InsightResponse(
            title="Market Trend",
            meta="2h ago",
            severity="info",
            body=(
                "Recent rate expectations suggest a more stable environment "
                "for dividend-income assets and short-duration Treasuries."
            ),
            highlight="Portfolio volatility reduced by 0.4%",
        ),
        InsightResponse(
            title="Dividend Alert +20.50",
            severity="positive",
            body=(
                "Three of your core holdings are expected to announce dividend "
                "payments next Tuesday."
            ),
            actions=[
                InsightAction(label="Set to Reinvest", primary=True),
                InsightAction(label="View Schedule"),
            ],
        ),
    ]

    return InsightsResponse(insights=insights)
