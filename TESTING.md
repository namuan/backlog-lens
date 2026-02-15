# Testing Guide

## Manual Testing

### 1. Start the Application

```bash
docker-compose up --build
```

Wait for all services to start. You should see:
- PostgreSQL ready and accepting connections
- Backend API running on port 8000
- Frontend development server running on port 3000

### 2. Test Health Endpoints

```bash
# Test backend health
curl http://localhost:8000/api/v1/health

# Expected response:
# {"status":"healthy"}

# Test root endpoint
curl http://localhost:8000/

# Expected response includes version and docs link
```

### 3. Test User Registration

```bash
curl -X POST http://localhost:8000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "testpass123",
    "full_name": "Test User",
    "tenant_name": "Test Organization"
  }'

# Expected: 201 Created with user data
```

### 4. Test User Login

```bash
curl -X POST http://localhost:8000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "testpass123"
  }'

# Expected: JWT token in response
# {"access_token":"eyJ...","token_type":"bearer"}
```

### 5. Test Frontend

1. Open browser to http://localhost:3000
2. You should see the login/register page
3. Click "Register" tab
4. Fill in the form:
   - Email: test@example.com
   - Password: password123
   - Full Name: Test User
   - Organization: (optional, leave empty for demo org)
5. Click "Register"
6. You should be redirected to the dashboard

### 6. Test Database

```bash
# Connect to PostgreSQL
docker exec -it backlog-lens_postgres_1 psql -U jira -d jira_intel

# Check tables
\dt

# Check tenants
SELECT * FROM tenants;

# Check users
SELECT id, email, full_name, role FROM users;

# Exit
\q
```

## Automated Tests

### Backend Tests (TODO)

```bash
cd backend
pytest
```

### Frontend Tests (TODO)

```bash
cd frontend
npm test
```

## Common Issues

### Issue: Port already in use

**Solution**: Stop any services using ports 3000, 5432, or 8000

```bash
# On Linux/Mac
lsof -ti:3000 | xargs kill -9
lsof -ti:5432 | xargs kill -9
lsof -ti:8000 | xargs kill -9

# Or change ports in docker-compose.yml
```

### Issue: Database connection refused

**Solution**: Wait for PostgreSQL to be fully ready

```bash
# Check postgres logs
docker-compose logs postgres

# Restart if needed
docker-compose restart postgres
```

### Issue: Frontend can't connect to API

**Solution**: Check CORS and proxy settings

- Verify API is running: `curl http://localhost:8000/api/v1/health`
- Check browser console for CORS errors
- Verify `package.json` proxy setting

### Issue: Migration didn't run

**Solution**: Manually run the migration

```bash
docker exec -i backlog-lens_postgres_1 psql -U jira -d jira_intel < database/migrations/001_init_schema.sql
```

## Clean Restart

To start fresh:

```bash
# Stop and remove containers and volumes
docker-compose down -v

# Rebuild and start
docker-compose up --build
```
