import os
from enum import Enum
from typing import Optional

from pydantic_settings import BaseSettings


class EnvironmentType(str, Enum):
    DEV = "development"
    TEST = "test"
    PROD = "production"


def _normalize_env(value: Optional[str]) -> EnvironmentType:
    """
    Accepts common variants like: dev/development, test/testing, prod/production.
    Defaults to DEV when unset or unrecognized.
    """
    if not value:
        return EnvironmentType.DEV
    v = value.strip().lower()
    if v in {"prod", "production"}:
        return EnvironmentType.PROD
    if v in {"test", "testing"}:
        return EnvironmentType.TEST
    # default
    return EnvironmentType.DEV


class Settings(BaseSettings):
    APP_NAME: str = "hello-api"

    # We’ll set ENVIRONMENT from env in get_settings() using _normalize_env.
    ENVIRONMENT: EnvironmentType = EnvironmentType.DEV

    # Optional DB URL loaded from env/.env if present. For non-prod we default to in-memory.
    DATABASE_URL: Optional[str] = None

    @property
    def db_url(self) -> str:
        """
        - PROD  -> require DATABASE_URL (fail fast if missing)
        - non-PROD -> default to in-memory SQLite unless DATABASE_URL is explicitly provided
        """
        # Pydantic already loaded env-file keys into self.DATABASE_URL if present.
        explicit = self.DATABASE_URL or os.getenv("DATABASE_URL")

        if self.ENVIRONMENT == EnvironmentType.PROD:
            if not explicit:
                raise RuntimeError(
                    "DATABASE_URL must be set in production (ENVIRONMENT=production)."
                )
            return explicit

        # DEV/TEST: default to in-memory; allow overriding with DATABASE_URL if provided
        return explicit or "sqlite:///:memory:"

    class Config:
        env_file = ".env"
        env_file_encoding = "utf-8"


def get_settings() -> Settings:
    # Prefer APP_ENVIRONMENT, fallback to ENVIRONMENT, then default
    raw_env = os.getenv("APP_ENVIRONMENT", os.getenv("ENVIRONMENT", "development"))
    return Settings(ENVIRONMENT=_normalize_env(raw_env))