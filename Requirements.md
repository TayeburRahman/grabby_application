//STARTS:

Now when i order the menu, i want to see the stamp in the menu, if i have enough stamp to get a free menu, then i can get a free menu. That system should to like, 

Customar like this:
Create a api Customar side give brunch id Menue ID the system give the response free or not.
aslo trar baki total stamp number for this brunch

doro amar kace 8ta staps ache, ami card a 2ta ekta menu add korci, ekta menu r jonno ami staps die free menu nite cacci, r 2nd menu r jonno ami staps nite cacci, akhon fstmenur joono ami alredy 5 staps ditiye free menu nite cacci, and abar vablam 2nd menu r jonno 6ta projon, that api call will be defaret time 


//END

=you can check my project full requirements ================================


## Core Features Short overview
Project Overview

This project is a mobile café ordering platform designed to make ordering food and drinks from cafés faster, easier, and more convenient. The platform connects customers with nearby cafés, allowing them to browse menus, place orders in advance, and make secure in-app payments. Customers can choose their preferred pickup method (car pickup or counter pickup), navigate to the café using integrated maps, and pick up their orders without waiting in line. The system also includes features like order history, loyalty stamps, refund requests, and café suggestions.

The platform supports four user roles: Customer, Shop Owner, Admin, and Super Admin. Customers can discover cafés, order items, and manage their orders. Shop Owners can register their cafés, manage branches, update menus, receive and process orders, and run promotions. Admins help manage daily platform operations such as monitoring orders, handling refund requests, and supporting shops. Super Admins have full system control, including managing admins, cafés, marketing campaigns, platform settings, and analytics.

The goal of the platform is to create a smart and efficient café ordering ecosystem that improves customer convenience, helps cafés manage operations smoothly, and provides administrators with full control over the platform.

Key Features List
Customer Features:
Browse Cafés:
View nearby cafés using either a map or list view.
Search cafés by name.

View Menu:
Tap a café to view its full menu, including item descriptions, pricing, and availability.

Add to Cart:
Select items to add to the cart before checkout.

Select Pickup Method:
Choose between car pickup or counter pickup during checkout based on the café's available options.

In-App Payment:
Pay for orders directly within the app using secure payment methods.

Order Confirmation:
Receive a confirmation after a successful payment.

Navigation:
Use Google Maps in-app for navigation to the café after placing the order.

Arrival Notification:
Café is notified when the customer arrives within a predefined radius.

Order Pickup:
Pick up pre-ordered items without waiting in line.

Order History:
Access past orders and view details.

Loyalty Stamp System:
Earn and track digital loyalty stamps for coffee items, accumulated per café.

Multiple Car Plates:
Register and manage more than one car plate for car pickup.

Suggest a Shop:
Submit suggestions for a café to join the platform via an in-app form.

Refund Requests:
Request refunds based on platform rules:
Refunds may have penalties.
Full refunds for valid/extreme reasons.
Refunds are issued as in-app credit.

Shop Owner Features:
Self-Onboarding:
Cafés can sign up and create accounts independently without admin intervention.

Multiple Branches:
Cafés can add multiple branches during signup and update them later.

Menu Management:
Add, update, or remove menu items by category, set prices, quantities, and availability.

Order Management:
Receive and manage customer orders in real-time.

Order Notification:
Get notified when customers arrive to pick up their orders.

Order Status Management:
Track and update the order status (e.g., pending, preparing, ready for pickup, completed).

Order Cancellation:
Cafés can cancel orders according to platform rules.

Customer Information (Limited):
View order-related customer details (order history, loyalty stamps) without access to full customer profiles.

Payment Confirmation:
Ensure payments are confirmed before preparing orders.

Discounts & Events:
Apply discounts to items for special events (e.g., Ramadan, Eid).

Marketing Campaigns:
Participate in paid promotional campaigns for item placement on the home page with multiple promotion tiers.

Terms Agreement:
Accept terms regarding service fees and payment fees during signup.
Admin Features:
Admin Dashboard:
Manage cafés, branches, customers, and app settings.

Order & Refund Oversight:
View orders, cancellations, and refund requests.
Manage disputes when necessary.

