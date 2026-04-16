import asyncio
import random
from collections.abc import AsyncIterator
from typing import Optional

from app.data.mock_data import PORTFOLIO_SNAPSHOT

# -------------------------------------------------------------------------
# 1. Intent Detection
# -------------------------------------------------------------------------

INTENT_KEYWORDS = {
    "performance": ["performance", "how doing", "profit", "return", "gain", "loss", "up or down", "доходност", "прибыл", "убыток", "как дела"],
    "risk": ["risk", "safe", "danger", "volatility", "drawdown", "риск", "опасно", "волатил"],
    "diversification": ["diversif", "concentrat", "weight", "allocation", "диверсифи", "концентрац", "аллокаци"],
    "biggest_holding": ["biggest", "largest", "top holding", "самая большая", "крупнейш", "топ"],
    "best_performer": ["best", "highest return", "winner", "лучш", "победител"],
    "worst_performer": ["worst", "loser", "drag", "худш", "просевш"],
    "tech_exposure": ["tech", "technology", "apple", "nvidia", "tesla", "google", "тех", "айт", "it", "тесла", "эппл"],
    "daily_change": ["today", "daily", "24h", "сегодня", "за день"],
    "rebalancing": ["rebalance", "sell", "buy", "adjust", "ребаланс", "купить", "продать"],
    "crypto_exposure": ["crypto", "bitcoin", "btc", "eth", "крипт", "биткоин"],
}

def detect_intent(message: str) -> str:
    msg_lower = message.lower()
    for intent, keywords in INTENT_KEYWORDS.items():
        if any(kw in msg_lower for kw in keywords):
            return intent
    return "general_advice"

# -------------------------------------------------------------------------
# 2. Response Generation
# -------------------------------------------------------------------------

