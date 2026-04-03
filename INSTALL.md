# Elyn Builder App iOS - Installation Guide

## Quick Install (3 Steps)

### Step 1: Upload & Extract
1. Upload `elyn-builder.zip` to your server via File Manager or FTP
2. Extract the ZIP file in your desired directory (e.g., `/var/www/elyn-builder/`)

### Step 2: Run Installer Script
```bash
cd /var/www/elyn-builder
chmod +x install.sh
sudo bash install.sh
```

This script will:
- Check server requirements (Python 3.8+, Node.js, MongoDB)
- Install backend dependencies (Python packages)
- Install frontend dependencies (Node packages)
- Configure environment files
- Build the frontend
- Create service files for production

### Step 3: Web Installer
1. Start the backend: `cd backend && python3 -m uvicorn server:app --host 0.0.0.0 --port 8001`
2. Open your browser: `http://your-server-ip:8001/install`
3. Follow the wizard:
   - **Step 1**: Welcome screen
   - **Step 2**: Server requirements check
   - **Step 3**: Database configuration (MongoDB host, port, name)
   - **Step 4**: Create admin account (username, email, password)
   - **Step 5**: Site settings (name, logo)
   - **Step 6**: Install!

---

## Server Requirements

| Requirement | Minimum | Recommended |
|-------------|---------|-------------|
| Python | 3.8+ | 3.10+ |
| Node.js | 16+ | 18+ |
| MongoDB | 4.4+ | 6.0+ |
| RAM | 512 MB | 2 GB |
| Disk | 1 GB | 5 GB |
| OS | Ubuntu 20.04+ | Ubuntu 22.04+ |

---

## Manual Installation

If the script doesn't work, follow these steps:

### 1. Install System Dependencies
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install python3 python3-pip python3-venv nodejs npm -y
npm install -g yarn

# Install MongoDB
# Follow: https://www.mongodb.com/docs/manual/installation/
```

### 2. Install Backend
```bash
cd backend
pip3 install -r requirements.txt
```

### 3. Configure Backend .env
```bash
# Edit backend/.env
MONGO_URL="mongodb://localhost:27017"
DB_NAME="elyn_builder"
CORS_ORIGINS="*"
JWT_SECRET="your-random-64-char-secret"
ADMIN_EMAIL="admin@yourdomain.com"
ADMIN_PASSWORD="your-secure-password"
```

### 4. Install Frontend
```bash
cd frontend
yarn install
```

### 5. Configure Frontend .env
```bash
# Edit frontend/.env
REACT_APP_BACKEND_URL=https://yourdomain.com
```

### 6. Build Frontend
```bash
cd frontend
yarn build
```

### 7. Start Backend
```bash
cd backend
python3 -m uvicorn server:app --host 0.0.0.0 --port 8001
```

### 8. Open Web Installer
Go to `http://your-server-ip:8001/install` and follow the wizard.

---

## Production Setup with Nginx

### Nginx Configuration
```nginx
server {
    listen 80;
    server_name yourdomain.com;

    # Frontend (static files)
    location / {
        root /var/www/elyn-builder/frontend/build;
        try_files $uri $uri/ /index.html;
    }

    # Backend API
    location /api {
        proxy_pass http://127.0.0.1:8001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_cache_bypass $http_upgrade;
    }
}
```

### Systemd Service
```bash
sudo cp elyn-backend.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable elyn-backend
sudo systemctl start elyn-backend
```

### SSL with Let's Encrypt
```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d yourdomain.com
```

---

## cPanel / Shared Hosting

### Using cPanel File Manager:
1. Upload `elyn-builder.zip` to `public_html` or a subdirectory
2. Extract the ZIP
3. Set up a **Python App** in cPanel → Setup Python App
4. Set up **MongoDB** via MongoDB Atlas (free) if not available locally
5. Update `backend/.env` with your MongoDB Atlas connection string
6. Access `/install` to run the web installer

### Using Terminal in cPanel:
```bash
cd ~/public_html/elyn-builder
bash install.sh
```

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| MongoDB connection error | Ensure MongoDB is running: `sudo systemctl start mongod` |
| Port 8001 in use | Change port in the uvicorn command: `--port 8002` |
| Frontend build fails | Run `yarn install` first, ensure Node.js 16+ |
| Permission denied | Run with `sudo` or fix permissions: `chmod -R 755 .` |
| AI features not working | Add Emergent LLM key or OpenAI key in Admin → Settings |

---

## Support
- Version: 1.0.0
- License: Free (100% gratis)
- Platform: Elyn Builder App iOS
