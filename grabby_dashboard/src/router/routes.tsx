import { createBrowserRouter } from "react-router-dom";
import MainLayout from "@/layout/main-layout";
import { lazy } from "react";
import AuthLayout from "@/layout/auth-layout";
import PrivateRoute from "./private-route";
//======================================================================================================================
// App pages (all under src/app)
const Dashboard = lazy(() => import("@/app/dashboard/Dashboard"));
const Profile = lazy(() => import("@/app/settings/profile/Profile"));
const Privacy = lazy(() => import("@/app/settings/privacy/Privacy"));
const Terms = lazy(() => import("@/app/settings/terms/Terms"));
const About = lazy(() => import("@/app/settings/about-us/About"));
const FAQ = lazy(() => import("@/app/settings/faq/Faq"));
const Admins = lazy(() => import("@/app/management/admins/Admins"));
const Orders = lazy(() => import("@/app/management/orders/Orders"));
const Customers = lazy(() => import("@/app/management/customers/Customers"));
const Products = lazy(() => import("@/app/management/products/Products"));
const Promotions = lazy(() => import("@/app/management/promotions/Promotions"));
const Branches = lazy(() => import("@/app/management/branches/Branches"));
const ShopOwners = lazy(() => import("@/app/management/shop-owners/ShopOwners"));
const ShopFees = lazy(() => import("@/app/management/shop-fees/ShopFees"));
const Reports = lazy(() => import("@/app/management/reports/Reports"));
const Notifications = lazy(() => import("@/app/notifications/Notifications"));

// Auth
const Login = lazy(() => import("@/app/auth/Login"));
const ForgotPassword = lazy(() => import("@/app/auth/ForgotPassword"));
const ResetPassword = lazy(() => import("@/app/auth/ResetPassword"));
const CodeVerification = lazy(() => import("@/app/auth/CodeVerification"));

//======================================================================================================================

export const router = createBrowserRouter([
    {
        path: "/",
        element: (
            <PrivateRoute>
                <MainLayout />
            </PrivateRoute>
        ),
        children: [
            { index: true, element: <Dashboard /> },

            // Management
            { path: "management/orders", element: <Orders /> },
            { path: "management/customers", element: <Customers /> },
            { path: "management/products", element: <Products /> },
            { path: "management/promotions", element: <Promotions /> },
            { path: "management/branches", element: <Branches /> },
            { path: "management/shop-owners", element: <ShopOwners /> },
            { path: "management/shop-fees", element: <ShopFees /> },
            { path: "management/reports", element: <Reports /> },
            { path: "management/admins", element: <Admins /> },
            { path: "notifications", element: <Notifications /> },
            // Settings
            { path: "settings/profile", element: <Profile /> },
            { path: "settings/about", element: <About /> },
            { path: "settings/terms", element: <Terms /> },
            { path: "settings/privacy", element: <Privacy /> },
            { path: "settings/faq", element: <FAQ /> },
        ]
    },
    {
        path: "/auth",
        element: <AuthLayout />,
        children: [
            { path: "login", element: <Login /> },
            { path: "forgot-password", element: <ForgotPassword /> },
            { path: "reset-password", element: <ResetPassword /> },
            { path: "verify", element: <CodeVerification /> },
        ]
    }
]);