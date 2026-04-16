import asyncio
from collections.abc import AsyncIterator
from typing import Optional


async def stream_llm_response(
    message: str,
    conversation_id: Optional[str] = None,
) -> AsyncIterator[str]:
    del conversation_id

    lower_message = message.lower()
    chunks = _risk_response() if _asks_about_risk(lower_message) else _default_response()

    for chunk in chunks:
        await asyncio.sleep(0.08)
        yield chunk


def _asks_about_risk(message: str) -> bool:
    keywords = ("risk", "tech", "exposure", "риск", "тех", "экспози")
    return any(keyword in message for keyword in keywords)


def _risk_response() -> list[str]:
    return [
        "Your portfolio is currently ",
        "65% tech-heavy. ",
        "AAPL, MSFT and NVDA drive most of the upside, ",
        "but downside risk is concentrated in one sector. ",
        "Consider shifting 7% toward healthcare or dividend-income assets.",
    ]


def _default_response() -> list[str]:
    return [
        "Your portfolio is up today. ",
        "The strongest contribution comes from mega-cap technology, ",
        "while dividend holdings are keeping volatility lower. ",
        "Keep winners, but rebalance gradually if tech exceeds your target range.",
    ]
