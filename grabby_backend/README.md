# ⚡ Grabby Backend REST API & Real-Time WebSockets Engine

Welcome to the backend repository of **Grabby** — an enterprise café pre-ordering, car-side pickup, and merchant management system.

---

## 🛠️ Technology Stack

- **Runtime**: Node.js (`>=16.0.0`)
- **Language**: TypeScript (`v5.1+`)
- **Web Framework**: Express.js (`v4.19`)
- **Database**: MongoDB with Mongoose ODM (`v8.3`)
- **Authentication**: JWT (JSON Web Tokens) + `bcrypt` password hashing
- **Input Validation**: Zod (`v3.23`)
- **Real-Time Communication**: Socket.io (`v4.7`)
- **Payment Gateway**: Stripe Connect (`v15.6`) with 90/10 automated commission split
- **Email Service**: Nodemailer & SendGrid Mail
- **Logging**: Winston with daily log file rotation
- **File Storage**: Multer multipart upload middleware

---

## 🏗️ Architecture & Modular Structure

The backend follows a **Modular Clean Architecture** pattern where each domain feature lives within its own self-contained directory in `src/app/modules/`:

```text
src/app/modules/[moduleName]/
├── moduleName.interface.ts   # Mongoose interfaces & TypeScript types
├── moduleName.model.ts       # Mongoose Schema & Model definitions
├── moduleName.validation.ts  # Zod schemas for request validation
├── moduleName.service.ts     # Business logic & database operations
├── moduleName.controller.ts # Express request/response handlers
└── moduleName.routes.ts     # Express routes & auth middleware bindings
```

### Registered Core Modules:
- **`auth`**: Authentication, registration, OTP verification, password resets.
- **`user`**: Profile management, car plate registration, customer details.
- **`shop`**: Shop owner onboarding, branch creation, store settings, hours.
- **`menu`**: Category management, menu items, modifier options, prices.
- **`order`**: Order creation, pickup mode (Car/Counter), status progression.
- **`stamp`**: Per-branch digital loyalty stamp tracking & free item redemption.
- **`stripe`**: Stripe Connect onboarding, payment intent, 90/10 payout split.
- **`admin`**: System analytics, refund dispute resolution, CMS settings.

---

## 💳 Stripe Connect 90/10 Payment Split

Grabby utilizes **Stripe Connect** for automated payout distribution:
- **90%** of the order total is transferred directly to the connected store merchant account (`transfer_data.destination`).
- **10%** platform fee is retained in the admin Stripe account (`application_fee_amount`).

---

## ⚡ Socket.io Real-Time Events

- `connection`: Authenticates incoming WebSocket clients via JWT token.
- `customer:arrived`: Emitted by mobile app when customer enters café geofence; triggers store sound & dashboard alert.
- `order:status_updated`: Emitted when merchant updates order state (`Pending` ➔ `Preparing` ➔ `Ready` ➔ `Completed`).

---

## 🚀 Getting Started

### 1. Installation
```bash
npm install
```

### 2. Environment Setup
Copy `.env.example` to `.env` and fill in your keys:
```env
PORT=5000
NODE_ENV=development
DATABASE_URL=mongodb://localhost:27017/grabby_db
BCRYPT_SALT_ROUNDS=12
JWT_SECRET=your_super_secret_jwt_key
JWT_EXPIRES_IN=7d
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...
```

### 3. Development Server
```bash
npm run dev
```

### 4. Production Build
```bash
npm run build
npm start
```
