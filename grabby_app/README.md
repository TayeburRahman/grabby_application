flutter precache --force --ios --verbose
#fix the issue for flutter framework not found

@contextScopeItemMention from here u need to perferom hit an post api 
endpoint: /orders
body: {
  "branchId": "{{branchId}}",
  "items": [
    {
      "productId": "{{menuId}}",
      "menuName": "Cappuccino Deluxe",
      "menuPrice": 22,
      "menuImage": "/images/image/cappuccino.png",
      "quantity": 1,
      "additionalItems": [
        {
          "itemId": "69abda42ddcc21dbd181cca9",
          "name": "Whipped Cream",
          "price": 2.5,
          "quantity": 1
        }
      ],
      "totalPrice": 24.5
    }
  ],
  "pickupType": "carPickup",
 
  "totalAmount": 24.5, //this payment will be subtotal alwys from cart model
  "paymentMethod": "Credit Card",
  "carPlates": "DXB 12345"
}
nd payment is just credit card right now 
@contextScopeItemMention in this page  show data from the post method response , here is response : {
    "statusCode": 201,
    "success": true,
    "message": "Order created successfully",
    "data": {
        "orderId": "ORD-260423-0002",
        "customerId": "69abe179ddcc21dbd181ccce",
        "branchId": "69abda42ddcc21dbd181cca9",
        "items": [
            {
                "productId": "69d5f135f11015b5775a951f",
                "menuName": "Cappuccino Deluxe",
                "menuPrice": 22,
                "menuImage": "/images/image/cappuccino.png",
                "quantity": 1,
                "additionalItems": [
                    {
                        "itemId": "69abda42ddcc21dbd181cca9",
                        "name": "Whipped Cream",
                        "price": 2.5,
                        "quantity": 1,
                        "_id": "69e9a0d9c9ceacd1afab7583",
                        "id": "69e9a0d9c9ceacd1afab7583"
                    }
                ],
                "totalPrice": 24.5,
                "_id": "69e9a0d9c9ceacd1afab7582"
            }
        ],
        "pickupType": "carPickup",
        "applyGrabbyCredit": 0,
        "applyPromoCode": 0,
        "totalAmount": 24.5,
        "carPlates": "DXB 12345",
        "status": "pending",
        "paymentStatus": "paid",
        "paymentMethod": "Credit Card",
        "transactionId": "6478ytwefgfwe456743654",
        "_id": "69e9a0d9c9ceacd1afab7581",
        "createdAt": "2026-04-23T04:32:25.803Z",
        "updatedAt": "2026-04-23T04:32:25.803Z",
        "__v": 0,
        "id": "69e9a0d9c9ceacd1afab7581"
    }
}

and then for get order list 
end point :/orders/my-orders?status=placed&status=preparing/page=1&limit=10
- status for active orders = placed, preparing, ready
- status for all no need to add status params 
-status for complete = completed
-status for cancel = cancelled

