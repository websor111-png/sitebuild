# Elyn Builder App iOS - PRD

## Original Problem Statement
Aplicatie web de tip App Builder (similar cu MySiteApp) numită "Elyn Builder App iOS" care:
- Se instalează pe server propriu
- Transformă site-uri web în aplicații mobile (Android & iOS) prin WebView
- Are asistent AI pentru configurare (Claude Sonnet 4.5)
- Permite upload direct pe Google Play Console via API
- Panou de administrare doar pentru admin
- Complet gratuită, fără taxe
- Sistem de autentificare cu username + parolă

## Architecture
- **Frontend**: React 19 + Tailwind CSS + Shadcn UI
- **Backend**: FastAPI (Python) + MongoDB
- **AI**: Claude Sonnet 4.5 via emergentintegrations (Emergent LLM Key)
- **Auth**: JWT + bcrypt + admin seeding
- **Design**: Swiss & High-Contrast (Outfit + IBM Plex Sans, Klein Blue #002FA7)

## User Personas
1. **Admin** (Owner) - Manages platform, blocks users, monitors stats
2. **User** (App Builder) - Creates apps, configures, generates, downloads

## Core Requirements (Static)
- [x] User registration & login with username + password
- [x] Admin-only panel with user management
- [x] App Builder wizard (URL → Config → AI → Publish)
- [x] AI Assistant (Claude Sonnet 4.5)
- [x] App generation (Android Kotlin + iOS Swift source code)
- [x] Download project files
- [x] Google Play upload configuration
- [x] Block/unblock malicious users
- [x] 100% free platform

## What's Been Implemented (April 3, 2026)
- Full auth system (JWT, bcrypt, admin seeding, brute force protection)
- Landing page with professional Swiss design
- Login/Register pages
- User Dashboard with app management
- App Builder with 4 tabs (Configuration, Design, AI Assistant, Publish)
- Admin Panel (stats, users table, apps table, block/unblock, delete)
- AI Chat integration with Claude Sonnet 4.5
- App generation (Android Kotlin + iOS Swift WebView projects)
- Download project files
- Google Play Console settings form

## Prioritized Backlog
### P0 (Critical)
- All P0 features implemented

### P1 (Important)
- Actual APK compilation via cloud build service
- Google Play Developer API integration for direct upload
- App icon upload with object storage
- Password reset flow

### P2 (Nice to Have)
- App analytics dashboard
- Template gallery for common app types
- Multi-language support
- Team collaboration features
- Push notification service integration
- App versioning and update management

## Next Tasks
1. Integrate object storage for app icon uploads
2. Add password reset via email
3. Template gallery for quick app creation
4. App build status tracking with progress indicators
