#!/bin/bash

# Production Deployment Script
# Usage: ./deploy_to_production.sh YOUR_SERVER_IP SSH_USER DEPLOY_PATH

echo "🚀 PRODUCTION DEPLOYMENT SCRIPT"
echo "================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if server details provided
if [ "$#" -lt 3 ]; then
    echo -e "${RED}❌ Usage: $0 <SERVER_IP> <SSH_USER> <DEPLOY_PATH>${NC}"
    echo ""
    echo "Example:"
    echo "  $0 165.232.78.163 root /var/www/tabibi-backend"
    echo ""
    echo "Optional 4th parameter for SSH port:"
    echo "  $0 165.232.78.163 root /var/www/tabibi-backend 22"
    exit 1
fi

SERVER_IP="$1"
SSH_USER="$2"
DEPLOY_PATH="$3"
SSH_PORT="${4:-22}"

echo -e "${YELLOW}Server:${NC} $SERVER_IP"
echo -e "${YELLOW}User:${NC} $SSH_USER"
echo -e "${YELLOW}Path:${NC} $DEPLOY_PATH"
echo -e "${YELLOW}Port:${NC} $SSH_PORT"
echo ""

# Check if SSH key exists
SSH_KEY="$HOME/.ssh/id_rsa"
if [ ! -f "$SSH_KEY" ]; then
    echo -e "${YELLOW}⚠️  No SSH key found at $SSH_KEY${NC}"
    echo "You'll need to enter password for SSH authentication"
    SSH_CMD="ssh $SSH_USER@$SERVER_IP -p $SSH_PORT"
    SCP_CMD="scp -P $SSH_PORT"
else
    echo -e "${GREEN}✅ Using SSH key: $SSH_KEY${NC}"
    SSH_CMD="ssh $SSH_USER@$SERVER_IP -i $SSH_KEY -p $SSH_PORT"
    SCP_CMD="scp -P $SSH_PORT -i $SSH_KEY"
fi
echo ""

# Step 1: Create backup
echo -e "${YELLOW}📦 Creating backup...${NC}"
BACKUP_DIR="/var/backups/tabibi-backend-$(date +%Y%m%d-%H%M%S)"
$SSH_CMD "mkdir -p $BACKUP_DIR && cp -r $DEPLOY_PATH/* $BACKUP_DIR/ 2>/dev/null || echo 'No existing files to backup'"
echo -e "${GREEN}✅ Backup created${NC}"
echo ""

# Step 2: Create deployment directory
echo -e "${YELLOW}📁 Creating deployment directory...${NC}"
$SSH_CMD "mkdir -p $DEPLOY_PATH/config $DEPLOY_PATH/logs"
echo -e "${GREEN}✅ Directory created${NC}"
echo ""

# Step 3: Deploy backend files
echo -e "${YELLOW}📤 Deploying backend files...${NC}"
rsync -avz --progress \
    --exclude='node_modules' \
    --exclude='.git' \
    --exclude='logs' \
    --exclude='.env' \
    ./tabibi-backend/ \
    $SSH_USER@$SERVER_IP:$DEPLOY_PATH/

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Files deployed successfully${NC}"
else
    echo -e "${RED}❌ File deployment failed${NC}"
    exit 1
fi
echo ""

# Step 4: Set proper permissions
echo -e "${YELLOW}🔐 Setting permissions...${NC}"
$SSH_CMD "chown -R $SSH_USER:$SSH_USER $DEPLOY_PATH"
$SSH_CMD "chmod 755 $DEPLOY_PATH"
$SSH_CMD "chmod 600 $DEPLOY_PATH/config/serviceAccountKey.json"
echo -e "${GREEN}✅ Permissions set${NC}"
echo ""

# Step 5: Install dependencies
echo -e "${YELLOW}📦 Installing dependencies...${NC}"
$SSH_CMD "cd $DEPLOY_PATH && npm install --production --silent"
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Dependencies installed${NC}"
else
    echo -e "${RED}❌ Failed to install dependencies${NC}"
    exit 1
fi
echo ""

