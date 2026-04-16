from copy import deepcopy
from typing import Any

from app.data.mock_data import PORTFOLIO_SNAPSHOT


class PortfolioRepository:
    def get_snapshot(self) -> dict[str, Any]:
        return deepcopy(PORTFOLIO_SNAPSHOT)
