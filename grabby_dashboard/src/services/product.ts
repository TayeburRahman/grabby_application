import { API_BASE_URL } from "./auth";

export const getAllProducts = async (query: Record<string, any> = {}) => {
  try {
    const token = localStorage.getItem("accessToken");
    const queryString = new URLSearchParams(query).toString();
    const res = await fetch(`${API_BASE_URL}/admin/all-products${queryString ? `?${queryString}` : ""}`, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`
      },
    });
    const result = await res.json();
    if (!res.ok) throw new Error(result.message || "Failed to fetch products");
    return { success: true, data: result.data, meta: result.meta };
  } catch (error: any) {
    return { success: false, message: error.message };
  }
};

export const deleteProduct = async (id: string) => {
  try {
    const token = localStorage.getItem("accessToken");
    const res = await fetch(`${API_BASE_URL}/menu/${id}`, {
      method: "DELETE",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`
      },
    });

    const result = await res.json();
    if (!res.ok) throw new Error(result.message || "Failed to delete product");
    return { success: true };
  } catch (error: any) {
    return { success: false, message: error.message };
  }
};
