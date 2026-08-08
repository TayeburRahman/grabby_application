# Pre-Order and Pickup Application (Client: ayah_almheiri)
 
## 🚀 Key Features

### 📊 Dashboard & Reports
- **Real-time Analytics**: Visualized stats for orders, revenue, and customer activity.
- **Detailed Reporting**: Comprehensive reports with charts and data tables for business insights.
- **Revenue Tracking**: Monitor daily, weekly, and monthly revenue trends.

### 🛍️ Management
- **Order Management**: Full lifecycle tracking of customer orders (Pending, Preparing, Ready, Completed).
- **Product Management**: Manage menu items, categories, and pricing.
- **Customer Management**: Track customer history, loyalty, and total spending.
- **Branch Management**: Monitor and manage multiple business locations.
- **Promotions & Discounts**: Create and manage marketing campaigns and revenue impact.
- **Shop Fees**: Manage commission fees and percentages for each shop.
- **Admin Management**: Role-based access control and admin user management.

### ⚙️ Settings & Configuration
- **Profile Management**: Update admin profile and security settings.
- **Content Pages**: Manage "About Us", "Terms & Conditions", "Privacy Policy", and "FAQs".
- **Notifications**: System-wide notification center.

## 🛠️ Tech Stack

- **Framework**: [React 19](https://react.dev/)
- **Build Tool**: [Vite 7](https://vitejs.dev/)
- **Language**: [TypeScript](https://www.typescriptlang.org/)
- **Styling**: [Tailwind CSS 4](https://tailwindcss.com/)
- **Components**: [Shadcn/UI](https://ui.shadcn.com/) (Radix UI)
- **Data Fetching**: Custom `useSmartFetchHook`
- **Tables**: [TanStack Table](https://tanstack.com/table/v8)
- **Charts**: [Recharts](https://recharts.org/)
- **Rich Text Editor**: [Tiptap](https://tiptap.dev/)
- **Icons**: [Lucide React](https://lucide.dev/)
- **Forms**: [React Hook Form](https://react-hook-form.com/) + [Zod](https://zod.dev/)

## 📦 Installation & Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   ```

2. **Install dependencies**
   ```bash
   pnpm install
   ```

3. **Run the development server**
   ```bash
   pnpm dev
   ```

4. **Build for production**
   ```bash
   pnpm build
   ```

## 📂 Project Structure

- `src/app`: Page components and route-specific logic.
- `src/components`: Reusable UI components (Common, Management, Settings, UI, etc.).
- `src/layout`: Main and Auth layout wrappers.
- `src/router`: Routing configuration using `react-router-dom`.
- `src/hooks`: Custom React hooks.
- `src/lib`: Utility functions and helper methods.
- `src/theme`: Theme provider and configuration.

---

Built with ❤️ for Ayah Almheiri.
