# JIRA Backlog Intelligence Platform - Requirements Document (RFC)

| **Document Title** | JIRA Backlog Intelligence Platform - Technical Requirements & Design Specification |
|---|---|
| **Status** | DRAFT |
| **Version** | 2.0 (Simplified) |
| **Date** | February 14, 2026 |
| **Authors** | [Your Name/Team] |
| **Classification** | Internal |

---

## Table of Contents
1. [Executive Summary](#1-executive-summary)
2. [Background & Context](#2-background--context)
3. [Goals & Success Metrics](#3-goals--success-metrics)
4. [User Personas](#4-user-personas)
5. [Functional Requirements](#5-functional-requirements)
6. [Simplified Technical Architecture](#6-simplified-technical-architecture)
7. [Multi-Tenant Design](#7-multi-tenant-design)
8. [Database Schema](#8-database-schema)
9. [Non-Functional Requirements](#9-non-functional-requirements)
10. [Security & Compliance](#10-security--compliance)
11. [User Interface](#11-user-interface)
12. [Timeline & Milestones](#12-timeline--milestones)
13. [Risks & Mitigations](#13-risks--mitigations)
14. [Appendices](#14-appendices)

---

## 1. Executive Summary

### 1.1 Overview
This document outlines the requirements for a **JIRA Backlog Intelligence Platform** – a multi-tenant web application designed to help teams analyze JIRA backlogs, identify duplicate or similar work items, and provide actionable insights through a collaborative interface.

### 1.2 Problem Statement
Organizations using JIRA at scale face significant challenges in managing backlogs across multiple teams and projects:

- **No centralized view**: Teams operate in silos, unable to see duplicate work across projects
- **Inconsistent analysis**: Manual review varies by team, leading to missed duplicates
- **Limited collaboration**: No shared insights or team-wide visibility into backlog patterns
- **Security concerns**: API keys stored locally pose security risks
- **Complexity overhead**: Existing solutions require complex infrastructure

### 1.3 Proposed Solution
A simplified multi-tenant web platform that:

- Uses **PostgreSQL for everything** (data, queues, caching)
- Allows each user to securely store their own JIRA API credentials
- Provides a unified dashboard for backlog analysis across teams
- Scales to support multiple organizations with data isolation
- Minimizes operational complexity

### 1.4 Key Benefits
- 🔒 **Secure Credential Management**: User-specific encrypted API tokens
- 👥 **Team Collaboration**: Share insights across team members
- 🚀 **Simple Architecture**: PostgreSQL-only backend, easy to deploy and maintain
- 📊 **Centralized Insights**: Cross-team duplicate detection
- 💰 **Cost-Effective**: No need for Redis, Elasticsearch, or additional queues

---

## 2. Background & Context

### 2.1 Current State
Organizations currently rely on:
- Individual CLI tools with local API key storage
- Manual backlog reviews during grooming sessions
- Spreadsheets to track potential duplicates
- No cross-team visibility into related work

### 2.2 Target Environment

| **Aspect** | **Details** |
|------------|-------------|
| **User Base** | 10-100 concurrent users |
| **Organizations** | Multiple tenants (B2B SaaS model) |
| **JIRA Instances** | Cloud & Server/Data Center |
| **Backlog Size** | 1,000-20,000 issues per tenant |
| **Deployment** | Single-region, PostgreSQL 15+ |

### 2.3 Stakeholders

| **Stakeholder** | **Primary Interest** |
|-----------------|----------------------|
| Development Teams | Clean backlogs, reduced duplicate work |
| Engineering Managers | Team efficiency metrics, cross-team visibility |
| Product Owners | Strategic backlog health, feature consolidation |
| JIRA Administrators | Security compliance, API usage monitoring |
| Platform Engineers | Simple architecture, easy maintenance |

---

## 3. Goals & Success Metrics

### 3.1 Business Goals
1. **Reduce duplicate work** by 30% across all teams within 6 months
2. **Decrease backlog grooming time** by 40% per team
3. **Achieve 80% user adoption** among target teams
4. **Support 50+ organizations** with simple infrastructure
5. **Maintain 99.5% uptime** with minimal operational overhead

### 3.2 Success Metrics

| **Metric** | **Target** | **Measurement Method** |
|------------|------------|------------------------|
| Duplicate detection precision | >80% | Manual validation sampling |
| User adoption rate | >70% of invited users | Active user tracking |
| Analysis completion time | <3 min for 5000 issues | System metrics |
| Tenant data isolation | 100% | Security audit |
| User satisfaction (CSAT) | >4.2/5 | Quarterly surveys |

### 3.3 OKRs

**Objective 1: Build a Simple, Scalable Platform**
- KR1: Support 25 organizations in first 3 months
- KR2: Achieve 99.5% uptime
- KR3: Complete security audit

**Objective 2: Deliver Valuable Insights**
- KR1: Identify 500+ potential duplicate issues in first quarter
- KR2: Achieve 80% user satisfaction with recommendations
- KR3: Reduce average backlog size by 15% through consolidation

---

## 4. User Personas

### 4.1 Primary Personas

#### 👩‍💻 **Emma, Engineering Manager**
- **Organization**: Mid-sized tech company (50 engineers)
- **Pain Points**: Can't see duplicate work across 4 teams; spends 3 hours/week on manual review
- **Goals**: Dashboard showing cross-team duplicates; ability to assign actions
- **Technical Level**: Moderate

#### 👨‍💼 **Marcus, Product Owner**
- **Organization**: Growing startup (200 employees)
- **Pain Points**: Duplicate feature requests across product lines
- **Goals**: Consolidated view of feature requests; export capabilities
- **Technical Level**: Low

#### 👩‍💻 **Priya, Senior Developer**
- **Organization**: Small team (15 developers)
- **Pain Points**: Creates 15+ tickets/month; wants to avoid duplicate work
- **Goals**: Quick duplicate detection when creating tickets
- **Technical Level**: High

### 4.2 Secondary Personas

#### 🔧 **Alex, DevOps Engineer**
- **Responsibilities**: System administration
- **Interests**: Simple deployment, minimal dependencies, backup/restore
- **Technical Level**: Expert

---

## 5. Functional Requirements

### 5.1 User Management & Authentication

| **ID** | **Requirement** | **Priority** | **Description** |
|--------|-----------------|--------------|-----------------|
| U-001 | User Registration | P0 | Email/password signup with verification |
| U-002 | Multi-tenant isolation | P0 | Complete data separation via tenant_id |
| U-003 | Role-Based Access Control | P0 | Admin, Manager, User roles |
| U-004 | Team Management | P1 | Create teams, assign members |
| U-005 | User Profiles | P2 | Name, avatar, notification preferences |
| U-006 | Session Management | P0 | JWT-based authentication |

### 5.2 JIRA Integration & Credential Management

| **ID** | **Requirement** | **Priority** | **Description** |
|--------|-----------------|--------------|-----------------|
| J-001 | API Key Storage | P0 | Encrypted storage in PostgreSQL |
| J-002 | Multiple JIRA Instances | P1 | Users can connect to multiple instances |
| J-003 | Connection Testing | P0 | Test API connectivity |
| J-004 | Token Rotation | P2 | Notify users of expiring tokens |
| J-005 | JIRA Server Support | P1 | Support for on-premise JIRA |
| J-006 | Read-Only by Default | P0 | Analysis only; write requires confirmation |

### 5.3 Backlog Analysis Engine

| **ID** | **Requirement** | **Priority** | **Description** |
|--------|-----------------|--------------|-----------------|
| A-001 | Manual Analysis | P0 | On-demand analysis of selected projects |
| A-002 | Scheduled Analysis | P1 | Daily/weekly automated analysis |
| A-003 | Cross-Project Analysis | P1 | Detect duplicates across projects |
| A-004 | Custom JQL Support | P1 | Allow custom filters |
| A-005 | Issue Type Filtering | P1 | Filter by Story, Bug, Task |
| A-006 | Component-based Analysis | P2 | Focus on specific components |

### 5.4 Similarity Detection

| **ID** | **Requirement** | **Priority** | **Description** |
|--------|-----------------|--------------|-----------------|
| S-001 | Text Similarity | P0 | TF-IDF + cosine similarity |
| S-002 | Configurable Thresholds | P0 | Per-user similarity settings |
| S-003 | Field Weighting | P1 | Custom weights for fields |
| S-004 | Batch Processing | P1 | Process issues in batches for performance |
| S-005 | Result Caching | P1 | Cache results in PostgreSQL |

### 5.5 Dashboard & Visualization

| **ID** | **Requirement** | **Priority** | **Description** |
|--------|-----------------|--------------|-----------------|
| D-001 | Overview Dashboard | P0 | Summary metrics, recent analyses |
| D-002 | Duplicate List | P0 | Paginated list of potential duplicates |
| D-003 | Simple Charts | P1 | Basic charts using Chart.js |
| D-004 | Export to CSV | P1 | Download analysis results |
| D-005 | Team Filtering | P1 | Filter by team |
| D-006 | Search | P1 | Search within results |

### 5.6 Action Management

| **ID** | **Requirement** | **Priority** | **Description** |
|--------|-----------------|--------------|-----------------|
| M-001 | Review Queue | P0 | List of potential duplicates |
| M-002 | Mark as Duplicate | P0 | Flag confirmed duplicates |
| M-003 | Add Comments | P1 | Add comments to JIRA |
| M-004 | Create Links | P1 | Link issues in JIRA |
| M-005 | Bulk Actions | P2 | Process multiple issues |
| M-006 | Action History | P1 | Track actions taken |

### 5.7 Reporting & Export

| **ID** | **Requirement** | **Priority** | **Description** |
|--------|-----------------|--------------|-----------------|
| R-001 | CSV Export | P0 | Raw data export |
| R-002 | Email Reports | P2 | Scheduled email delivery |
| R-003 | Summary Reports | P1 | PDF summaries (basic) |

### 5.8 Notifications

| **ID** | **Requirement** | **Priority** | **Description** |
|--------|-----------------|--------------|-----------------|
| N-001 | Email Notifications | P2 | Daily digest |
| N-002 | In-App Notifications | P1 | Bell icon with notifications |
| N-003 | Slack Integration | P2 | Basic Slack webhooks |

---

## 6. Simplified Technical Architecture

### 6.1 High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      Client Layer                            │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              React Single Page App                  │   │
│  │         (Hosted on CDN or static hosting)           │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
                              │ HTTPS/REST
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      Application Layer                       │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              FastAPI (Python)                        │   │
│  │  • Authentication & Authorization                   │   │
│  │  • JIRA API integration                              │   │
│  │  • Similarity analysis engine                        │   │
│  │  • Background tasks (via PostgreSQL queue)          │   │
│  │  • Report generation                                 │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      Data Layer                              │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              PostgreSQL 15+                          │   │
│  │  • All application data                              │   │
│  │  • Job queue (using SKIP LOCKED)                    │   │
│  │  • Caching (materialized views, summary tables)     │   │
│  │  • Full-text search (built-in)                      │   │
│  │  • Encrypted credentials                             │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### 6.2 Technology Stack

| **Layer** | **Technology** | **Justification** |
|-----------|---------------|-------------------|
| **Frontend** | React, TypeScript, Tailwind CSS | Modern, component-based |
| **UI Components** | shadcn/ui | Lightweight, customizable |
| **Charts** | Chart.js | Simple, sufficient |
| **Backend API** | FastAPI (Python) | High performance, easy to develop |
| **Database** | PostgreSQL 15+ | Single datastore for everything |
| **Authentication** | JWT + HTTP-only cookies | Secure, stateless |
| **Background Jobs** | PostgreSQL + asyncio | No need for separate queue |
| **Caching** | PostgreSQL materialized views | Built-in, no extra dependency |
| **Search** | PostgreSQL full-text search | Sufficient for needs |
| **Deployment** | Docker, Docker Compose | Simple, reproducible |
| **Process Manager** | Gunicorn + Uvicorn | Production ASGI server |
| **Monitoring** | Prometheus + Grafana | Optional, can start without |

### 6.3 PostgreSQL for Everything Pattern

```sql
-- Job Queue using PostgreSQL (no Redis needed)
CREATE TABLE job_queue (
    id BIGSERIAL PRIMARY KEY,
    job_type VARCHAR(100) NOT NULL,
    payload JSONB NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    priority INTEGER DEFAULT 0,
    scheduled_for TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    error TEXT,
    retry_count INTEGER DEFAULT 0,
    max_retries INTEGER DEFAULT 3,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Index for queue polling
    INDEX idx_job_queue_status_scheduled (status, scheduled_for) 
    WHERE status = 'pending'
);

-- Dequeue job with SKIP LOCKED (atomic operation)
WITH next_job AS (
    SELECT id 
    FROM job_queue 
    WHERE status = 'pending' 
      AND scheduled_for <= CURRENT_TIMESTAMP
    ORDER BY priority DESC, created_at ASC
    LIMIT 1
    FOR UPDATE SKIP LOCKED
)
UPDATE job_queue 
SET status = 'processing', 
    started_at = CURRENT_TIMESTAMP
FROM next_job
WHERE job_queue.id = next_job.id
RETURNING job_queue.*;
```

```sql
-- Caching with materialized views
CREATE MATERIALIZED VIEW mv_tenant_summary AS
SELECT 
    tenant_id,
    COUNT(DISTINCT analysis_id) as total_analyses,
    COUNT(DISTINCT CASE WHEN status = 'duplicate' THEN pair_id END) as confirmed_duplicates,
    AVG(similarity_score) as avg_similarity
FROM similar_pairs
GROUP BY tenant_id;

-- Refresh periodically or after updates
REFRESH MATERIALIZED VIEW CONCURRENTLY mv_tenant_summary;
```

```sql
-- Full-text search using PostgreSQL
ALTER TABLE issues ADD COLUMN search_vector tsvector
    GENERATED ALWAYS AS (
        setweight(to_tsvector('english', coalesce(summary,'')), 'A') ||
        setweight(to_tsvector('english', coalesce(description,'')), 'B')
    ) STORED;

CREATE INDEX idx_issues_search ON issues USING GIN(search_vector);

-- Search query
SELECT issue_key, summary, 
       ts_rank(search_vector, query) as rank
FROM issues, plainto_tsquery('english', 'login authentication') query
WHERE search_vector @@ query
ORDER BY rank DESC
LIMIT 20;
```

### 6.4 Background Task Processing Flow

```mermaid
sequenceDiagram
    participant User
    participant API
    participant DB as PostgreSQL
    participant Worker
    
    User->>API: Request analysis
    API->>DB: Insert job into queue
    API-->>User: Job ID, status=pending
    
    loop Every 5 seconds
        Worker->>DB: Dequeue next job (SKIP LOCKED)
        DB-->>Worker: Job details
        Worker->>JIRA: Fetch issues
        JIRA-->>Worker: Issue data
        Worker->>Worker: Run similarity analysis
        Worker->>DB: Store results
        Worker->>DB: Update job status
    end
    
    User->>API: Check status
    API->>DB: Query job status
    DB-->>API: status=completed
    API-->>User: Results available
```

---

## 7. Multi-Tenant Design

### 7.1 Tenant Isolation Strategy

**Row-Level Security with PostgreSQL:**

```sql
-- Enable row-level security on all tenant tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE jira_connections ENABLE ROW LEVEL SECURITY;
ALTER TABLE analyses ENABLE ROW LEVEL SECURITY;
ALTER TABLE similar_pairs ENABLE ROW LEVEL SECURITY;
ALTER TABLE actions ENABLE ROW LEVEL SECURITY;

-- Create policy for each table
CREATE POLICY tenant_isolation_users ON users
    USING (tenant_id = current_setting('app.current_tenant')::UUID);

CREATE POLICY tenant_isolation_jira_connections ON jira_connections
    USING (tenant_id = current_setting('app.current_tenant')::UUID);

CREATE POLICY tenant_isolation_analyses ON analyses
    USING (tenant_id = current_setting('app.current_tenant')::UUID);

-- Function to set tenant context in application
CREATE OR REPLACE FUNCTION set_tenant_context(tenant_uuid UUID)
RETURNS VOID AS $$
BEGIN
    PERFORM set_config('app.current_tenant', tenant_uuid::TEXT, false);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

### 7.2 Tenant Onboarding Flow

```mermaid
sequenceDiagram
    participant User
    participant API
    participant DB
    
    User->>API: POST /auth/register
    API->>DB: Create tenant
    API->>DB: Create user (admin)
    DB-->>API: Success
    API-->>User: 201 Created + JWT
    
    User->>API: POST /jira/connect
    API->>API: Encrypt API token
    API->>DB: Store jira_connection
    DB-->>API: Success
    API->>JIRA: Test connection
    JIRA-->>API: OK
    API-->>User: Connection successful
```

### 7.3 Tenant Schema

```sql
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

-- Indexes for performance
CREATE INDEX idx_users_tenant ON users(tenant_id);
CREATE INDEX idx_users_email ON users(email);
```

### 7.4 Tenant Configuration Example

```json
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "name": "Acme Inc",
  "slug": "acme",
  "plan_type": "pro",
  "settings": {
    "analysis": {
      "default_threshold": 0.7,
      "max_issues_per_scan": 5000,
      "auto_schedule": "weekly"
    },
    "features": {
      "slack_integration": true,
      "email_reports": true,
      "bulk_actions": true
    },
    "limits": {
      "max_users": 50,
      "max_teams": 10,
      "storage_days": 90
    }
  }
}
```

---

## 8. Database Schema

### 8.1 Core Tables

```sql
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
    search_vector tsvector, -- For full-text search
    raw_data JSONB, -- Store additional fields
    last_synced_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(tenant_id, issue_key, jira_connection_id)
);

-- Indexes for search
CREATE INDEX idx_issues_tenant ON issues(tenant_id);
CREATE INDEX idx_issues_project ON issues(project_key);
CREATE INDEX idx_issues_type ON issues(issue_type);
CREATE INDEX idx_issues_search ON issues USING GIN(search_vector);

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
```

### 8.2 Encryption for API Tokens

```sql
-- Extension for encryption
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Function to encrypt token
CREATE OR REPLACE FUNCTION encrypt_jira_token(token TEXT, user_id UUID)
RETURNS TEXT AS $$
DECLARE
    encryption_key TEXT;
    encrypted TEXT;
BEGIN
    -- Get encryption key from environment (set in PostgreSQL config)
    encryption_key := current_setting('app.encryption_key');
    
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
    encryption_key := current_setting('app.encryption_key');
    
    decrypted := pgp_sym_decrypt(
        decode(encrypted_token, 'base64'),
        encryption_key || user_id::TEXT
    );
    
    RETURN decrypted;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

### 8.3 Materialized Views for Reporting

```sql
-- Tenant summary view
CREATE MATERIALIZED VIEW mv_tenant_daily_summary AS
SELECT 
    tenant_id,
    DATE(created_at) as date,
    COUNT(DISTINCT analyses.id) as analyses_run,
    COUNT(DISTINCT similar_pairs.id) as potential_duplicates,
    COUNT(DISTINCT CASE WHEN similar_pairs.status = 'duplicate' 
                   THEN similar_pairs.id END) as confirmed_duplicates,
    AVG(similarity_score) as avg_similarity
FROM analyses
LEFT JOIN similar_pairs ON analyses.id = similar_pairs.analysis_id
GROUP BY tenant_id, DATE(created_at);

-- Refresh daily
REFRESH MATERIALIZED VIEW CONCURRENTLY mv_tenant_daily_summary;
```

---

## 9. Non-Functional Requirements

### 9.1 Performance

| **Requirement** | **Target** |
|-----------------|------------|
| API response time (p95) | <200ms |
| Analysis time (5000 issues) | <3 minutes |
| Concurrent users supported | 100 |
| Database connections | 20-50 (pooled) |
| Page load time | <2 seconds |

### 9.2 Scalability

| **Requirement** | **Target** |
|-----------------|------------|
| Max tenants per instance | 100 |
| Max users per tenant | 200 |
| Max issues analyzed per day | 100,000 |
| Data retention | 90 days (configurable) |

### 9.3 Availability

| **Requirement** | **Target** |
|-----------------|------------|
| Uptime SLA | 99.5% |
| Backup frequency | Daily |
| Recovery time objective (RTO) | 4 hours |
| Recovery point objective (RPO) | 24 hours |

### 9.4 Security

| **Requirement** | **Target** |
|-----------------|------------|
| Encryption at rest | AES-256 |
| Encryption in transit | TLS 1.3 |
| Password hashing | bcrypt |
| API token storage | Encrypted with user salt |
| Session duration | 7 days (renewable) |
| Failed login attempts | Lock after 5 attempts |

### 9.5 Usability

| **Requirement** | **Target** |
|-----------------|------------|
| Mobile responsive | Yes |
| Browser support | Chrome, Firefox, Safari (last 2 versions) |
| Onboarding time | <5 minutes |
| Documentation | Quick start guide + API docs |

---

## 10. Security & Compliance

### 10.1 Authentication Flow

```mermaid
sequenceDiagram
    participant User
    participant Frontend
    participant API
    participant DB
    
    User->>Frontend: Enter credentials
    Frontend->>API: POST /auth/login
    API->>DB: Verify credentials
    DB-->>API: User found
    API->>API: Generate JWT
    API-->>Frontend: Set HTTP-only cookie
    Frontend-->>User: Redirect to dashboard
    
    Note over API,Frontend: Subsequent requests
    Frontend->>API: Request with cookie
    API->>API: Verify JWT
    API->>DB: Set tenant context
    API-->>Frontend: Response
```

### 10.2 Security Headers

```python
# FastAPI middleware for security headers
from fastapi import FastAPI
from starlette.middleware.base import BaseHTTPMiddleware

class SecurityHeadersMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request, call_next):
        response = await call_next(request)
        response.headers["X-Content-Type-Options"] = "nosniff"
        response.headers["X-Frame-Options"] = "DENY"
        response.headers["X-XSS-Protection"] = "1; mode=block"
        response.headers["Strict-Transport-Security"] = "max-age=31536000; includeSubDomains"
        response.headers["Content-Security-Policy"] = "default-src 'self'"
        return response
```

### 10.3 API Rate Limiting

```python
# Simple in-memory rate limiting (or use PostgreSQL for distributed)
from fastapi import HTTPException
import time
from collections import defaultdict

class RateLimiter:
    def __init__(self, requests_per_minute=60):
        self.requests_per_minute = requests_per_minute
        self.requests = defaultdict(list)
    
    def check_limit(self, user_id: str):
        now = time.time()
        minute_ago = now - 60
        
        # Clean old requests
        self.requests[user_id] = [t for t in self.requests[user_id] if t > minute_ago]
        
        # Check limit
        if len(self.requests[user_id]) >= self.requests_per_minute:
            raise HTTPException(status_code=429, detail="Rate limit exceeded")
        
        # Add current request
        self.requests[user_id].append(now)
```

### 10.4 Compliance Checklist

- [x] **GDPR**: Right to deletion, data export
- [x] **SOC2**: Access controls, audit logs
- [x] **Data Isolation**: Row-level security
- [x] **Encryption**: AES-256 for tokens
- [x] **Audit Trail**: All actions logged

---

## 11. User Interface

### 11.1 Pages

| **Page** | **Description** | **Access** |
|----------|-----------------|------------|
| Landing | Marketing page, login/signup | Public |
| Dashboard | Overview, recent analyses | Authenticated |
| Analysis | Start new analysis, view progress | Authenticated |
| Results | View duplicate candidates, take action | Authenticated |
| Projects | Manage connected JIRA projects | Authenticated |
| Teams | Team management (admin) | Admin |
| Settings | User preferences, API keys | Authenticated |
| Admin | Tenant settings (admin) | Tenant Admin |

### 11.2 Dashboard Mockup

```
┌─────────────────────────────────────────────────────────────┐
│  JIRA Intelligence                                John ▼   │
├─────────────────────────────────────────────────────────────┤
│  📊 Dashboard                                              │
│                                                             │
│  ┌─────────────────┐  ┌─────────────────┐                 │
│  │ Total Analyses  │  │ Potential Dups  │                 │
│  │ 24              │  │ 156             │                 │
│  └─────────────────┘  └─────────────────┘                 │
│  ┌─────────────────┐  ┌─────────────────┐                 │
│  │ Confirmed Dups  │  │ Actions Taken   │                 │
│  │ 42              │  │ 38              │                 │
│  └─────────────────┘  └─────────────────┘                 │
│                                                             │
│  Recent Analyses                     New Analysis ▶       │
│  ┌────────────────────────────────────────────────────┐   │
│  │ Analysis #123 - 2024-01-15 - 342 issues           │   │
│  │ ⬤ 12 potential duplicates found                   │   │
│  ├────────────────────────────────────────────────────┤   │
│  │ Analysis #122 - 2024-01-14 - 567 issues           │   │
│  │ ⬤ 23 potential duplicates found                   │   │
│  ├────────────────────────────────────────────────────┤   │
│  │ Analysis #121 - 2024-01-13 - 231 issues           │   │
│  │ ⬤ 8 potential duplicates found                    │   │
│  └────────────────────────────────────────────────────┘   │
│                                                             │
│  Pending Review (10)                     View All →       │
│  ┌────────────────────────────────────────────────────┐   │
│  │ ⚠ JIRA-123 and JIRA-456 - 85% match               │   │
│  │   "Fix login bug" / "Authentication issue"         │   │
│  │   [Review] [Mark Duplicate] [Ignore]               │   │
│  ├────────────────────────────────────────────────────┤   │
│  │ ⚠ JIRA-789 and JIRA-012 - 92% match               │   │
│  │   "API timeout" / "Gateway timeout error"          │   │
│  │   [Review] [Mark Duplicate] [Ignore]               │   │
│  └────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### 11.3 Results Page

```jsx
// Example React component structure
const ResultsPage = () => {
  const [pairs, setPairs] = useState([]);
  const [filter, setFilter] = useState('pending');
  
  return (
    <div>
      <h1>Similar Issues Found</h1>
      
      <div className="filters">
        <button onClick={() => setFilter('pending')}>Pending</button>
        <button onClick={() => setFilter('reviewed')}>Reviewed</button>
        <button onClick={() => setFilter('duplicate')}>Confirmed</button>
      </div>
      
      <div className="results-list">
        {pairs.map(pair => (
          <SimilarPairCard 
            key={pair.id}
            pair={pair}
            onAction={handleAction}
          />
        ))}
      </div>
    </div>
  );
};
```

---

## 13. Risks & Mitigations

| **Risk** | **Probability** | **Impact** | **Mitigation** |
|----------|----------------|------------|----------------|
| JIRA API rate limits | Medium | High | Batch requests, respect rate limits, queue jobs |
| PostgreSQL performance | Low | Medium | Proper indexing, connection pooling, monitoring |
| Data isolation breach | Low | Critical | Row-level security, regular audits |
| User adoption | Medium | Medium | Intuitive UI, onboarding flow, documentation |
| Token compromise | Low | Critical | Encryption at rest, user-specific salts |
| Analysis time too long | Medium | Medium | Optimize queries, batch processing, progress indicators |

### 13.1 Mitigation Strategies

1. **API Rate Limits**: Implement exponential backoff, queue large analyses
2. **Performance**: Regular VACUUM, ANALYZE on PostgreSQL, connection pooling
3. **Security**: Regular penetration testing, dependency updates
4. **Adoption**: User research, feedback loops, quick-start guide

---

## 14. Appendices

### 14.1 Glossary

| **Term** | **Definition** |
|----------|----------------|
| **Tenant** | An organization/customer using the platform |
| **JQL** | JIRA Query Language |
| **TF-IDF** | Term Frequency-Inverse Document Frequency |
| **SKIP LOCKED** | PostgreSQL feature for queue implementation |
| **RLS** | Row-Level Security |

### 14.2 Environment Variables

```bash
# Database
DATABASE_URL=postgresql://user:pass@localhost:5432/jira_intel

# Security
ENCRYPTION_KEY=your-32-byte-key-here
JWT_SECRET=your-jwt-secret-here

# Application
APP_NAME=JIRA Intelligence
APP_ENV=production
LOG_LEVEL=info

# Email (optional)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=notifications@example.com
SMTP_PASSWORD=password
```

### 14.3 Docker Compose

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_DB: jira_intel
      POSTGRES_USER: jira
      POSTGRES_PASSWORD: changeme
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U jira"]
      interval: 10s
      timeout: 5s
      retries: 5

  api:
    build: ./backend
    environment:
      DATABASE_URL: postgresql://jira:changeme@postgres:5432/jira_intel
      ENCRYPTION_KEY: ${ENCRYPTION_KEY}
      JWT_SECRET: ${JWT_SECRET}
    ports:
      - "8000:8000"
    depends_on:
      postgres:
        condition: service_healthy

  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    depends_on:
      - api

volumes:
  postgres_data:
```

### 14.4 Sample .env File

```bash
# Required
DATABASE_URL=postgresql://localhost:5432/jira_intel
ENCRYPTION_KEY=0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef
JWT_SECRET=your-super-secret-jwt-key-change-this

# Optional
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=alerts@example.com
SMTP_PASSWORD=app-password-here

# Feature flags
ENABLE_SLACK=false
ENABLE_EMAIL_REPORTS=true
```

### 14.5 Approval

| **Role** | **Name** | **Signature** | **Date** |
|----------|----------|---------------|----------|
| Product Owner | | | |
| Tech Lead | | | |
| Security Lead | | | |
| DevOps Lead | | | |

---
