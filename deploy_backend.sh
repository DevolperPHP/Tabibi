#!/bin/bash

# Backend Deployment Script for Production Server

echo "🚀 Deploying Backend to Production Server"
echo "=========================================="
echo ""

# Server Configuration
# TODO: Update these with your actual server details
SERVER_IP="165.232.78.163"  # Your server IP
SERVER_USER="root"           # SSH user (usually root, ubuntu, or your username)
APP_DIR="/var/www/tabibi-backend"  # Where to deploy on server
BACKUP_DIR="/var/backups/tabibi-backend-$(date +%Y%m%d-%H%M%S)"

echo "Server: $SERVER_USER@$SERVER_IP"
echo "App Directory: $APP_DIR"
echo ""

# Create backup on server
echo "📦 Creating backup on server..."
ssh $SERVER_USER@$SERVER_IP "mkdir -p $BACKUP_DIR && cp -r $APP_DIR/* $BACKUP_DIR/ 2>/dev/null || true"
echo "✅ Backup created at: $BACKUP_DIR"
echo ""

# Update environment variables on server
echo "⚙️  Updating environment variables..."
cat << 'EOF' > temp_env
# Production environment variables
NODE_ENV=production
PORT=3000
MONGODB_URI=your_mongodb_connection_string_here
JWT_SECRET=your_jwt_secret_here

# Make sure serviceAccountKey.json exists
GOOGLE_APPLICATION_CREDENTIALS=$APP_DIR/config/serviceAccountKey.json
EOF

scp temp_env $SERVER_USER@$SERVER_IP:$APP_DIR/.env
rm temp_env
echo "✅ Environment variables updated"
echo ""

# Deploy backend files
echo "📤 Deploying backend files..."
rsync -avz --exclude='node_modules' --exclude='.git' --exclude='.env' --exclude='temp_*' \
    ./tabibi-backend/ \
    $SERVER_USER@$SERVER_IP:$APP_DIR/
echo "✅ Backend files deployed"
echo ""

# Install dependencies on server
echo "📦 Installing dependencies on server..."
ssh $SERVER_USER@$SERVER_IP "cd $APP_DIR && npm install --production"
echo "✅ Dependencies installed"
echo ""

# Restart backend service
echo "🔄 Restarting backend service..."
ssh $SERVER_USER@$SERVER_IP "pm2 restart tabibi-backend || pm2 start app.js --name tabibi-backend"
echo "✅ Backend restarted"
echo ""

# Check if service is running
echo "✅ Checking if service is running..."
STATUS=$(ssh $SERVER_USER@$SERVER_IP "pm2 list | grep tabibi-backend | awk '{print \$10}'")
if [ "$STATUS" == "online" ]; then
    echo "✅ Backend is running successfully!"
else
    echo "⚠️  Backend status: $STATUS"
fi
echo ""

echo "🎉 Deployment complete!"
echo ""
echo "Backend URL: http://$SERVER_IP:3000"
echo ""
echo "Test the API:"
echo "curl http://$SERVER_IP:3000/notifications/YOUR_USER_ID"
echo ""
