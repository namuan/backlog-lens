-- JIRA Backlog Intelligence Platform - Initial Schema
-- Version: 1.0
-- Date: 2026-02-14

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================================
-- CORE TABLES
-- ============================================================================

-- Tenants table
CREATE TABLE tenants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    plan_type VARCHAR(50) NOT NULL DEFAULT 'free',
    settings JSONB DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT true
);

-- Users table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    email VARCHAR(255) NOT NULL,
    hashed_password VARCHAR(255),
    full_name VARCHAR(255),
    role VARCHAR(50) NOT NULL DEFAULT 'user', -- 'admin', 'manager', 'user'
    preferences JSONB DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login_at TIMESTAMP,
    is_active BOOLEAN DEFAULT true,
    
    UNIQUE(tenant_id, email)
);

-- Indexes for users
CREATE INDEX idx_users_tenant ON users(tenant_id);
CREATE INDEX idx_users_email ON users(email);

-- Teams
CREATE TABLE teams (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    lead_id UUID REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(tenant_id, name)
);

-- Team members
CREATE TABLE team_members (
    team_id UUID REFERENCES teams(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (team_id, user_id)
);

-- JIRA connections
CREATE TABLE jira_connections (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    instance_type VARCHAR(20) NOT NULL, -- 'cloud' or 'server'
    instance_url VARCHAR(500) NOT NULL,
    encrypted_token TEXT NOT NULL, -- Encrypted API token
    is_default BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_used_at TIMESTAMP,
    
    UNIQUE(user_id, instance_url)
);

-- Projects cache (to avoid repeated API calls)
CREATE TABLE projects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    jira_connection_id UUID REFERENCES jira_connections(id) ON DELETE CASCADE,
    project_key VARCHAR(100) NOT NULL,
    project_name VARCHAR(500),
    last_synced_at TIMESTAMP,
    is_active BOOLEAN DEFAULT true,
    
    UNIQUE(tenant_id, project_key, jira_connection_id)
);

-- Issues cache
CREATE TABLE issues (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    jira_connection_id UUID REFERENCES jira_connections(id) ON DELETE CASCADE,
    project_key VARCHAR(100) NOT NULL,
    issue_key VARCHAR(100) NOT NULL,
    issue_type VARCHAR(100),
    summary TEXT,
    description TEXT,
    status VARCHAR(100),
    priority VARCHAR(50),
    labels TEXT[],
    components TEXT[],
    assignee VARCHAR(255),
    reporter VARCHAR(255),
    created_date TIMESTAMP,
    updated_date TIMESTAMP,
    raw_data JSONB, -- Store additional fields
    last_synced_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(tenant_id, issue_key, jira_connection_id)
);

-- Indexes for issues
CREATE INDEX idx_issues_tenant ON issues(tenant_id);
CREATE INDEX idx_issues_project ON issues(project_key);
CREATE INDEX idx_issues_type ON issues(issue_type);
CREATE INDEX idx_issues_status ON issues(status);

-- Analyses
CREATE TABLE analyses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id),
    jira_connection_id UUID REFERENCES jira_connections(id),
    name VARCHAR(255),
    jql_query TEXT,
    project_keys TEXT[],
    threshold FLOAT DEFAULT 0.7,
    status VARCHAR(50) DEFAULT 'pending',
    progress INTEGER DEFAULT 0,
    total_issues INTEGER,
    issues_analyzed INTEGER DEFAULT 0,
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Similar pairs (results)
CREATE TABLE similar_pairs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    analysis_id UUID NOT NULL REFERENCES analyses(id) ON DELETE CASCADE,
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    issue_key_1 VARCHAR(100) NOT NULL,
    issue_key_2 VARCHAR(100) NOT NULL,
    issue_summary_1 TEXT,
    issue_summary_2 TEXT,
    issue_url_1 TEXT,
    issue_url_2 TEXT,
    similarity_score FLOAT NOT NULL,
    status VARCHAR(50) DEFAULT 'pending', -- 'pending', 'reviewed', 'duplicate', 'false_positive'
    reviewed_by UUID REFERENCES users(id),
    reviewed_at TIMESTAMP,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(analysis_id, issue_key_1, issue_key_2)
);

-- Actions taken
CREATE TABLE actions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id),
    pair_id UUID REFERENCES similar_pairs(id) ON DELETE SET NULL,
    action_type VARCHAR(50) NOT NULL, -- 'link', 'comment', 'mark_duplicate'
    status VARCHAR(50) DEFAULT 'pending',
    jira_response JSONB,
    error_message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP
);

