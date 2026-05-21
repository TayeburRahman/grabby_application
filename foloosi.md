আপনার মোবাইল অ্যাপ বা কাস্টমার অ্যাপে পেমেন্ট সিস্টেমটি যুক্ত করার জন্য ব্যাকএন্ডে যে এপিআই-গুলো আপডেট বা নতুন তৈরি করা হয়েছে এবং সেগুলোর Payload (রিকোয়েস্ট) এবং Response (রেসপন্স) ডিটেইলস নিচে বিস্তারিত দেওয়া হলো:

১. অর্ডার তৈরি করা (Update: Create Order API)
কাস্টমার যখন অ্যাপ থেকে অর্ডারের জন্য চেকআউট বাটনে ক্লিক করবে, তখন অ্যাপ থেকে এই এপিআই-টি কল করতে হবে।

Endpoint: POST /orders

অ্যাপ থেকে যা পাঠাতে হবে (Request Payload):
আগে যেভাবে অর্ডার তৈরি করতেন ঠিক সেভাবেই পাঠাবেন, শুধু paymentMethod এর মান "card" অথবা "foloosi" দিতে হবে। (কার্ড পেমেন্টের জন্য আপনাকে কোনো transactionId পাঠাতে হবে না, এটি ফাকা রাখতে পারেন)।

json
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
  "paymentMethod": "card" // এখানে "card" বা "foloosi" পাঠাতে হবে
}
অ্যাপে ব্যাকএন্ড থেকে যা ফেরত আসবে (Response):
যদি paymentMethod "card" দেওয়া হয়, তবে ব্যাকএন্ড Foloosi গেটওয়ে থেকে একটি referenceToken জেনারেট করে অর্ডারের সাথে ফেরত পাঠাবে এবং পেমেন্ট স্ট্যাটাস থাকবে "unpaid"।

json
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
    "referenceToken": "e8807a6b-4496-4b4d-a101-7eec0cf60754", // 👈 Foloosi পেমেন্টের মূল টোকেন
    "status": "placed",
    "createdAt": "2026-05-21T05:33:00.000Z"
  }
}
অ্যাপে করণীয়: অ্যাপে এই referenceToken এবং আপনার মার্চেন্ট কি (live_$2y$10$6O0mhc6Iq.KtV2xyGFLaw.FEdhsn64OR7a9jV9zxvJ9ugSjck14IS) ব্যবহার করে Foloosi SDK অথবা পপআপ উইজেটটি ওপেন করে কাস্টমারকে কার্ড বা Apple Pay দিয়ে পে করতে বলবেন।

২. ইনস্ট্যান্ট পেমেন্ট ভেরিফিকেশন (New: Verify Payment API)
কাস্টমার যখন Foloosi পপআপে কার্ডের তথ্য দিয়ে সাকসেসফুলি পে করবে, তখন অ্যাপের Foloosi SDK সাকসেস ইভেন্ট ফায়ার করবে। কাস্টমারকে থ্যাংক ইউ বা সাকসেস স্ক্রিন দেখানোর আগে অ্যাপ থেকে নিশ্চিত হওয়ার জন্য এই এপিআই-টি কল করে পেমেন্ট স্ট্যাটাস চেক করতে হবে।

Endpoint: GET /orders/verify-payment/:orderId (এখানে :orderId হলো আগের অর্ডারের orderId যেমন: ORD-20260521-0001)
Headers:
http
Authorization: Bearer <user_token>
অ্যাপে ব্যাকএন্ড থেকে যা ফেরত আসবে (Response):
যদি Foloosi-র Webhook ইতিমধ্যে ব্যাকএন্ডে পেমেন্ট সফল হিসেবে প্রসেস করে থাকে, তবে আপনি এপিআই থেকে সরাসরি paymentStatus: "paid" এবং transactionId পেয়ে যাবেন।

json
{
  "success": true,
  "statusCode": 200,
  "message": "Payment verification status retrieved successfully",
  "data": {
    "orderId": "ORD-20260521-0001",
    "paymentStatus": "paid", // 👈 যদি "paid" হয়, তবে অ্যাপে পেমেন্ট সফল দেখাবেন
    "transactionId": "FLS61a859e4a8977", // Foloosi-র দেওয়া আসল ট্রানজেকশন নাম্বার
    "referenceToken": "e8807a6b-4496-4b4d-a101-7eec0cf60754"
  }
}
৩. পেমেন্ট ওয়েবহুক (New: Webhook API)
এই এপিআই-টি শুধুমাত্র Foloosi সার্ভারের জন্য তৈরি করা হয়েছে। Foloosi পেমেন্ট শেষ হওয়ার সাথে সাথে তার নিজস্ব সার্ভার থেকে সরাসরি রিয়েল-টাইমে এই এপিআই-তে হিট করে পেমেন্ট সাকসেস কনফার্ম করবে।

Endpoint: POST /orders/payment-webhook (এটি পাবলিক, কোনো Auth টোকেন লাগবে না)
কাজ: এটি ব্যাকএন্ডে অর্ডারকে পেইড মার্ক করে, কাস্টমারের পয়েন্ট এবং স্ট্যাম্প যোগ করে এবং শপ ওনারকে নতুন অর্ডারের পুশ নোটিফিকেশন পাঠায়।
অ্যাপে করণীয়: অ্যাপের এই এপিআই-তে কোনো কল করার প্রয়োজন নেই। Foloosi প্যানেলের সেটিংসে গিয়ে শুধু এই লিংকটি Webhook URL হিসেবে সেটআপ করে দিলেই হবে: https://YOUR_BACKEND_URL/orders/payment-webhook।

📱 অ্যাপ ইন্টিগ্রেশনের সংক্ষিপ্ত সারসংক্ষেপ (Quick App Integration Logic)
কাস্টমার চেকআউটে Card/Apple Pay সিলেক্ট করলে paymentMethod: 'card' দিয়ে POST /orders কল করুন।
রেসপন্স থেকে referenceToken সংগ্রহ করুন।
Foloosi SDK পপআপ চালু করুন এবং পেমেন্ট সম্পন্ন করুন।
পেমেন্ট শেষে GET /orders/verify-payment/ORD-XXXX এপিআই কল করুন।
স্ট্যাটাস "paid" হলে কাস্টমারকে সফল অর্ডারের স্ক্রিন দেখান! আর কোনো কারণে ফেইল হলে ট্রাই এগেইন দেখান।