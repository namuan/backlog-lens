from pydantic_settings import BaseSettings
from typing import Optional


class Settings(BaseSettings):
    # Database
    DATABASE_URL: str = "postgresql://jira:changeme@localhost:5432/jira_intel"
    
    # Security
    JWT_SECRET: str = "your-super-secret-jwt-key-change-this-in-production"
    ENCRYPTION_KEY: str = "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"
    JWT_ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24  # 24 hours
    
    # Application
    APP_NAME: str = "JIRA Intelligence"
    APP_ENV: str = "development"
    LOG_LEVEL: str = "info"
    
    # Email (optional)
    SMTP_HOST: Optional[str] = None
    SMTP_PORT: Optional[int] = None
    SMTP_USER: Optional[str] = None
    SMTP_PASSWORD: Optional[str] = None
    
    # Feature flags
    ENABLE_SLACK: bool = False
    ENABLE_EMAIL_REPORTS: bool = False
    
    class Config:
        env_file = ".env"
        case_sensitive = True


settings = Settings()