-- Scheduled analyses
CREATE TABLE scheduled_analyses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id),
    name VARCHAR(255),
    jql_query TEXT,
    project_keys TEXT[],
    threshold FLOAT DEFAULT 0.7,
    schedule_frequency VARCHAR(50), -- 'daily', 'weekly', 'monthly'
    next_run_at TIMESTAMP,
    last_run_at TIMESTAMP,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Notifications
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id),
    type VARCHAR(50) NOT NULL, -- 'analysis_complete', 'duplicate_found', etc.
    title VARCHAR(255),
    content TEXT,
    metadata JSONB,
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Job queue (using PostgreSQL as queue)
CREATE TABLE job_queue (
    id BIGSERIAL PRIMARY KEY,
    tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE,
    job_type VARCHAR(100) NOT NULL, -- 'analysis', 'jira_sync', 'report_generation'
    payload JSONB NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    priority INTEGER DEFAULT 0,
    scheduled_for TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    error TEXT,
    retry_count INTEGER DEFAULT 0,
    max_retries INTEGER DEFAULT 3,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for job queue
CREATE INDEX idx_job_queue_status ON job_queue(status, scheduled_for) 
    WHERE status = 'pending';

-- ============================================================================
-- ENCRYPTION FUNCTIONS
-- ============================================================================

-- Function to encrypt token
CREATE OR REPLACE FUNCTION encrypt_jira_token(token TEXT, user_id UUID)
RETURNS TEXT AS $$
DECLARE
    encryption_key TEXT;
    encrypted TEXT;
BEGIN
    -- Get encryption key from environment (set via PostgreSQL config or parameter)
    -- For now, we'll use a placeholder - in production this should be set properly
    encryption_key := current_setting('app.encryption_key', true);
    IF encryption_key IS NULL THEN
        encryption_key := 'default-key-change-in-production';
    END IF;
    
    -- Encrypt using AES-256
    encrypted := encode(
        pgp_sym_encrypt(
            token,
            encryption_key || user_id::TEXT  -- User-specific salt
        ),
        'base64'
    );
    
    RETURN encrypted;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to decrypt token
CREATE OR REPLACE FUNCTION decrypt_jira_token(encrypted_token TEXT, user_id UUID)
RETURNS TEXT AS $$
DECLARE
    encryption_key TEXT;
    decrypted TEXT;
BEGIN
    encryption_key := current_setting('app.encryption_key', true);
    IF encryption_key IS NULL THEN
        encryption_key := 'default-key-change-in-production';
    END IF;
    
    decrypted := pgp_sym_decrypt(
        decode(encrypted_token, 'base64'),
        encryption_key || user_id::TEXT
    );
    
    RETURN decrypted;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- TENANT CONTEXT FUNCTIONS
-- ============================================================================

-- Function to set tenant context in application
CREATE OR REPLACE FUNCTION set_tenant_context(tenant_uuid UUID)
RETURNS VOID AS $$
BEGIN
    PERFORM set_config('app.current_tenant', tenant_uuid::TEXT, false);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================================================

-- Enable row-level security on all tenant tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE jira_connections ENABLE ROW LEVEL SECURITY;
ALTER TABLE analyses ENABLE ROW LEVEL SECURITY;
ALTER TABLE similar_pairs ENABLE ROW LEVEL SECURITY;
ALTER TABLE actions ENABLE ROW LEVEL SECURITY;
ALTER TABLE teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE issues ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Create policies for each table
CREATE POLICY tenant_isolation_users ON users
    USING (tenant_id::TEXT = current_setting('app.current_tenant', true));

CREATE POLICY tenant_isolation_jira_connections ON jira_connections
    USING (tenant_id::TEXT = current_setting('app.current_tenant', true));

CREATE POLICY tenant_isolation_analyses ON analyses
    USING (tenant_id::TEXT = current_setting('app.current_tenant', true));

CREATE POLICY tenant_isolation_similar_pairs ON similar_pairs
    USING (tenant_id::TEXT = current_setting('app.current_tenant', true));

CREATE POLICY tenant_isolation_actions ON actions
    USING (tenant_id::TEXT = current_setting('app.current_tenant', true));

CREATE POLICY tenant_isolation_teams ON teams
    USING (tenant_id::TEXT = current_setting('app.current_tenant', true));

CREATE POLICY tenant_isolation_projects ON projects
    USING (tenant_id::TEXT = current_setting('app.current_tenant', true));

CREATE POLICY tenant_isolation_issues ON issues
    USING (tenant_id::TEXT = current_setting('app.current_tenant', true));

CREATE POLICY tenant_isolation_notifications ON notifications
    USING (tenant_id::TEXT = current_setting('app.current_tenant', true));

-- ============================================================================
-- INITIAL DATA
-- ============================================================================

-- Create a default tenant for development
INSERT INTO tenants (name, slug, plan_type, is_active)
VALUES ('Demo Organization', 'demo', 'free', true)
ON CONFLICT DO NOTHING;
