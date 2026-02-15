# JIRA Backlog Intelligence Platform

A multi-tenant web application designed to help teams analyze JIRA backlogs, identify duplicate or similar work items, and provide actionable insights through a collaborative interface.

## 📋 Features

- **Multi-Tenant Architecture**: Complete data isolation for organizations
- **Secure Credential Management**: User-specific encrypted JIRA API tokens
- **Similarity Analysis**: TF-IDF based duplicate detection
- **Team Collaboration**: Share insights across team members
- **Simple Architecture**: PostgreSQL-only backend (no Redis, Elasticsearch required)
- **RESTful API**: FastAPI backend with automatic OpenAPI documentation
- **Modern UI**: React + TypeScript frontend

## 🏗️ Architecture

### Tech Stack

| Layer | Technology |
|-------|-----------|
| **Frontend** | React 18, TypeScript, Inline CSS |
| **Backend API** | FastAPI (Python 3.11) |
| **Database** | PostgreSQL 15+ |
| **Authentication** | JWT tokens |
| **Background Jobs** | PostgreSQL + asyncio |
| **Deployment** | Docker, Docker Compose |

### Project Structure

```
backlog-lens/
├── backend/                 # FastAPI application
│   ├── app/
│   │   ├── api/            # API endpoints
│   │   ├── core/           # Core configs (db, security, settings)
│   │   ├── models/         # SQLAlchemy models
│   │   ├── schemas/        # Pydantic schemas
│   │   ├── services/       # Business logic
│   │   └── workers/        # Background workers
│   ├── Dockerfile
│   └── requirements.txt
├── frontend/               # React application
│   ├── public/
│   ├── src/
│   │   ├── pages/         # Page components
│   │   ├── services/      # API services
│   │   └── App.tsx
│   ├── Dockerfile
│   └── package.json
├── database/
│   └── migrations/        # SQL migration files
├── docker-compose.yml
├── .env.example
└── PLAN.md               # Detailed RFC/requirements

## 🚀 Getting Started

### Prerequisites

- Docker and Docker Compose
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/namuan/backlog-lens.git
   cd backlog-lens
   ```

2. **Copy environment file**
   ```bash
   cp .env.example .env
   ```

3. **Update environment variables** (optional for development)
   
   Edit `.env` and update the following:
   - `ENCRYPTION_KEY`: 64-character hex string (generate with `openssl rand -hex 32`)
   - `JWT_SECRET`: Random secret key for JWT tokens
   
   For development, you can use the default values.

4. **Start the application**
   ```bash
   docker-compose up --build
   ```

   This will start:
   - PostgreSQL on port 5432
   - Backend API on port 8000
   - Frontend on port 3000

5. **Access the application**
   - Frontend: http://localhost:3000
   - Backend API docs: http://localhost:8000/docs
   - Backend health: http://localhost:8000/api/v1/health

### First Time Setup

1. Open http://localhost:3000 in your browser
2. Click "Register" to create a new account
3. Optionally provide an organization name to create a new tenant
4. Leave organization name empty to join the demo organization
5. Login with your credentials

## 📖 API Documentation

Once the backend is running, visit http://localhost:8000/docs for interactive API documentation (Swagger UI).

### Key Endpoints

- `POST /api/v1/auth/register` - Register a new user
- `POST /api/v1/auth/login` - Login and get JWT token
- `GET /api/v1/auth/me` - Get current user info
- `GET /api/v1/health` - Health check

## 🗄️ Database

The application uses PostgreSQL with:
- Multi-tenant row-level security (RLS)
- Encrypted API token storage
- Job queue implementation using SKIP LOCKED
- Full-text search capabilities

### Database Schema

See [database/migrations/001_init_schema.sql](database/migrations/001_init_schema.sql) for the complete schema.

Key tables:
- `tenants` - Organizations
- `users` - User accounts
- `jira_connections` - Encrypted JIRA credentials
- `analyses` - Analysis jobs
- `similar_pairs` - Duplicate detection results
- `job_queue` - Background job queue

## 🔒 Security

- **Password Hashing**: Bcrypt
- **JWT Tokens**: HS256 algorithm
- **API Token Encryption**: AES-256 with user-specific salts
- **Row-Level Security**: PostgreSQL RLS for multi-tenant isolation
- **CORS**: Configured for local development

## 🧪 Development

### Running Backend Only

```bash
cd backend
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

### Running Frontend Only

```bash
cd frontend
npm install
npm start
```

### Database Migrations

The initial schema is automatically applied when PostgreSQL starts via `docker-entrypoint-initdb.d`.

For manual migration:
```bash
docker exec -i backlog-lens_postgres_1 psql -U jira -d jira_intel < database/migrations/001_init_schema.sql
```

## 📝 Configuration

### Environment Variables

See `.env.example` for all available configuration options.

Required:
- `DATABASE_URL` - PostgreSQL connection string
- `ENCRYPTION_KEY` - 64-character encryption key
- `JWT_SECRET` - JWT signing secret

Optional:
- `SMTP_*` - Email configuration
- `ENABLE_SLACK` - Slack integration flag
- `ENABLE_EMAIL_REPORTS` - Email reports flag

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📚 Additional Documentation

- [PLAN.md](PLAN.md) - Detailed RFC and technical requirements
- Backend API docs: http://localhost:8000/docs (when running)

## 🎯 Roadmap

See [PLAN.md](PLAN.md) for detailed requirements and features.

Current implementation includes:
- ✅ Multi-tenant architecture
- ✅ User authentication and registration
- ✅ Database schema with RLS
- ✅ Basic frontend UI (Login/Dashboard)
- ✅ Docker deployment setup

Coming next:
- [ ] JIRA connection management
- [ ] Similarity analysis engine
- [ ] Background job worker
- [ ] Results visualization
- [ ] Action management (link issues, mark duplicates)
- [ ] Email notifications
- [ ] Team management

## 💬 Support

For questions or issues, please open a GitHub issue.