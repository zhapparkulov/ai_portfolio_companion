import asyncio
import random
import re
from collections.abc import AsyncIterator
from typing import Optional

from app.data.mock_data import PORTFOLIO_SNAPSHOT


# -------------------------------------------------------------------------
# 1. Intent Detection
# -------------------------------------------------------------------------

INTENT_KEYWORDS = {
    "performance": [
        "performance",
        "how doing",
        "profit",
        "return",
        "gain",
        "loss",
        "up or down",
        "доходност",
        "прибыл",
        "убыток",
        "как дела",
    ],
    "risk": [
        "risk",
        "safe",
        "danger",
        "volatility",
        "drawdown",
        "риск",
        "опасно",
        "волатил",
    ],
    "diversification": [
        "diversif",
        "concentrat",
        "weight",
        "allocation",
        "диверсифи",
        "концентрац",
        "аллокаци",
    ],
    "biggest_holding": [
        "biggest",
        "largest",
        "top holding",
        "самая большая",
        "крупнейш",
        "топ",
    ],
    "best_performer": [
        "best",
        "highest return",
        "winner",
        "лучш",
        "победител",
    ],
    "worst_performer": [
        "worst",
        "loser",
        "drag",
        "худш",
        "просевш",
    ],
    "tech_exposure": [
        "tech",
        "technology",
        "apple",
        "nvidia",
        "tesla",
        "google",
        "тех",
        "айт",
        "it",
        "тесла",
        "эппл",
    ],
    "daily_change": [
        "today",
        "daily",
        "24h",
        "сегодня",
        "за день",
    ],
    "rebalancing": [
        "rebalance",
        "sell",
        "buy",
        "adjust",
        "ребаланс",
        "купить",
        "продать",
    ],
    "crypto_exposure": [
        "crypto",
        "bitcoin",
        "btc",
        "eth",
        "крипт",
        "биткоин",
    ],
}

CYRILLIC_RE = re.compile(r"[а-яА-ЯёЁ]")


def detect_language(message: str) -> str:
    if CYRILLIC_RE.search(message):
        return "ru"
    return "en"


def detect_intent(message: str) -> str:
    msg_lower = message.lower()
    for intent, keywords in INTENT_KEYWORDS.items():
        if any(kw in msg_lower for kw in keywords):
            return intent
    return "general_advice"


# -------------------------------------------------------------------------
# 2. Response Generation
# -------------------------------------------------------------------------


def generate_responses_for_intent(
    intent: str,
    portfolio: dict,
    language: str,
) -> list[str]:
    """
    Generate word chunks for a specific intent and language.

    The mock AI has 55 English and 55 Russian variations across 11 intents.
    This keeps the endpoint realistic without requiring a provider API key.
    """
    total_val = portfolio["total_value"]
    daily_change = portfolio["daily_change"]
    daily_pct = portfolio["daily_change_percent"]
    holdings = portfolio["holdings"]

    sorted_by_val = sorted(
        holdings,
        key=lambda item: item["quantity"] * item["current_price"],
        reverse=True,
    )
    sorted_by_perf = sorted(
        holdings,
        key=lambda item: item["daily_change_percent"],
        reverse=True,
    )

    biggest = sorted_by_val[0]
    best = sorted_by_perf[0]
    worst = sorted_by_perf[-1]

    responses_by_language = {
        "en": _english_responses(
            total_val,
            daily_change,
            daily_pct,
            biggest,
            best,
            worst,
        ),
        "ru": _russian_responses(
            total_val,
            daily_change,
            daily_pct,
            biggest,
            best,
            worst,
        ),
    }

    responses = responses_by_language.get(language, responses_by_language["en"])
    selected_text = random.choice(responses.get(intent, responses["general_advice"]))

    return [word + " " for word in selected_text.split(" ")]


