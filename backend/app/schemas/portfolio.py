from pydantic import BaseModel, computed_field


class HoldingResponse(BaseModel):
    symbol: str
    name: str
    quantity: float
    avg_price: float
    current_price: float
    daily_change_percent: float

    @computed_field
    @property
    def value(self) -> float:
        return round(self.quantity * self.current_price, 2)


class PortfolioResponse(BaseModel):
    total_value: float
    daily_change: float
    daily_change_percent: float
    holdings: list[HoldingResponse]
