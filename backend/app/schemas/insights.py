from typing import Literal, Optional

from pydantic import BaseModel, Field


InsightSeverity = Literal["priority", "info", "positive", "risk"]


class InsightAction(BaseModel):
    label: str
    primary: bool = False


class InsightResponse(BaseModel):
    title: str
    body: str
    severity: InsightSeverity
    badge_label: Optional[str] = None
    meta: Optional[str] = None
    highlight: Optional[str] = None
    actions: list[InsightAction] = Field(default_factory=list)


class InsightsResponse(BaseModel):
    insights: list[InsightResponse]
