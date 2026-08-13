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

/**
 * Create a Stripe Express Connect account for a shop owner.
 */
export const createStripeExpressAccount = async (email: string) => {
  try {
    const account = await stripe.accounts.create({
      type: 'express',
      country: 'AE',
      email,
      capabilities: {
        transfers: { requested: true },
      },
    });

    return {
      success: true,
      accountId: account.id,
    };
  } catch (error: any) {
    console.error('Stripe Create Account Error:', error.message);
    return {
      success: false,
      error: error.message || 'Failed to create Stripe Connect account',
    };
  }
};

/**
 * Create an Account Link URL for shop owner bank onboarding.
 */
export const createStripeAccountLink = async (
  accountId: string,
  returnUrl?: string,
  refreshUrl?: string
) => {
  try {
    const accountLink = await stripe.accountLinks.create({
      account: accountId,
      refresh_url: refreshUrl || 'https://yourdomain.com/stripe-connect/refresh',
      return_url: returnUrl || 'https://yourdomain.com/stripe-connect/return',
      type: 'account_onboarding',
    });

    return {
      success: true,
      url: accountLink.url,
    };
  } catch (error: any) {
    console.error('Stripe Account Link Error:', error.message);
    return {
      success: false,
      error: error.message || 'Failed to generate Stripe onboarding link',
    };
  }
};

/**
 * Retrieve status and external bank details of a Stripe Connect account.
 */
export const getStripeAccountDetails = async (accountId: string) => {
  try {
    const account = await stripe.accounts.retrieve(accountId);
    const isConnected = account.details_submitted && account.payouts_enabled;

    let bankDetails: any = null;
    if (account.external_accounts && account.external_accounts.data.length > 0) {
      const bank = account.external_accounts.data[0] as Stripe.BankAccount;
      bankDetails = {
        bankName: bank.bank_name || 'Bank',
        routingNumber: bank.routing_number || '',
        accountNumberLast4: bank.last4 || '',
        accountHolderName: bank.account_holder_name || '',
        currency: bank.currency || 'aed',
      };
    }

    return {
      success: true,
      detailsSubmitted: account.details_submitted,
      payoutsEnabled: account.payouts_enabled,
      chargesEnabled: account.charges_enabled,
      isConnected,
      bankDetails,
    };
  } catch (error: any) {
    console.error('Stripe Retrieve Account Error:', error.message);
    return {
      success: false,
      error: error.message || 'Failed to retrieve Stripe account details',
    };
  }
};

/**
 * Transfer funds (e.g. 90% of order total) to shop owner's connected Stripe account.
 */
export const transferToShopOwnerAccount = async (payload: {
  amountInAED: number;
  destinationAccountId: string;
  orderId: string;
}) => {
  try {
    const amountInCents = Math.round(payload.amountInAED * 100);

    const transfer = await stripe.transfers.create({
      amount: amountInCents,
      currency: 'aed',
      destination: payload.destinationAccountId,
      transfer_group: payload.orderId,
      description: `90% payout for completed order ${payload.orderId}`,
    });

    return {
      success: true,
      transferId: transfer.id,
    };
  } catch (error: any) {
    console.error('Stripe Transfer Error:', error.message);
    return {
      success: false,
      error: error.message || 'Failed to transfer funds to shop owner bank account',
    };
  }
};

