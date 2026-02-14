from sqlalchemy import Column, String, Boolean, TIMESTAMP, ForeignKey, text
from sqlalchemy.dialects.postgresql import UUID, JSONB
from app.core.database import Base
import uuid


class User(Base):
    __tablename__ = "users"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    tenant_id = Column(UUID(as_uuid=True), ForeignKey("tenants.id", ondelete="CASCADE"), nullable=False)
    email = Column(String(255), nullable=False)
    hashed_password = Column(String(255))
    full_name = Column(String(255))
    role = Column(String(50), nullable=False, default='user')
    preferences = Column(JSONB, default={})
    created_at = Column(TIMESTAMP, server_default=text('CURRENT_TIMESTAMP'))
    last_login_at = Column(TIMESTAMP)
    is_active = Column(Boolean, default=True)
