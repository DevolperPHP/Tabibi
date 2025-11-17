#!/bin/bash

# My Doctor App - Backend Start Script with Nodemon
# Uses Node.js v20 to ensure compatibility with all dependencies

echo "🚀 Starting My Doctor Backend with Nodemon..."
echo "Using Node.js $(node --version)"
echo "Loading nvm..."

# Load NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Use Node.js v20
nvm use 20

echo "✅ Node.js version: $(node --version)"
echo "✅ Starting backend server with nodemon..."

# Start the backend with nodemon
cd tabibi-backend && npm run dev