@contextScopeItemMention u need to implement it here 
here is response : {
    "statusCode": 200,
    "success": true,
    "message": "Orders retrieved successfully",
    "meta": {
        "page": 1,
        "limit": 10,
        "total": 2,
        "totalPage": 1
    },
    "data": [
        {
            "_id": "69e9c6937a78785a5ecd83dc",
            "orderId": "ORD-260423-0002",
            "customerId": "69abe179ddcc21dbd181ccce",
            "branchId": {
                "_id": "69abda42ddcc21dbd181cca9",
                "branch_name": "Branch 2 - JBR",
                "address": "JBR The Walk, Shop 5"
            },
            "items": [
                {
                    "productId": "69d5f135f11015b5775a951f",
                    "menuName": "Cappuccino Deluxe",
                    "menuPrice": 22,
                    "menuImage": "/images/image/cappuccino.png",
                    "quantity": 1,
                    "additionalItems": [
                        {
                            "itemId": "69abda42ddcc21dbd181cca9",
                            "name": "Whipped Cream",
                            "price": 2.5,
                            "quantity": 1,
                            "_id": "69e9c6937a78785a5ecd83de",
                            "id": "69e9c6937a78785a5ecd83de"
                        }
                    ],
                    "totalPrice": 24.5,
                    "_id": "69e9c6937a78785a5ecd83dd"
                }
            ],
            "pickupType": "carPickup",
            "applyGrabbyCredit": 0,
            "applyPromoCode": 0,
            "totalAmount": 24.5,
            "carPlates": "DXB 12345",
            "status": "placed",
            "paymentStatus": "paid",
            "paymentMethod": "Credit Card",
            "transactionId": "6478ytwefgfwe456743654",
            "createdAt": "2026-04-23T07:13:23.766Z",
            "updatedAt": "2026-04-23T07:13:23.766Z",
            "id": "69e9c6937a78785a5ecd83dc"
        },
        {
            "_id": "69e9a77a512b83dcfc57e114",
            "orderId": "ORD-260423-0001",
            "customerId": "69abe179ddcc21dbd181ccce",
            "branchId": {
                "_id": "69abda42ddcc21dbd181cca9",
                "branch_name": "Branch 2 - JBR",
                "address": "JBR The Walk, Shop 5"
            },
            "items": [
                {
                    "productId": "69d5f135f11015b5775a951f",
                    "menuName": "Cappuccino Deluxe",
                    "menuPrice": 22,
                    "menuImage": "/images/image/cappuccino.png",
                    "quantity": 1,
                    "additionalItems": [
                        {
                            "itemId": "69abda42ddcc21dbd181cca9",
                            "name": "Whipped Cream",
                            "price": 2.5,
                            "quantity": 1,
                            "_id": "69e9a77a512b83dcfc57e116",
                            "id": "69e9a77a512b83dcfc57e116"
                        }
                    ],
                    "totalPrice": 24.5,
                    "_id": "69e9a77a512b83dcfc57e115"
                }
            ],
            "pickupType": "carPickup",
            "applyGrabbyCredit": 0,
            "applyPromoCode": 0,
            "totalAmount": 24.5,
            "carPlates": "DXB 12345",
            "status": "preparing",
            "paymentStatus": "paid",
            "paymentMethod": "Credit Card",
            "transactionId": "6478ytwefgfwe456743654",
            "createdAt": "2026-04-23T05:00:42.957Z",
            "updatedAt": "2026-04-23T05:13:16.141Z",
            "id": "69e9a77a512b83dcfc57e114"
        }
    ]
}

@contextScopeItemMention 
in here it will load order details page 
end point: /orders/{{orderId}}, 

{

    "statusCode": 200,

    "success": true,

    "message": "Order retrieved successfully",

    "data": {

        "_id": "69e9c6937a78785a5ecd83dc",

        "orderId": "ORD-260423-0002",

        "customerId": {

            "_id": "69abe179ddcc21dbd181ccce",

            "name": "John Updated",

            "email": "tss.sta.gpt@gmail.com",

            "phone_number": "+971501234567"

        },

        "branchId": {

            "_id": "69abda42ddcc21dbd181cca9",

            "shopOwnerId": "69abd78b7cd774b6e0a41acd",

            "branch_name": "Branch 2 - JBR",

            "address": "JBR The Walk, Shop 5",

            "lat": 25.0773,

            "lng": 55.133,

            "phone_number": "+971504445566",

            "availability": [

                {

                    "day": "Sunday",

                    "open": "7:00 AM",

                    "close": "11:00 PM",

                    "isClosed": false

                },

                {

                    "day": "Monday",

                    "open": "7:00 AM",

                    "close": "11:00 PM",

                    "isClosed": false

                },

                {

                    "day": "Tuesday",

                    "open": "7:00 AM",

                    "close": "11:00 PM",

                    "isClosed": false

                },

                {

                    "day": "Wednesday",

                    "open": "7:00 AM",

                    "close": "11:00 PM",

                    "isClosed": false

                },

                {

                    "day": "Thursday",

                    "open": "7:00 AM",

                    "close": "12:00 AM",

                    "isClosed": false

                },

                {

                    "day": "Friday",

                    "open": "2:00 PM",

                    "close": "12:00 AM",

                    "isClosed": false

                },

                {

                    "day": "Saturday",

                    "open": "8:00 AM",

                    "close": "11:00 PM",

                    "isClosed": false

                }

            ],

            "applyMenuForAll": false,

            "__v": 0,

            "createdAt": "2026-03-07T07:56:50.375Z",

            "updatedAt": "2026-03-07T07:56:50.375Z"

        },

        "items": [

            {

                "productId": "69d5f135f11015b5775a951f",

                "menuName": "Cappuccino Deluxe",

                "menuPrice": 22,

                "menuImage": "/images/image/cappuccino.png",

                "quantity": 1,

                "additionalItems": [

                    {

                        "itemId": "69abda42ddcc21dbd181cca9",

                        "name": "Whipped Cream",

                        "price": 2.5,

                        "quantity": 1,

                        "_id": "69e9c6937a78785a5ecd83de",

                        "id": "69e9c6937a78785a5ecd83de"

                    }

                ],

                "totalPrice": 24.5,

                "_id": "69e9c6937a78785a5ecd83dd"

            }

        ],

        "pickupType": "carPickup",

        "applyGrabbyCredit": 0,

        "applyPromoCode": 0,

        "totalAmount": 24.5,

        "carPlates": "DXB 12345",

        "status": "placed",

        "paymentStatus": "paid",

        "paymentMethod": "Credit Card",

        "transactionId": "6478ytwefgfwe456743654",

        "createdAt": "2026-04-23T07:13:23.766Z",

        "updatedAt": "2026-04-23T07:13:23.766Z",

        "__v": 0,

        "id": "69e9c6937a78785a5ecd83dc"

    }

}



