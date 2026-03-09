#!/bin/bash

# Maarg AI - Backend Connection Test Script
# This script tests all API endpoints to verify backend connectivity

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Load environment variables
if [ -f .env.local ]; then
    export $(cat .env.local | grep -v '^#' | xargs)
else
    echo -e "${RED}❌ .env.local file not found!${NC}"
    echo "Please create .env.local with your API endpoints"
    exit 1
fi

# Check if API URLs are set
if [ -z "$VITE_API_BASE_URL" ]; then
    echo -e "${RED}❌ VITE_API_BASE_URL not set in .env.local${NC}"
    exit 1
fi

echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Maarg AI Backend Connection Test        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Testing API: ${VITE_API_BASE_URL}${NC}"
echo ""

# Test counter
PASSED=0
FAILED=0

# Function to test endpoint
test_endpoint() {
    local method=$1
    local endpoint=$2
    local description=$3
    local data=$4
    local expected_status=$5
    
    echo -e "${BLUE}Testing:${NC} $description"
    echo -e "${YELLOW}  → ${method} ${endpoint}${NC}"
    
    if [ "$method" == "GET" ]; then
        response=$(curl -s -w "\n%{http_code}" -X GET "${VITE_API_BASE_URL}${endpoint}" \
            -H "Content-Type: application/json" \
            -H "Origin: http://localhost:5173")
    else
        response=$(curl -s -w "\n%{http_code}" -X ${method} "${VITE_API_BASE_URL}${endpoint}" \
            -H "Content-Type: application/json" \
            -H "Origin: http://localhost:5173" \
            -d "$data")
    fi
    
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')
    
    if [ "$http_code" == "$expected_status" ] || [ "$http_code" == "200" ]; then
        echo -e "${GREEN}  ✓ Success (HTTP $http_code)${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}  ✗ Failed (HTTP $http_code)${NC}"
        echo -e "${RED}  Response: $body${NC}"
        FAILED=$((FAILED + 1))
    fi
    echo ""
}

# Test CORS preflight
echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo -e "${BLUE}1. Testing CORS Configuration${NC}"
echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo ""

cors_response=$(curl -s -I -X OPTIONS "${VITE_API_BASE_URL}/users" \
    -H "Origin: http://localhost:5173" \
    -H "Access-Control-Request-Method: POST" \
    -H "Access-Control-Request-Headers: Content-Type")

if echo "$cors_response" | grep -q "access-control-allow-origin"; then
    echo -e "${GREEN}✓ CORS is properly configured${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}✗ CORS headers not found${NC}"
    echo -e "${YELLOW}Response headers:${NC}"
    echo "$cors_response"
    FAILED=$((FAILED + 1))
fi
echo ""

# Test endpoints
echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo -e "${BLUE}2. Testing API Endpoints${NC}"
echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo ""

# Test nearby drivers
test_endpoint "GET" "/drivers/nearby?lat=28.6139&lng=77.209&radius=5" \
    "Get Nearby Drivers" "" "200"

# Test hotspots
test_endpoint "GET" "/hotspots?driverId=test-driver&radiusKm=5" \
    "Get AI Hotspots" "" "200"

# Test user registration (might fail if user exists, that's ok)
test_endpoint "POST" "/users" \
    "User Registration" \
    '{"name":"Test User","email":"test@example.com","password":"Test123!","userType":"rider"}' \
    "200"

# Test driver location update
test_endpoint "POST" "/drivers/location" \
    "Update Driver Location" \
    '{"driverId":"test-driver","latitude":28.6139,"longitude":77.209,"timestamp":1234567890}' \
    "200"

# Summary
echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo -e "${BLUE}Test Summary${NC}"
echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo ""
echo -e "${GREEN}Passed: $PASSED${NC}"
echo -e "${RED}Failed: $FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}╔════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  🎉 All tests passed! Backend is ready!   ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════╝${NC}"
    exit 0
else
    echo -e "${RED}╔════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║  ⚠️  Some tests failed. Check logs above   ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Troubleshooting tips:${NC}"
    echo "1. Verify API Gateway endpoints in .env.local"
    echo "2. Check CORS is enabled in API Gateway"
    echo "3. Ensure Lambda functions are deployed"
    echo "4. Check CloudWatch logs for errors"
    echo "5. Verify API Gateway is deployed to 'prod' stage"
    exit 1
fi
