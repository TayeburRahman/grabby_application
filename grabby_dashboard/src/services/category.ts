import { API_BASE_URL } from "./auth";

export const getAllCategories = async () => {
  try {
    const token = localStorage.getItem("accessToken");
    const res = await fetch(`${API_BASE_URL}/admin/all-categories`, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`
      },
    });
    const result = await res.json();
    if (!res.ok) throw new Error(result.message || "Failed to fetch categories");
    return { success: true, data: result.data };
  } catch (error: any) {
    return { success: false, message: error.message };
  }
};

export const getCategoriesByBranch = async (branchId: string) => {
  try {
    const res = await fetch(`${API_BASE_URL}/menu-category/branch/${branchId}`, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
      },
    });
    const result = await res.json();
    if (!res.ok) throw new Error(result.message || "Failed to fetch branch categories");
    return { success: true, data: result.data };
  } catch (error: any) {
    return { success: false, message: error.message };
  }
};
