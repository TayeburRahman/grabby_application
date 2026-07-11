import Stripe from 'stripe';
import config from '../config';

const stripe = new Stripe(config.stripe.stripe_secret_key as string, {
  apiVersion: '2024-04-10',
});

export const initializeStripePayment = async (orderData: {
  amount: number;
  customerName: string;
  email: string;
  phone: string;
  orderId: string;
}) => {
  try {
    // amount in AED needs to be in fils (cents)
    const amountInCents = Math.round(orderData.amount * 100);

    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      line_items: [
        {
          price_data: {
            currency: 'aed',
            product_data: {
              name: `Order ${orderData.orderId}`,
            },
            unit_amount: amountInCents,
          },
          quantity: 1,
        },
      ],
      mode: 'payment',
      // Update these URLs with your actual app deep links or website URLs
      success_url: `https://yourdomain.com/payment-success?orderId=${orderData.orderId}`,
      cancel_url: `https://yourdomain.com/payment-cancel?orderId=${orderData.orderId}`,
      client_reference_id: orderData.orderId,
      metadata: {
        orderId: orderData.orderId,
        customerName: orderData.customerName,
        email: orderData.email,
        phone: orderData.phone,
      },
    });

    return {
      success: true,
      reference_token: session.url, // This is now a full Checkout URL
    };
  } catch (error: any) {
    console.error('Stripe Initialize Error:', error.message);
    return {
      success: false,
      error: error.message || 'Stripe initialization failed',
    };
  }
};
