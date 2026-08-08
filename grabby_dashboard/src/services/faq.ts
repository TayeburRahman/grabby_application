import { API_BASE_URL } from "./auth";

export const getAllFaqs = async () => {
  try {
    const res = await fetch(`${API_BASE_URL}/faq`, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
      },
    });
    const result = await res.json();
    if (!res.ok) throw new Error(result.message || "Failed to fetch FAQs");
    return { success: true, data: result.data };
  } catch (error: any) {
    return { success: false, message: error.message };
  }
};

export const createFaq = async (data: { question: string; answer: string }) => {
  try {
    const token = localStorage.getItem("accessToken");
    const res = await fetch(`${API_BASE_URL}/faq`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`
      },
      body: JSON.stringify(data),
    });
    const result = await res.json();
    if (!res.ok) throw new Error(result.message || "Failed to create FAQ");
    return { success: true, data: result.data };
  } catch (error: any) {
    return { success: false, message: error.message };
  }
};

export const updateFaq = async (id: string, data: { question: string; answer: string }) => {
  try {
    const token = localStorage.getItem("accessToken");
    const res = await fetch(`${API_BASE_URL}/faq/${id}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`
      },
      body: JSON.stringify(data),
    });
    const result = await res.json();
    if (!res.ok) throw new Error(result.message || "Failed to update FAQ");
    return { success: true, data: result.data };
  } catch (error: any) {
    return { success: false, message: error.message };
  }
};

export const deleteFaq = async (id: string) => {
  try {
    const token = localStorage.getItem("accessToken");
    const res = await fetch(`${API_BASE_URL}/faq/${id}`, {
      method: "DELETE",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`
      },
    });
    const result = await res.json();
    if (!res.ok) throw new Error(result.message || "Failed to delete FAQ");
    return { success: true };
  } catch (error: any) {
    return { success: false, message: error.message };
  }
};
