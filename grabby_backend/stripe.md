আপনার মোবাইল অ্যাপ বা কাস্টমার অ্যাপে পেমেন্ট সিস্টেমটি যুক্ত করার জন্য ব্যাকএন্ডে যে এপিআই-গুলো আপডেট বা নতুন তৈরি করা হয়েছে এবং সেগুলোর Payload (রিকোয়েস্ট) এবং Response (রেসপন্স) ডিটেইলস নিচে বিস্তারিত দেওয়া হলো:

১. অর্ডার তৈরি করা (Update: Create Order API)
কাস্টমার যখন অ্যাপ থেকে অর্ডারের জন্য চেকআউট বাটনে ক্লিক করবে, তখন অ্যাপ থেকে এই এপিআই-টি কল করতে হবে।

Endpoint: POST /orders

অ্যাপ থেকে যা পাঠাতে হবে (Request Payload):
আগে যেভাবে অর্ডার তৈরি করতেন ঠিক সেভাবেই পাঠাবেন, শুধু paymentMethod এর মান "card" অথবা "stripe" দিতে হবে। (কার্ড পেমেন্টের জন্য আপনাকে কোনো transactionId পাঠাতে হবে না, এটি ফাকা রাখতে পারেন)।

```json
{
  "branchId": "65e2b4f17c4b1d001f5f24d2",
  "items": [
    {
      "productId": "65e2b5b37c4b1d001f5f24d9",
      "menuName": "Spaghetti Carbonara",
      "menuPrice": 45.00,
      "menuImage": "/images/products/spaghetti.jpg",
      "quantity": 1,
      "additionalItems": [],
      "totalPrice": 45.00
    }
  ],
  "pickupType": "carPickup",
  "carPlates": "DXB-A-12345",
  "totalAmount": 45.00,
  "paymentMethod": "card" // এখানে "card" বা "stripe" পাঠাতে হবে
}
```

অ্যাপে ব্যাকএন্ড থেকে যা ফেরত আসবে (Response):
যদি paymentMethod "card" বা "stripe" দেওয়া হয়, তবে ব্যাকএন্ড Stripe-এর একটি **Checkout Session URL** জেনারেট করে অর্ডারের সাথে ফেরত পাঠাবে এবং পেমেন্ট স্ট্যাটাস থাকবে "unpaid"।

```json
{
  "success": true,
  "statusCode": 201,
  "message": "Order created successfully",
  "data": {
    "_id": "664c1a5b8d2345001ff2345a",
    "orderId": "ORD-20260521-0001", // আপনার জেনারেট হওয়া অর্ডার আইডি
    "customerId": "65e2b2a17c4b1d001f5f24c0",
    "branchId": "65e2b4f17c4b1d001f5f24d2",
    "totalAmount": 45.00,
    "paymentMethod": "card",
    "paymentStatus": "unpaid", // পেমেন্ট না হওয়া পর্যন্ত এটি unpaid থাকবে
    "transactionId": "", // খালি থাকবে
    "referenceToken": "https://checkout.stripe.com/c/pay/cs_test_...", // 👈 Stripe Checkout URL
    "status": "placed",
    "createdAt": "2026-05-21T05:33:00.000Z"
  }
}
```

অ্যাপে করণীয়: অ্যাপে এই `referenceToken`-এর লিংকে কাস্টমারকে রিডাইরেক্ট করে দিতে হবে (ইন-অ্যাপ ব্রাউজার বা ওয়েবভিউ এর মাধ্যমে)। কাস্টমার সেখানে পেমেন্ট সম্পন্ন করার পর আপনার দেওয়া Success URL বা Cancel URL-এ আবার ফিরে আসবে।

২. ইনস্ট্যান্ট পেমেন্ট ভেরিফিকেশন (New: Verify Payment API)
কাস্টমার যখন Success URL-এ ফিরে আসবে, তখন অ্যাপ থেকে নিশ্চিত হওয়ার জন্য এই এপিআই-টি কল করে পেমেন্ট স্ট্যাটাস চেক করতে হবে।

Endpoint: GET /orders/verify-payment/:orderId (এখানে :orderId হলো আগের অর্ডারের orderId যেমন: ORD-20260521-0001)
Headers:
```http
Authorization: Bearer <user_token>
```

অ্যাপে ব্যাকএন্ড থেকে যা ফেরত আসবে (Response):
যদি Stripe-এর Webhook ইতিমধ্যে ব্যাকএন্ডে পেমেন্ট সফল হিসেবে প্রসেস করে থাকে, তবে আপনি এপিআই থেকে সরাসরি paymentStatus: "paid" এবং transactionId পেয়ে যাবেন।

```json
{
  "success": true,
  "statusCode": 200,
  "message": "Payment verification status retrieved successfully",
  "data": {
    "orderId": "ORD-20260521-0001",
    "paymentStatus": "paid", // 👈 যদি "paid" হয়, তবে অ্যাপে পেমেন্ট সফল দেখাবেন
    "transactionId": "pi_3M...", // Stripe-এর দেওয়া আসল ট্রানজেকশন নাম্বার
    "referenceToken": "https://checkout.stripe.com/..."
  }
}
```

৩. পেমেন্ট ওয়েবহুক (New: Webhook API)
এই এপিআই-টি শুধুমাত্র Stripe সার্ভারের জন্য তৈরি করা হয়েছে। Stripe পেমেন্ট শেষ হওয়ার সাথে সাথে তার নিজস্ব সার্ভার থেকে সরাসরি রিয়েল-টাইমে এই এপিআই-তে হিট করে পেমেন্ট সাকসেস কনফার্ম করবে।

