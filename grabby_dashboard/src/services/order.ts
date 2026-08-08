import { API_BASE_URL } from "./auth";

export const getAllOrders = async (query: Record<string, any> = {}) => {
  try {
    const token = localStorage.getItem("accessToken");
    const queryString = new URLSearchParams(query).toString();
    const res = await fetch(`${API_BASE_URL}/orders${queryString ? `?${queryString}` : ""}`, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`
      },
    });
    const result = await res.json();
    if (!res.ok) throw new Error(result.message || "Failed to fetch orders");
    return { success: true, data: result.data, meta: result.meta };
  } catch (error: any) {
    return { success: false, message: error.message };
  }
};

export const getBranchOrders = async (branchId: string, query: Record<string, any> = {}) => {
  try {
    const token = localStorage.getItem("accessToken");
    const queryString = new URLSearchParams(query).toString();
    const res = await fetch(`${API_BASE_URL}/orders/branch/${branchId}${queryString ? `?${queryString}` : ""}`, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`
      },
    });
    const result = await res.json();
    if (!res.ok) throw new Error(result.message || "Failed to fetch branch orders");
    return { success: true, data: result.data, meta: result.meta };
  } catch (error: any) {
    return { success: false, message: error.message };
  }
};

export const updateOrderStatus = async (orderId: string, status: string) => {
  try {
    const token = localStorage.getItem("accessToken");
    const res = await fetch(`${API_BASE_URL}/orders/${orderId}/status`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`
      },
      body: JSON.stringify({ status }),
    });
    const result = await res.json();
    if (!res.ok) throw new Error(result.message || "Failed to update order status");
    return { success: true, data: result.data };
  } catch (error: any) {
    return { success: false, message: error.message };
  }
};

export const getAllBranches = async () => {
  try {
    const token = localStorage.getItem("accessToken");
    const res = await fetch(`${API_BASE_URL}/admin/all-branches`, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`
      },
    });
    const result = await res.json();
    if (!res.ok) throw new Error(result.message || "Failed to fetch branches");
    return { success: true, data: result.data };
  } catch (error: any) {
    return { success: false, message: error.message };
  }
};
export const getAllShopOwners = async () => {
  try {
    const token = localStorage.getItem("accessToken");
    const res = await fetch(`${API_BASE_URL}/admin/all-shop-owners`, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`
      },
    });
    const result = await res.json();
    if (!res.ok) throw new Error(result.message || "Failed to fetch shop owners");
    return { success: true, data: result.data };
  } catch (error: any) {
    return { success: false, message: error.message };
  }
};