def _english_responses(
    total_val: float,
    daily_change: float,
    daily_pct: float,
    biggest: dict,
    best: dict,
    worst: dict,
) -> dict[str, list[str]]:
    return {
        "performance": [
            f"Your portfolio is currently valued at ${total_val:,.2f}. Overall, you're looking solid with steady growth.",
            f"Things are moving well. The total stands at ${total_val:,.2f}, reflecting your recent strategic holdings.",
            f"Currently sitting at ${total_val:,.2f}. Your strategy is holding up against market pressure.",
            f"Portfolio valuation is ${total_val:,.2f}. You've maintained a steady growth trajectory.",
            f"With a total value of ${total_val:,.2f}, your long-term performance remains robust.",
        ],
        "daily_change": [
            f"Today's change is +${daily_change:,.2f} ({daily_pct}%). A good day for the markets.",
            f"You're up {daily_pct}% today, which translates to a gain of ${daily_change:,.2f}.",
            f"Market movement pushed your portfolio up by ${daily_change:,.2f} today.",
            f"Your daily return is sitting at +{daily_pct}%. Keep an eye on the momentum.",
            f"Today added ${daily_change:,.2f} to your total value. Tech seems to be leading the charge.",
        ],
        "biggest_holding": [
            f"Your largest holding is {biggest['symbol']} ({biggest['name']}). It makes up a significant part of your funds.",
            f"By weight, {biggest['symbol']} dominates your portfolio right now.",
            f"You are heavily invested in {biggest['symbol']}. It is currently trading at ${biggest['current_price']}.",
            f"{biggest['name']} is your top asset. Monitoring its earnings reports is important.",
            f"Most of your capital is parked in {biggest['symbol']}. It moves the needle the most.",
        ],
        "best_performer": [
            f"{best['symbol']} is your best performer today, up {best['daily_change_percent']}%.",
            f"The winner today is clearly {best['symbol']} with a solid {best['daily_change_percent']}% gain.",
            f"{best['name']} is leading the pack right now. It is up {best['daily_change_percent']}%.",
            f"Your top gainer is {best['symbol']}. Great timing on holding that one.",
            f"Look at {best['symbol']} go. A {best['daily_change_percent']}% move today.",
        ],
        "worst_performer": [
            f"{worst['symbol']} is lagging today, showing a change of {worst['daily_change_percent']}%.",
            f"The biggest drag on your portfolio today is {worst['symbol']} ({worst['daily_change_percent']}%). Nothing to panic about yet.",
            f"{worst['symbol']} is down {worst['daily_change_percent']}% today. It may be worth watching.",
            f"{worst['name']} is your weakest performer right now.",
            f"Watch {worst['symbol']}. It is currently at {worst['daily_change_percent']}% for the day.",
        ],
        "tech_exposure": [
            "You have large tech exposure through AAPL, MSFT, and NVDA. It is good for growth, but it raises portfolio beta.",
            "Tech is the core of your portfolio. Consider diversifying to lower sector risk.",
            "With AAPL, MSFT, and NVDA, your portfolio behaves a lot like a concentrated Nasdaq basket.",
            "Your tech allocation is helping returns, but sector rotation could create volatility.",
            "Tech companies dominate your holdings. Profitable, yes, but diversification is limited.",
        ],
        "diversification": [
            "Your portfolio is heavily concentrated in mega-cap tech. Consider index funds or bonds for balance.",
            "You currently lack exposure to healthcare, financials, and emerging markets.",
            "Diversification is low. A sector-wide tech correction could affect you meaningfully.",
            "To improve risk-adjusted returns, you may want to diversify beyond five growth stocks.",
            "You are very concentrated. Spreading capital across sectors can reduce single-theme risk.",
        ],
        "risk": [
            "Your risk profile is aggressive because you are highly exposed to tech volatility.",
            "Given your concentration, portfolio beta is likely above market level. Expect larger swings.",
            "High risk, high reward. Heavy NVDA and TSLA positions add meaningful volatility.",
            "To lower risk, consider trimming some winners and adding defensive sectors.",
            "Your risk is concentrated. Fine for a long horizon, but be prepared for drawdowns.",
        ],
        "rebalancing": [
            "It may be time to take some profits from NVDA and reallocate gradually.",
            "Rebalancing usually means trimming winners and adding to underweight areas.",
            "No urgent rebalance is needed unless target allocations drifted by more than 5%.",
            f"If you rebalance, consider reducing {best['symbol']} and reviewing {worst['symbol']}.",
            "A quarterly rebalance strategy would fit this concentrated portfolio well.",
        ],
        "crypto_exposure": [
            "You currently have no crypto exposure in this portfolio.",
            "I do not see Bitcoin or Ethereum in your holdings. This is a stock-only portfolio.",
            "You have no crypto assets. A small allocation would be a separate risk decision.",
            "Zero crypto. If interested, you would need to allocate new capital to digital assets.",
            "You are fully in traditional equities, so there is no direct crypto risk here.",
        ],
        "general_advice": [
            f"Overall, your portfolio of ${total_val:,.2f} looks strong. Stay disciplined.",
            "I can help analyze risk, performance, diversification, or specific holdings.",
            "Your investments represent an aggressive growth strategy with clear tech concentration.",
            "Keep investing regularly. Time in the market usually beats timing the market.",
            "Ask me about a specific holding, sector exposure, or today's portfolio movement.",
        ],
    }