def generate_responses_for_intent(intent: str, portfolio: dict) -> list[str]:
    """
    Generates a list of strings (chunks) for a specific intent based on portfolio data.
    There are 55 total variations across 11 intents.
    """
    total_val = portfolio["total_value"]
    daily_change = portfolio["daily_change"]
    daily_pct = portfolio["daily_change_percent"]
    holdings = portfolio["holdings"]
    
    # Sort holdings for context
    sorted_by_val = sorted(holdings, key=lambda x: x["quantity"] * x["current_price"], reverse=True)
    sorted_by_perf = sorted(holdings, key=lambda x: x["daily_change_percent"], reverse=True)
    
    biggest = sorted_by_val[0]
    best = sorted_by_perf[0]
    worst = sorted_by_perf[-1]

    responses = {
        "performance": [
            f"Your portfolio is currently valued at ${total_val:,.2f}. Overall, you're looking solid with a nice steady growth.",
            f"Things are moving well. The total stands at ${total_val:,.2f}, reflecting your recent strategic holdings.",
            f"Currently sitting at ${total_val:,.2f}. Your strategy is holding up against market pressures.",
            f"Portfolio valuation is ${total_val:,.2f}. You've maintained a steady growth trajectory.",
            f"With a total value of ${total_val:,.2f}, your long-term performance remains robust.",
        ],
        "daily_change": [
            f"Today's change is +${daily_change:,.2f} ({daily_pct}%). A good day for the markets!",
            f"You're up {daily_pct}% today, which translates to a gain of ${daily_change:,.2f}.",
            f"Market movements pushed your portfolio up by ${daily_change:,.2f} today. Not bad!",
            f"Your daily return is sitting at +{daily_pct}%. Keep an eye on the momentum.",
            f"Today added ${daily_change:,.2f} to your total value. Tech seems to be leading the charge.",
        ],
        "biggest_holding": [
            f"Your largest holding is {biggest['symbol']} ({biggest['name']}). It makes up a significant chunk of your funds.",
            f"By weight, {biggest['symbol']} dominates your portfolio right now.",
            f"You are heavily invested in {biggest['symbol']}. It's currently trading at ${biggest['current_price']}.",
            f"{biggest['name']} is your top asset. Monitoring its earnings reports is crucial for you.",
            f"Most of your capital is parked in {biggest['symbol']}. It's moving the needle the most.",
        ],
        "best_performer": [
            f"{best['symbol']} is your best performer today, up {best['daily_change_percent']}%!",
            f"The winner today is clearly {best['symbol']} with a solid {best['daily_change_percent']}% gain.",
            f"{best['name']} is leading the pack right now. It's up {best['daily_change_percent']}%.",
            f"Your top gainer is {best['symbol']}. Great timing on holding that one.",
            f"Look at {best['symbol']} go! A {best['daily_change_percent']}% surge today.",
        ],
        "worst_performer": [
            f"{worst['symbol']} is lagging today, showing a change of {worst['daily_change_percent']}%.",
            f"The biggest drag on your portfolio today is {worst['symbol']} ({worst['daily_change_percent']}%). Nothing to panic about yet.",
            f"Unfortunately, {worst['symbol']} is down {worst['daily_change_percent']}% today. Might be a buying opportunity.",
            f"{worst['name']} is your worst performer right now.",
            f"Watch out for {worst['symbol']}, it's currently at {worst['daily_change_percent']}% for the day.",
        ],
        "tech_exposure": [
            f"You have massive tech exposure (AAPL, MSFT, NVDA). It's great for growth but implies higher beta.",
            f"Tech is basically your entire portfolio. Consider diversifying to lower your systemic risk.",
            f"With AAPL, MSFT, and NVDA, you're essentially running a Nasdaq-100 mimic.",
            f"Your tech allocations are providing strong returns, but watch out for sector rotation.",
            f"Tech companies dominate your holdings. While profitable, this reduces diversification.",
        ],
        "diversification": [
            f"Your portfolio is heavily concentrated in mega-cap tech. Consider adding index funds or bonds.",
            f"You lack exposure to healthcare, financials, and emerging markets.",
            f"Diversification is low. A sector-wide tech correction could hit you hard.",
            f"To improve your Sharpe ratio, you might want to diversify beyond just 5 tech stocks.",
            f"You are very concentrated. Think about spreading your investments to mitigate idiosyncratic risk.",
        ],
        "risk": [
            f"Your risk profile is aggressive. You are highly exposed to tech volatility.",
            f"Given your concentration, your portfolio's beta is likely > 1.2. Expect larger swings.",
            f"High risk, high reward. Your heavy NVDA and TSLA positions add significant volatility.",
            f"To lower your risk, consider trimming your biggest winners and buying defensive sectors.",
            f"Your risk is concentrated. It's fine for a long horizon, but be prepared for drawdowns.",
        ],
        "rebalancing": [
            f"It might be time to take some profits off NVDA and reallocate.",
            f"Rebalancing usually means selling what went up and buying what went down. Consider trimming your top tech.",
            f"No immediate need to rebalance unless your target allocations have drifted by >5%.",
            f"If you want to rebalance, look at reducing {best['symbol']} and adding to {worst['symbol']}.",
            f"A quarterly rebalance strategy would work well for this concentrated portfolio.",
        ],
        "crypto_exposure": [
            f"You currently have absolutely zero crypto exposure in this portfolio.",
            f"I don't see any Bitcoin or Ethereum in your holdings. It's a 100% stock portfolio.",
            f"You have no crypto assets. Adding 1-5% BTC could provide uncorrelated returns.",
            f"Zero crypto. If you're interested, you'd need to allocate new capital to digital assets.",
            f"You are fully in traditional equities. No crypto risk here.",
        ],
        "general_advice": [
            f"Overall, your portfolio of ${total_val:,.2f} looks strong. Stay the course.",
            f"I'm here to help you analyze your portfolio. You can ask me about risks, performance, or specific holdings.",
            f"Your investments represent a solid, aggressive growth strategy.",
            f"Keep investing regularly. Time in the market beats timing the market.",
            f"Is there a specific aspect of your portfolio you'd like me to dive into?",
        ]
    }
    
    selected_text = random.choice(responses.get(intent, responses["general_advice"]))
    
    # Split text into small chunks with spaces to simulate streaming by word/token
    words = selected_text.split(" ")
    return [word + " " for word in words]

# -------------------------------------------------------------------------
# 3. Streaming Engine
# -------------------------------------------------------------------------

async def stream_llm_response(
    message: str,
    conversation_id: Optional[str] = None,
) -> AsyncIterator[str]:
    """Streams a contextual AI response chunk by chunk."""
    del conversation_id  # Ignored for mock

    intent = detect_intent(message)
    chunks = generate_responses_for_intent(intent, PORTFOLIO_SNAPSHOT)

    # Initial thinking delay
    await asyncio.sleep(0.3)
    
    for chunk in chunks:
        # Simulate typing/network latency realistically
        delay = random.uniform(0.02, 0.08)
        await asyncio.sleep(delay)
        yield chunk