Marketing Management:
Configure and manage marketing campaign tiers and featured item placements.

Analytics & Reporting:
Track app usage, order statistics, customer behavior, and performance metrics for continuous improvement.

## Key Patterns & Conventions
### 1. Route Definition
```typescript
// src/app/modules/[module]/[module].routes.ts
import express from 'express';
import auth from '../../middlewares/auth';
import validateRequest from '../../middlewares/validateRequest';
import { ModuleController } from './module.controller';
import { ModuleValidation } from './module.validation';
import { USER_ROLES } from '../../../enums/user';


const router = express.Router();


router.post(
 '/create',
 auth(USER_ROLES.ADMIN),
 validateRequest(ModuleValidation.createSchema),
 ModuleController.create
);


export const ModuleRoutes = router;
```


### 2. Controller Pattern
```typescript
// src/app/modules/[module]/[module].controller.ts
import catchAsync from '../../../shared/catchasync';
import sendResponse from '../../../shared/sendResponse';


const create = catchAsync(async (req, res) => {
 const result = await ModuleService.create(req.body);
 sendResponse(res, {
   statusCode: 201,
   success: true,
   message: 'Created successfully',
   data: result,
 });
});
```


### 3. Service Pattern
```typescript
// src/app/modules/[module]/[module].service.ts
const create = async (payload: IModule): Promise<IModule> => {
 const result = await Module.create(payload);
 return result;
};
```


### 4. Model Pattern
```typescript
// src/app/modules/[module]/[module].model.ts
import { Schema, model } from 'mongoose';
import { IModule, ModuleModel } from './module.interface';


const moduleSchema = new Schema<IModule, ModuleModel>(
 {
   name: { type: String, required: true },
   // ... fields
 },
 { timestamps: true }
);


export const Module = model<IModule, ModuleModel>('Module', moduleSchema);
```


### 5. Interface Pattern
```typescript
// src/app/modules/[module]/[module].interface.ts
import { Model, Types } from 'mongoose';


export type IModule = {
 name: string;
 status: 'active' | 'inactive';
 authId: Types.ObjectId;
 // ... fields
};


export type ModuleModel = Model<IModule>;
```


### 6. Validation Pattern
```typescript
// src/app/modules/[module]/[module].validation.ts
import { z } from 'zod';


const createSchema = z.object({
 body: z.object({
   name: z.string({ required_error: 'Name is required' }),
   email: z.string().email(),
   // ... fields
 }),
});


export const ModuleValidation = { createSchema };
```


### 7. QueryBuilder Usage
```typescript
const query = new QueryBuilder(Model.find(), req.query)
 .search(['name', 'email'])
 .filter()
 .sort()
 .paginate()
 .fields()
 .populate('authId');


const result = await query.modelQuery;
const meta = await query.countTotal();
```


### 8. Route Registration
```typescript
// src/app/routes/index.ts
import { ModuleRoutes } from '../modules/module/module.routes';


const moduleRoutes = [
 { path: '/api/v1/module', route: ModuleRoutes },
 // ... other modules
];
```


---


## Adding a New Module (Step-by-Step)


1. Create folder: `src/app/modules/[moduleName]/`
2. Create files following the patterns above:
  - `moduleName.interface.ts` - Define types
  - `moduleName.model.ts` - Define Mongoose schema
  - `moduleName.validation.ts` - Define Zod schemas
  - `moduleName.service.ts` - Write business logic
  - `moduleName.controller.ts` - Write request handlers
  - `moduleName.routes.ts` - Define routes with middleware
3. Register routes in `src/app/routes/index.ts`


---


## Tech Stack


- **Runtime**: Node.js with TypeScript
- **Framework**: Express.js
- **Database**: MongoDB with Mongoose ODM
- **Authentication**: JWT (JSON Web Tokens) + bcrypt password hashing
- **Real-time**: Socket.io (online user tracking, live notifications)
- **Validation**: Zod schema validation
- **Email**: Nodemailer with SMTP
- **Payments**: Stripe (configured)
- **File Upload**: Multer (multipart file uploads)
- **Logging**: Winston with daily rotation
- **Code Quality**: ESLint, Prettier, TypeScript strict mode