# Step 6: Create/update .env file
echo -e "${YELLOW}⚙️  Creating environment file...${NC}"
cat << 'ENVEOF' | $SSH_CMD "cat > $DEPLOY_PATH/.env"
NODE_ENV=production
PORT=80
MONGODB_URI=REPLACE_WITH_YOUR_MONGODB_URI
JWT_SECRET=REPLACE_WITH_YOUR_JWT_SECRET
GOOGLE_APPLICATION_CREDENTIALS=$DEPLOY_PATH/config/serviceAccountKey.json
ENVEOF

echo -e "${YELLOW}⚠️  IMPORTANT: Update .env file with your actual database and JWT credentials${NC}"
echo -e "${YELLOW}   Server path: $DEPLOY_PATH/.env${NC}"
echo ""

# Step 7: Test Firebase Admin
echo -e "${YELLOW}🔥 Testing Firebase Admin...${NC}"
$SSH_CMD "cd $DEPLOY_PATH && node -e \"try { const admin = require('firebase-admin'); const svc = require('./config/serviceAccountKey.json'); admin.initializeApp({ credential: admin.credential.cert(svc) }); console.log('✅ Firebase Admin OK'); } catch(e) { console.log('❌ Firebase Admin ERROR:', e.message); process.exit(1); }\""

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Firebase Admin working${NC}"
else
    echo -e "${RED}❌ Firebase Admin failed${NC}"
    exit 1
fi
echo ""

# Step 8: Setup PM2 for process management
echo -e "${YELLOW}⚙️  Setting up PM2...${NC}"
$SSH_CMD "npm install -g pm2"
$SSH_CMD "pm2 delete tabibi-backend 2>/dev/null || true"
$SSH_CMD "cd $DEPLOY_PATH && pm2 start app.js --name tabibi-backend"
$SSH_CMD "pm2 save"
$SSH_CMD "pm2 startup"
echo -e "${GREEN}✅ PM2 configured${NC}"
echo ""

# Step 9: Check if service is running
echo -e "${YELLOW}✅ Checking service status...${NC}"
sleep 2
STATUS=$($SSH_CMD "pm2 list | grep tabibi-backend | awk '{print \$10}'")
if [ "$STATUS" == "online" ]; then
    echo -e "${GREEN}🎉 Backend is RUNNING successfully!${NC}"
else
    echo -e "${YELLOW}⚠️  Service status: $STATUS${NC}"
    echo "Check logs with: $SSH_CMD \"pm2 logs tabibi-backend\""
fi
echo ""

# Step 10: Test API endpoint
echo -e "${YELLOW}🌐 Testing API endpoint...${NC}"
RESPONSE=$($SSH_CMD "curl -s -o /dev/null -w '%{http_code}' http://localhost:80/")
if [ "$RESPONSE" == "404" ]; then
    echo -e "${GREEN}✅ API is responding (404 is expected for root endpoint)${NC}"
else
    echo -e "${YELLOW}⚠️  API response code: $RESPONSE${NC}"
fi
echo ""

# Step 11: Setup firewall rules
echo -e "${YELLOW}🔒 Checking firewall...${NC}"
$SSH_CMD "ufw status 2>/dev/null || echo 'No UFW firewall detected'"
echo ""

# Final summary
echo "================================"
echo -e "${GREEN}🎉 DEPLOYMENT COMPLETE!${NC}"
echo "================================"
echo ""
echo -e "${YELLOW}Server Info:${NC}"
echo "  IP: $SERVER_IP"
echo "  Path: $DEPLOY_PATH"
echo "  Status: Check with '$SSH_USER@$SERVER_IP' pm2 list'"
echo ""
echo -e "${YELLOW}Useful Commands:${NC}"
echo "  View logs:    $SSH_CMD pm2 logs tabibi-backend"
echo "  Restart:      $SSH_CMD pm2 restart tabibi-backend"
echo "  Stop:         $SSH_CMD pm2 stop tabibi-backend"
echo "  Check status: $SSH_CMD pm2 list"
echo ""
echo -e "${YELLOW}API URL:${NC} http://$SERVER_IP"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "1. Update .env file with your MongoDB URI and JWT secret"
echo "2. Build and test your Flutter app"
echo "3. Deploy the Flutter app"
echo ""
echo -e "${GREEN}To test notifications from your app:${NC}"
echo "  python3 test_notifications.py test-single USER_ID"
echo ""
