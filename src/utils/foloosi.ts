import axios from 'axios';
import config from '../config';

export const initializeFoloosiPayment = async (orderData: {
  amount: number;
  customerName: string;
  email: string;
  phone: string;
  orderId: string;
}) => {
  const url = 'https://api.foloosi.com/aggregatorapi/web/initialize-setup';
  
  const headers = {
    'secret_key': config.foloosi.secret_key,
    'Content-Type': 'application/json'
  };

  const body = {
    currency: 'AED', // UAE Dirham
    transaction_amount: orderData.amount,
    customer_name: orderData.customerName || 'Customer',
    customer_email: orderData.email || 'customer@example.com',
    customer_mobile: orderData.phone || '0000000000',
    description: `Order payment for ${orderData.orderId}`,
    optional1: orderData.orderId, // We use this in webhook to identify the order
  };

  try {
    const response = await axios.post(url, body, { headers });
    if (response.data && response.data.data) {
      return {
        success: true,
        reference_token: response.data.data.reference_token
      };
    }
    return {
      success: false,
      error: response.data?.message || 'Foloosi initialization failed'
    };
  } catch (error: any) {
    console.error('Foloosi Initialize Error:', error.response?.data || error.message);
    return {
      success: false,
      error: error.response?.data?.message || error.message
    };
  }
};
