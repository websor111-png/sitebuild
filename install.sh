#!/bin/bash
# ============================================
# Elyn Builder App iOS - Server Installer
# Version 1.0
# ============================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo ""
echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Elyn Builder App iOS - Server Installer   ${NC}"
echo -e "${BLUE}  Version 1.0                               ${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Check if running as root or with sudo
if [ "$EUID" -ne 0 ]; then 
  echo -e "${YELLOW}Warning: Not running as root. Some commands may fail.${NC}"
  echo -e "${YELLOW}Consider running with: sudo bash install.sh${NC}"
  echo ""
fi

# ========== CHECK REQUIREMENTS ==========
echo -e "${BLUE}[1/6] Checking requirements...${NC}"

# Check Python
if command -v python3 &> /dev/null; then
    PY_VER=$(python3 --version 2>&1 | awk '{print $2}')
    echo -e "  ${GREEN}✓${NC} Python: $PY_VER"
else
    echo -e "  ${RED}✗ Python3 not found. Install with: sudo apt install python3 python3-pip${NC}"
    exit 1
fi

# Check pip
if command -v pip3 &> /dev/null; then
    echo -e "  ${GREEN}✓${NC} pip3: installed"
else
    echo -e "  ${RED}✗ pip3 not found. Install with: sudo apt install python3-pip${NC}"
    exit 1
fi

# Check Node.js
if command -v node &> /dev/null; then
    NODE_VER=$(node --version)
    echo -e "  ${GREEN}✓${NC} Node.js: $NODE_VER"
else
    echo -e "  ${RED}✗ Node.js not found. Install with:${NC}"
    echo "    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -"
    echo "    sudo apt install -y nodejs"
    exit 1
fi

# Check MongoDB
if command -v mongod &> /dev/null || command -v mongosh &> /dev/null; then
    echo -e "  ${GREEN}✓${NC} MongoDB: installed"
else
    echo -e "  ${YELLOW}⚠ MongoDB not detected locally. Make sure MongoDB is accessible.${NC}"
fi

# Check yarn
if command -v yarn &> /dev/null; then
    echo -e "  ${GREEN}✓${NC} Yarn: installed"
else
    echo -e "  ${YELLOW}⚠ Installing yarn...${NC}"
    npm install -g yarn
    echo -e "  ${GREEN}✓${NC} Yarn: installed"
fi

echo ""

# ========== INSTALL BACKEND ==========
echo -e "${BLUE}[2/6] Installing backend dependencies...${NC}"
cd backend
pip3 install -r requirements.txt --quiet
echo -e "  ${GREEN}✓${NC} Backend dependencies installed"
cd ..
echo ""

# ========== INSTALL FRONTEND ==========
echo -e "${BLUE}[3/6] Installing frontend dependencies...${NC}"
cd frontend
yarn install --silent
echo -e "  ${GREEN}✓${NC} Frontend dependencies installed"
cd ..
echo ""

# ========== CONFIGURE ENVIRONMENT ==========
echo -e "${BLUE}[4/6] Configuring environment...${NC}"

# Generate JWT secret
JWT_SECRET=$(python3 -c "import secrets; print(secrets.token_hex(32))")

# Backend .env
if [ ! -f backend/.env ]; then
    cat > backend/.env << EOF
MONGO_URL="mongodb://localhost:27017"
DB_NAME="elyn_builder"
CORS_ORIGINS="*"
JWT_SECRET="$JWT_SECRET"
ADMIN_EMAIL="admin@elynbuilder.com"
ADMIN_PASSWORD="changeme123"
EOF
    echo -e "  ${GREEN}✓${NC} Backend .env created"
else
    echo -e "  ${YELLOW}⚠${NC} Backend .env already exists, keeping existing config"
fi

# Frontend .env
if [ ! -f frontend/.env ]; then
    echo -e "  ${YELLOW}Enter your domain (e.g., https://yourdomain.com):${NC}"
    read -r DOMAIN
    if [ -z "$DOMAIN" ]; then
        DOMAIN="http://localhost:8001"
    fi
    cat > frontend/.env << EOF
REACT_APP_BACKEND_URL=$DOMAIN
EOF
    echo -e "  ${GREEN}✓${NC} Frontend .env created with domain: $DOMAIN"
else
    echo -e "  ${YELLOW}⚠${NC} Frontend .env already exists, keeping existing config"
fi

echo ""

# ========== BUILD FRONTEND ==========
echo -e "${BLUE}[5/6] Building frontend...${NC}"
cd frontend
yarn build --silent 2>/dev/null || yarn build
echo -e "  ${GREEN}✓${NC} Frontend built successfully"
cd ..
echo ""

# ========== CREATE SERVICE FILES ==========
echo -e "${BLUE}[6/6] Creating service configuration...${NC}"

# Create systemd service for backend
cat > elyn-backend.service << 'EOF'
[Unit]
Description=Elyn Builder Backend
After=network.target mongod.service

[Service]
Type=simple
User=www-data
WorkingDirectory=/var/www/elyn-builder/backend
ExecStart=/usr/bin/python3 -m uvicorn server:app --host 0.0.0.0 --port 8001
Restart=always
RestartSec=5
Environment=PATH=/usr/local/bin:/usr/bin

[Install]
WantedBy=multi-user.target
EOF

echo -e "  ${GREEN}✓${NC} Service file created: elyn-backend.service"
echo ""

# ========== DONE ==========
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  Installation Complete!                     ${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "Next steps:"
echo -e "  1. Start MongoDB:    ${BLUE}sudo systemctl start mongod${NC}"
echo -e "  2. Start backend:    ${BLUE}cd backend && python3 -m uvicorn server:app --host 0.0.0.0 --port 8001${NC}"
echo -e "  3. Open browser:     ${BLUE}http://your-server-ip:8001${NC}"
echo -e "  4. Complete setup:   ${BLUE}Follow the web installer wizard${NC}"
echo ""
echo -e "For production deployment with Nginx:"
echo -e "  ${BLUE}sudo cp elyn-backend.service /etc/systemd/system/${NC}"
echo -e "  ${BLUE}sudo systemctl enable elyn-backend${NC}"
echo -e "  ${BLUE}sudo systemctl start elyn-backend${NC}"
echo ""
echo -e "${YELLOW}Note: The web installer will guide you through database setup,${NC}"
echo -e "${YELLOW}admin account creation, and site configuration.${NC}"
echo ""