def _russian_responses(
    total_val: float,
    daily_change: float,
    daily_pct: float,
    biggest: dict,
    best: dict,
    worst: dict,
) -> dict[str, list[str]]:
    return {
        "performance": [
            f"Сейчас стоимость портфеля составляет ${total_val:,.2f}. В целом динамика выглядит устойчиво.",
            f"Портфель держится хорошо: общий баланс сейчас ${total_val:,.2f}. Стратегия роста пока работает.",
            f"Текущая оценка портфеля — ${total_val:,.2f}. Просадки критичной не видно.",
            f"Ваш портфель сейчас на уровне ${total_val:,.2f}. Движение выглядит аккуратным и здоровым.",
            f"При общей стоимости ${total_val:,.2f} долгосрочная картина остается сильной.",
        ],
        "daily_change": [
            f"За сегодня портфель вырос на ${daily_change:,.2f}, это примерно +{daily_pct}%. Хороший день.",
            f"Сегодня вы в плюсе на {daily_pct}%, что равно примерно ${daily_change:,.2f}.",
            f"Дневное изменение положительное: +${daily_change:,.2f}. Основной вклад дает tech-сектор.",
            f"Сегодняшняя доходность около +{daily_pct}%. Импульс выглядит сильным, но его стоит отслеживать.",
            f"За день портфель добавил ${daily_change:,.2f}. Пока рынок двигается в вашу сторону.",
        ],
        "biggest_holding": [
            f"Самая крупная позиция сейчас — {biggest['symbol']} ({biggest['name']}). Она сильнее всего влияет на портфель.",
            f"По весу в портфеле лидирует {biggest['symbol']}. Это главный драйвер общей динамики.",
            f"У вас заметная доля в {biggest['symbol']}. Текущая цена около ${biggest['current_price']}.",
            f"{biggest['name']} — ваш крупнейший актив. За отчетами этой компании стоит следить особенно внимательно.",
            f"Больше всего капитала сейчас сосредоточено в {biggest['symbol']}. Эта позиция сильнее всего двигает результат.",
        ],
        "best_performer": [
            f"Лучший результат сегодня показывает {best['symbol']}: рост на {best['daily_change_percent']}%.",
            f"Сегодня главный победитель — {best['symbol']} с движением +{best['daily_change_percent']}%.",
            f"{best['name']} сейчас впереди остальных позиций и растет на {best['daily_change_percent']}%.",
            f"Топ-гейнер портфеля — {best['symbol']}. Позиция хорошо поддерживает дневной результат.",
            f"{best['symbol']} сегодня выглядит сильнее остальных: +{best['daily_change_percent']}%.",
        ],
        "worst_performer": [
            f"Слабее всех сегодня выглядит {worst['symbol']}: изменение {worst['daily_change_percent']}%.",
            f"Главный минусовой вклад сейчас дает {worst['symbol']} ({worst['daily_change_percent']}%). Паниковать пока рано.",
            f"{worst['symbol']} сегодня проседает на {worst['daily_change_percent']}%. Лучше понаблюдать за причиной движения.",
            f"{worst['name']} сейчас самая слабая позиция в портфеле.",
            f"Обратите внимание на {worst['symbol']}: дневное изменение сейчас {worst['daily_change_percent']}%.",
        ],
        "tech_exposure": [
            "У вас высокая экспозиция в tech через AAPL, MSFT и NVDA. Это хорошо для роста, но повышает риск.",
            "Tech фактически является ядром портфеля. Для снижения секторного риска стоит подумать о диверсификации.",
            "С AAPL, MSFT и NVDA портфель ведет себя как концентрированная ставка на Nasdaq.",
            "Технологические позиции дают сильную доходность, но секторная ротация может добавить волатильности.",
            "Tech-компании доминируют в портфеле. Это прибыльно, но диверсификация сейчас ограничена.",
        ],
        "diversification": [
            "Портфель сильно сконцентрирован в крупных tech-компаниях. Для баланса можно добавить индексные фонды или облигации.",
            "Сейчас почти нет экспозиции в healthcare, financials и emerging markets.",
            "Диверсификация низкая. Если tech-сектор скорректируется, портфель может заметно просесть.",
            "Чтобы улучшить риск-доходность, стоит выйти за рамки нескольких growth-акций.",
            "Концентрация высокая. Распределение капитала по секторам снизит риск одной инвестиционной идеи.",
        ],
        "risk": [
            "Профиль риска агрессивный: портфель сильно зависит от волатильности технологического сектора.",
            "Из-за концентрации beta портфеля, вероятно, выше рынка. Значит, колебания могут быть сильнее.",
            "Риск высокий, но и потенциал роста высокий. Особенно из-за заметных долей NVDA и TSLA.",
            "Чтобы снизить риск, можно частично зафиксировать прибыль и добавить защитные сектора.",
            "Риск сконцентрирован. Для длинного горизонта это допустимо, но к просадкам нужно быть готовым.",
        ],
        "rebalancing": [
            "Можно рассмотреть постепенную фиксацию части прибыли в NVDA и перераспределение в более защитные активы.",
            "Ребалансировка обычно означает сократить выросшие позиции и добавить туда, где вес ниже целевого.",
            "Срочной ребалансировки не видно, если ваши целевые доли не ушли больше чем на 5%.",
            f"Если ребалансировать сейчас, можно пересмотреть долю {best['symbol']} и внимательно оценить {worst['symbol']}.",
            "Квартальная ребалансировка хорошо подошла бы для такого концентрированного портфеля.",
        ],
        "crypto_exposure": [
            "Сейчас в этом портфеле нет криптоэкспозиции.",
            "Я не вижу Bitcoin или Ethereum среди активов. Портфель полностью состоит из акций.",
            "Криптоактивов нет. Небольшая доля BTC была бы отдельным решением по риску.",
            "Крипты сейчас ноль. Если интересно, под это нужно выделять отдельный капитал.",
            "Портфель полностью в традиционных акциях, прямого крипториска здесь нет.",
        ],
        "general_advice": [
            f"В целом портфель на ${total_val:,.2f} выглядит сильным. Главное — сохранять дисциплину.",
            "Я могу помочь разобрать риск, доходность, диверсификацию или отдельные позиции.",
            "Стратегия выглядит как агрессивный рост с явной концентрацией в tech-секторе.",
            "Регулярность важнее попыток поймать идеальный момент входа. Время в рынке часто выигрывает.",
            "Спросите меня про конкретную акцию, секторную экспозицию или сегодняшнее движение портфеля.",
        ],
    }


# -------------------------------------------------------------------------
# 3. Streaming Engine
# -------------------------------------------------------------------------


async def stream_llm_response(
    message: str,
    conversation_id: Optional[str] = None,
) -> AsyncIterator[str]:
    """Stream a contextual mock AI response chunk by chunk."""
    del conversation_id

    intent = detect_intent(message)
    language = detect_language(message)
    chunks = generate_responses_for_intent(intent, PORTFOLIO_SNAPSHOT, language)

    await asyncio.sleep(0.3)

    for chunk in chunks:
        delay = random.uniform(0.02, 0.08)
        await asyncio.sleep(delay)
        yield chunk