Endpoint: POST /orders/payment-webhook (এটি পাবলিক, কোনো Auth টোকেন লাগবে না)
কাজ: এটি ব্যাকএন্ডে অর্ডারকে পেইড মার্ক করে, কাস্টমারের পয়েন্ট এবং স্ট্যাম্প যোগ করে এবং শপ ওনারকে নতুন অর্ডারের পুশ নোটিফিকেশন পাঠায়।
অ্যাপে করণীয়: অ্যাপের এই এপিআই-তে কোনো কল করার প্রয়োজন নেই। Stripe ড্যাশবোর্ডের Webhooks সেটিংসে গিয়ে শুধু এই লিংকটি Endpoint URL হিসেবে সেটআপ করে দিলেই হবে: https://YOUR_BACKEND_URL/orders/payment-webhook এবং ইভেন্ট হিসেবে `checkout.session.completed` সিলেক্ট করতে হবে।

৪. শপ ওনার ব্যাংক অ্যাকাউন্ট অনবোর্ডিং (New: Stripe Connect Onboarding API)
শপ ওনার অ্যাকাউন্ট তৈরি করার পর তাদের ব্যাংক অ্যাকাউন্ট (IBAN/Bank Details) যুক্ত করার জন্য এই এপিআই-টি কল করে Stripe Express Onboarding লিংক জেনারেট করতে হবে।

Endpoint: POST /shop-owner/stripe-connect/onboarding-link
Headers:
```http
Authorization: Bearer <shop_owner_token>
```
Payload (Optional):
```json
{
  "returnUrl": "https://yourdomain.com/stripe-connect/return",
  "refreshUrl": "https://yourdomain.com/stripe-connect/refresh"
}
```

Response:
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Stripe Connect onboarding link generated successfully.",
  "data": {
    "url": "https://connect.stripe.com/express/onboarding/...", // 👈 শপ ওনারকে ইন-অ্যাপ ওয়েবভিউতে নিয়ে যান
    "stripeAccountId": "acct_1P...",
    "stripeAccountConnected": false,
    "stripeAccountStatus": "pending"
  }
}
```
অ্যাপে করণীয়: রেসপন্স পাওয়া `url` লিংকে শপ ওনারকে রিডাইরেক্ট করুন। সেখানে শপ ওনার তাদের ব্যাংকের তথ্য ও IBAN পূরণ করবে।

৫. শপ ওনার ব্যাংক কানেকশন স্ট্যাটাস (New: Stripe Connect Status API)
শপ ওনার ব্যাংক অ্যাকাউন্ট সংযুক্ত করেছে কিনা এবং ব্যাংকের সামারি তথ্য দেখার জন্য এই এপিআই-টি ব্যবহার করুন।

Endpoint: GET /shop-owner/stripe-connect/status
Headers:
```http
Authorization: Bearer <shop_owner_token>
```

Response:
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Stripe Connect status retrieved successfully.",
  "data": {
    "stripeAccountId": "acct_1P...",
    "stripeAccountConnected": true, // 👈 true হলে ব্যাংক সংযুক্ত আছে
    "stripeAccountStatus": "active",
    "bankDetails": {
      "bankName": "Emirates NBD",
      "routingNumber": "123456",
      "accountNumberLast4": "4321",
      "accountHolderName": "John Doe",
      "currency": "aed"
    }
  }
}
```

৬. অর্ডার কমপ্লিট হলে স্বয়ংক্রিয় পেমেন্ট স্প্লিট (Auto 90% Shop Owner / 10% Admin Split)
যখন কোনো পেইড অর্ডারের স্ট্যাটাস "completed" এ আপডেট করা হয় (`PATCH /orders/:id/status`), ব্যাকএন্ড স্বয়ংক্রিয়ভাবে মোট টাকার **৯০% শপ ওনারের সংযুক্ত ব্যাংক অ্যাকাউন্টে পাঠাবে** এবং **১০% অ্যাডমিন ফি হিসেবে প্ল্যাটফর্মে থেকে যাবে**।

যদি কোনো কারণে শপ ওনার ব্যাংক অ্যাকাউন্ট আগে থেকে যুক্ত না করে পরে যুক্ত করে, তবে রিট্রাই করার জন্য এই এপিআই-টি কল করতে পারবেন:
Endpoint: POST /orders/:id/retry-payout
Headers:
```http
Authorization: Bearer <shop_owner_or_admin_token>
```

📱 অ্যাপ ইন্টিগ্রেশনের সংক্ষিপ্ত সারসংক্ষেপ (Quick App Integration Logic)
১. কাস্টমার চেকআউটে Card/Apple Pay সিলেক্ট করলে paymentMethod: 'stripe' দিয়ে POST /orders কল করুন।
২. রেসপন্স থেকে referenceToken (Checkout URL) সংগ্রহ করুন।
৩. কাস্টমারকে এই URL-এ ব্রাউজার বা ওয়েবভিউ দিয়ে রিডাইরেক্ট করুন।
৪. কাস্টমার পেমেন্ট সম্পন্ন করে ফিরে আসার পর GET /orders/verify-payment/ORD-XXXX এপিআই কল করুন।
৫. স্ট্যাটাস "paid" হলে কাস্টমারকে সফল অর্ডারের স্ক্রিন দেখান!
৬. শপ ওনার অ্যাকাউন্ট খোলার পর POST /shop-owner/stripe-connect/onboarding-link কল করে তাদের ব্যাংক অ্যাকাউন্ট যুক্ত করতে ইন-অ্যাপ ওয়েবভিউতে পাঠান।
৭. অর্ডার সম্পন্ন (Completed) হলে ৯০% পেমেন্ট অটো শপ ওনারের ব্যাংক অ্যাকাউন্টে চলে যাবে এবং ১০% অ্যাডমিন পকেটে থাকবে!

