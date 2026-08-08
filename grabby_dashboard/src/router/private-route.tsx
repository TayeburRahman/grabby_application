import type { ReactNode } from "react";
import { Navigate } from "react-router-dom";

interface JwtPayload {
  exp: number;
  role: string;
  authId: string;
  userId: string;
}

function parseJwt(token: string): JwtPayload | null {
  try {
    const base64Url = token.split('.')[1];
    let base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
    const pad = base64.length % 4;
    if (pad) {
      if (pad === 1) {
        throw new Error('InvalidLengthError');
      }
      base64 += new Array(5 - pad).join('=');
    }
    const jsonPayload = decodeURIComponent(window.atob(base64).split('').map(function(c) {
        return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
    }).join(''));

    return JSON.parse(jsonPayload);
  } catch (e) {
    return null;
  }
}

const PrivateRoute = ({ children }: { children: ReactNode }) => {
  const token = localStorage.getItem("accessToken");
  const userStr = localStorage.getItem("adminUser");

  if (!token || !userStr) {
    return <Navigate to="/auth/login" replace />;
  }

  const decoded = parseJwt(token);
  if (!decoded) {
    localStorage.removeItem("accessToken");
    localStorage.removeItem("adminUser");
    return <Navigate to="/auth/login" replace />;
  }

  // Check expiration (exp is in seconds, Date.now() is in milliseconds)
  if (decoded.exp * 1000 < Date.now()) {
    localStorage.removeItem("accessToken");
    localStorage.removeItem("adminUser");
    return <Navigate to="/auth/login" replace />;
  }

  // Check role
  if (decoded.role !== "SUPER_ADMIN" && decoded.role !== "ADMIN") {
    localStorage.removeItem("accessToken");
    localStorage.removeItem("adminUser");
    return <Navigate to="/auth/login" replace />;
  }

  return <>{children}</>;
};

export default PrivateRoute;