here is response 
status will be this 'placed', 'preparing', 'ready', 'completed' it will by dynamic step by step 
implement call function to that branch num @contextScopeItemMention 
here show shop on map 
shop name order id  for now notify shop will be as it is 

______________ this is all for customer side ___________


@contextScopeItemMention 
need to show the dynamic branches 
@contextScopeItemMention 
from here u will get the list 
@contextScopeItemMention 
here u need to show this tabs 
'placed', 'preparing', 'ready', 'completed', 'cancelled'

end point for get order list : orders/branch/{{branchId}}?status=placed&page=1&limit=10
response : {
    "statusCode": 200,
    "success": true,
    "message": "Branch orders retrieved successfully",
    "meta": {
        "page": 1,
        "limit": 10,
        "total": 1,
        "totalPage": 1
    },
    "data": [
        {
            "_id": "69e9a77a512b83dcfc57e114",
            "orderId": "ORD-260423-0001",
            "customerId": {
                "_id": "69abe179ddcc21dbd181ccce",
                "name": "John Updated",
                "email": "tss.sta.gpt@gmail.com",
                "phone_number": "+971501234567"
            },
            "branchId": "69abda42ddcc21dbd181cca9",
            "items": [
                {
                    "productId": "69d5f135f11015b5775a951f",
                    "menuName": "Cappuccino Deluxe",
                    "menuPrice": 22,
                    "menuImage": "/images/image/cappuccino.png",
                    "quantity": 1,
                    "additionalItems": [
                        {
                            "itemId": "69abda42ddcc21dbd181cca9",
                            "name": "Whipped Cream",
                            "price": 2.5,
                            "quantity": 1,
                            "_id": "69e9a77a512b83dcfc57e116",
                            "id": "69e9a77a512b83dcfc57e116"
                        }
                    ],
                    "totalPrice": 24.5,
                    "_id": "69e9a77a512b83dcfc57e115"
                }
            ],
            "pickupType": "carPickup",
            "applyGrabbyCredit": 0,
            "applyPromoCode": 0,
            "totalAmount": 24.5,
            "carPlates": "DXB 12345",
            "status": "placed",
            "paymentStatus": "paid",
            "paymentMethod": "Credit Card",
            "transactionId": "6478ytwefgfwe456743654",
            "createdAt": "2026-04-23T05:00:42.957Z",
            "updatedAt": "2026-04-23T05:00:42.957Z",
            "id": "69e9a77a512b83dcfc57e114"
        }
    ]
}
@contextScopeItemMention 
right now this part need to comment out 
@contextScopeItemMention 
right now it will be unpaid just 


