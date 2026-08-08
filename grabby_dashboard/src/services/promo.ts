import { API_BASE_URL } from "./auth";

export const getAllPromos = async (query: Record<string, any> = {}) => {
  try {
    const token = localStorage.getItem("accessToken");
    const queryString = new URLSearchParams(query).toString();
    const res = await fetch(`${API_BASE_URL}/promo-code/admin/all${queryString ? `?${queryString}` : ""}`, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`
      },
    });
    const result = await res.json();
    if (!res.ok) throw new Error(result.message || "Failed to fetch promos");
    return { success: true, data: result.data, meta: result.meta };
  } catch (error: any) {
    return { success: false, message: error.message };
  }
};

export const createPromo = async (data: any) => {
  try {
    const token = localStorage.getItem("accessToken");
    const res = await fetch(`${API_BASE_URL}/promo-code`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`
      },
      body: JSON.stringify(data),
    });
    const result = await res.json();
    if (!res.ok) throw new Error(result.message || "Failed to create promo");
    return { success: true, data: result.data };
  } catch (error: any) {
    return { success: false, message: error.message };
  }
};

export const updatePromo = async (id: string, data: any) => {
  try {
    const token = localStorage.getItem("accessToken");
    const res = await fetch(`${API_BASE_URL}/promo-code/${id}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`
      },
      body: JSON.stringify(data),
    });
    const result = await res.json();
    if (!res.ok) throw new Error(result.message || "Failed to update promo");
    return { success: true, data: result.data };
  } catch (error: any) {
    return { success: false, message: error.message };
  }
};

export const deletePromo = async (id: string) => {
  try {
    const token = localStorage.getItem("accessToken");
    const res = await fetch(`${API_BASE_URL}/promo-code/${id}`, {
      method: "DELETE",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`
      },
    });
    const result = await res.json();
    if (!res.ok) throw new Error(result.message || "Failed to delete promo");
    return { success: true };
  } catch (error: any) {
    return { success: false, message: error.message };
  }
};

export const updatePromoStatus = async (id: string, status: string) => {
  try {
    const token = localStorage.getItem("accessToken");
    const res = await fetch(`${API_BASE_URL}/promo-code/${id}/status`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`
      },
      body: JSON.stringify({ status }),
    });
    const result = await res.json();
    if (!res.ok) throw new Error(result.message || "Failed to update promo status");
    return { success: true, data: result.data };
  } catch (error: any) {
    return { success: false, message: error.message };
  }
};
