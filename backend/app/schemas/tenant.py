from pydantic import BaseModel, UUID4
from typing import Optional
from datetime import datetime


class TenantBase(BaseModel):
    name: str
    slug: str


class TenantCreate(TenantBase):
    plan_type: str = "free"


class TenantResponse(TenantBase):
    id: UUID4
    plan_type: str
    is_active: bool
    created_at: datetime
    
    class Config:
        from_attributes = True