@contextScopeItemMention 
here need to show order details : 
end point: 
/orders/{{orderId}}
response : {
    "statusCode": 200,
    "success": true,
    "message": "Order retrieved successfully",
    "data": {
        "_id": "69e9a77a512b83dcfc57e114",
        "orderId": "ORD-260423-0001",
        "customerId": {
            "_id": "69abe179ddcc21dbd181ccce",
            "name": "John Updated",
            "email": "tss.sta.gpt@gmail.com",
            "phone_number": "+971501234567"
        },
        "branchId": {
            "_id": "69abda42ddcc21dbd181cca9",
            "branch_name": "Branch 2 - JBR",
            "address": "JBR The Walk, Shop 5"
        },
        "items": [
            {
                "productId": "69d5f135f11015b5775a951f",
                "menuName": "Cappuccino Deluxe",
                "menuPrice": 22,
                "menuImage": "/images/image/cappuccino.png",
                "quantity": 1,
                "additionalItems": [
                    {
                        "itemId": "69abda42ddcc21dbd181cca9",
                        "name": "Whipped Cream",
                        "price": 2.5,
                        "quantity": 1,
                        "_id": "69e9a77a512b83dcfc57e116",
                        "id": "69e9a77a512b83dcfc57e116"
                    }
                ],
                "totalPrice": 24.5,
                "_id": "69e9a77a512b83dcfc57e115"
            }
        ],
        "pickupType": "carPickup",
        "applyGrabbyCredit": 0,
        "applyPromoCode": 0,
        "totalAmount": 24.5,
        "carPlates": "DXB 12345",
        "status": "placed",
        "paymentStatus": "paid",
        "paymentMethod": "Credit Card",
        "transactionId": "6478ytwefgfwe456743654",
        "createdAt": "2026-04-23T05:00:42.957Z",
        "updatedAt": "2026-04-23T05:00:42.957Z",
        "__v": 0,
        "id": "69e9a77a512b83dcfc57e114"
    }
}
@contextScopeItemMention 
from here need update status 
endpoint: /orders/{{orderId}}/status
body: {
  "status": "preparing"
}
response : {
    "statusCode": 200,
    "success": true,
    "message": "Order status updated successfully",
    "data": {
        "_id": "69e9a77a512b83dcfc57e114",
        "orderId": "ORD-260423-0001",
        "customerId": "69abe179ddcc21dbd181ccce",
        "branchId": "69abda42ddcc21dbd181cca9",
        "items": [
            {
                "productId": "69d5f135f11015b5775a951f",
                "menuName": "Cappuccino Deluxe",
                "menuPrice": 22,
                "menuImage": "/images/image/cappuccino.png",
                "quantity": 1,
                "additionalItems": [
                    {
                        "itemId": "69abda42ddcc21dbd181cca9",
                        "name": "Whipped Cream",
                        "price": 2.5,
                        "quantity": 1,
                        "_id": "69e9a77a512b83dcfc57e116",
                        "id": "69e9a77a512b83dcfc57e116"
                    }
                ],
                "totalPrice": 24.5,
                "_id": "69e9a77a512b83dcfc57e115"
            }
        ],
        "pickupType": "carPickup",
        "applyGrabbyCredit": 0,
        "applyPromoCode": 0,
        "totalAmount": 24.5,
        "carPlates": "DXB 12345",
        "status": "preparing",
        "paymentStatus": "paid",
        "paymentMethod": "Credit Card",
        "transactionId": "6478ytwefgfwe456743654",
        "createdAt": "2026-04-23T05:00:42.957Z",
        "updatedAt": "2026-04-23T05:13:16.141Z",
        "__v": 0,
        "id": "69e9a77a512b83dcfc57e114"
    }
}

 after update autometicaly refresh that page @contextScopeItemMention 
nd tab will be change automatically based on update status 
_______________ this is all shop owner order system-----------------

every page must have refresh feature implemented use sliver so can empty list also can be refresh 
set dynamic data 
and avoid unnecessary complexity 

