import { API_BASE_URL } from "./auth";

export const getShopOwnerRequests = async (query: Record<string, any> = {}) => {
  try {
    const token = localStorage.getItem("accessToken");
    const queryString = new URLSearchParams(query).toString();
    const res = await fetch(`${API_BASE_URL}/admin/shop_owner/request${queryString ? `?${queryString}` : ""}`, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`
      },
    });
    const result = await res.json();
    if (!res.ok) throw new Error(result.message || "Failed to fetch requests");
    return { success: true, data: result.data, meta: result.meta };
  } catch (error: any) {
    return { success: false, message: error.message };
  }
};

export const acceptShopOwner = async (id: string) => {
  try {
    const token = localStorage.getItem("accessToken");
    const res = await fetch(`${API_BASE_URL}/admin/shop_owner/accept`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`
      },
      body: JSON.stringify({ id }),
    });
    const result = await res.json();
    if (!res.ok) throw new Error(result.message || "Failed to approve shop");
    return { success: true, data: result.data };
  } catch (error: any) {
    return { success: false, message: error.message };
  }
};

export const rejectShopOwner = async (id: string) => {
  try {
    const token = localStorage.getItem("accessToken");
    const res = await fetch(`${API_BASE_URL}/admin/shop_owner/reject`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`
      },
      body: JSON.stringify({ id }),
    });
    const result = await res.json();
    if (!res.ok) throw new Error(result.message || "Failed to reject shop");
    return { success: true, data: result.data };
  } catch (error: any) {
    return { success: false, message: error.message };
  }
};

export const blockShopOwner = async (id: string) => {
  try {
    const token = localStorage.getItem("accessToken");
    const res = await fetch(`${API_BASE_URL}/admin/shop_owner/blocked`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`
      },
      body: JSON.stringify({ id }),
    });
    const result = await res.json();
    if (!res.ok) throw new Error(result.message || "Failed to toggle block status");
    return { success: true, data: result.data };
  } catch (error: any) {
    return { success: false, message: error.message };
  }
};

export const getAllCustomers = async (query: Record<string, any> = {}) => {
  try {
    const token = localStorage.getItem("accessToken");
    const queryString = new URLSearchParams(query).toString();
    const res = await fetch(`${API_BASE_URL}/admin/customers${queryString ? `?${queryString}` : ""}`, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`
      },
    });
    const result = await res.json();
    if (!res.ok) throw new Error(result.message || "Failed to fetch customers");
    return { success: true, data: result.data, meta: result.meta };
  } catch (error: any) {
    return { success: false, message: error.message };
  }
};

export const getAllAdmins = async (query: Record<string, any> = {}) => {
  try {
    const token = localStorage.getItem("accessToken");
    const queryString = new URLSearchParams(query).toString();
    const res = await fetch(`${API_BASE_URL}/admin${queryString ? `?${queryString}` : ""}`, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`
      },
    });
    const result = await res.json();
    if (!res.ok) throw new Error(result.message || "Failed to fetch admins");
    return { success: true, data: result.data, meta: result.meta };
  } catch (error: any) {
    return { success: false, message: error.message };
  }
};

export const createAdmin = async (payload: any) => {
  try {
    const token = localStorage.getItem("accessToken");
    const res = await fetch(`${API_BASE_URL}/admin/create`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`
      },
      body: JSON.stringify(payload),
    });
    const result = await res.json();
    if (!res.ok) throw new Error(result.message || "Failed to create admin");
    return { success: true, data: result.data };
  } catch (error: any) {
    return { success: false, message: error.message };
  }
};
