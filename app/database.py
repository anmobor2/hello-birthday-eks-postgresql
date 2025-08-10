from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker

from app.config import get_settings

settings = get_settings()
db_url = settings.db_url

# Only add SQLite-specific connect_args when needed
connect_args = {}
if db_url.startswith("sqlite"):
    # Needed for SQLite when used with multiple threads (e.g., uvicorn reload)
    connect_args = {"check_same_thread": False}

# Create engine and session factory
engine = create_engine(db_url, connect_args=connect_args)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Declarative base
Base = declarative_base()


# Dependency to get DB session per request
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


# Initialize DB schema (used at startup)
def init_db():
    Base.metadata.create_all(bind=engine)
