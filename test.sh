#!/bin/bash

# Quick test script to verify the application is working

echo "🧪 Testing JIRA Backlog Intelligence Platform..."
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test 1: Check if services are running
echo "1️⃣  Checking if services are running..."
if docker-compose ps | grep -q "Up"; then
    echo -e "${GREEN}✓ Docker services are running${NC}"
else
    echo -e "${RED}✗ Docker services are not running. Please run 'docker-compose up'${NC}"
    exit 1
fi

# Test 2: Check backend health
echo ""
echo "2️⃣  Testing backend health endpoint..."
HEALTH_RESPONSE=$(curl -s http://localhost:8000/api/v1/health)
if echo "$HEALTH_RESPONSE" | grep -q "healthy"; then
    echo -e "${GREEN}✓ Backend is healthy${NC}"
    echo "   Response: $HEALTH_RESPONSE"
else
    echo -e "${RED}✗ Backend health check failed${NC}"
    echo "   Response: $HEALTH_RESPONSE"
fi

# Test 3: Test user registration
echo ""
echo "3️⃣  Testing user registration..."
REGISTER_RESPONSE=$(curl -s -X POST http://localhost:8000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test-'$(date +%s)'@example.com",
    "password": "testpass123",
    "full_name": "Test User"
  }')

if echo "$REGISTER_RESPONSE" | grep -q "email"; then
    echo -e "${GREEN}✓ User registration successful${NC}"
    echo "   Created user with email from response"
else
    echo -e "${YELLOW}⚠ User registration returned unexpected response${NC}"
    echo "   Response: $REGISTER_RESPONSE"
fi

# Test 4: Check if frontend is accessible
echo ""
echo "4️⃣  Testing frontend accessibility..."
FRONTEND_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000)
if [ "$FRONTEND_RESPONSE" = "200" ]; then
    echo -e "${GREEN}✓ Frontend is accessible${NC}"
    echo "   HTTP Status: $FRONTEND_RESPONSE"
else
    echo -e "${YELLOW}⚠ Frontend returned unexpected status${NC}"
    echo "   HTTP Status: $FRONTEND_RESPONSE"
fi

# Test 5: Check database
echo ""
echo "5️⃣  Testing database..."
DB_TEST=$(docker exec backlog-lens_postgres_1 psql -U jira -d jira_intel -c "SELECT COUNT(*) FROM tenants;" 2>&1)
if echo "$DB_TEST" | grep -q "count"; then
    echo -e "${GREEN}✓ Database is accessible and initialized${NC}"
else
    echo -e "${RED}✗ Database test failed${NC}"
    echo "   Error: $DB_TEST"
fi

echo ""
echo "======================================"
echo "✅ Basic tests completed!"
echo ""
echo "Next steps:"
echo "  - Open http://localhost:3000 in your browser"
echo "  - Try registering a new user"
echo "  - Check API docs at http://localhost:8000/docs"
echo "======================================"
