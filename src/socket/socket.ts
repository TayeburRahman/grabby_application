import { Server, Socket } from 'socket.io';
// import { handleNotification } from '../app/modules/notification/notification.service';
// import { handlePartnerData } from '../app/modules/partner/partner.socket';
// import { handleMessageData } from '../app/modules/message/message.socket';
import { ENUM_SOCKET_EVENT } from '../enums/user';
import { Order } from '../app/modules/order/order.model';
import Customer from '../app/modules/customers/customers.model';
import { Branch, ShopOwner } from '../app/modules/shop_owner/shop_owner.model';

// Set to keep track of online users
const onlineUsers = new Set<string>();

const socket = (io: Server) => {
  io.on(ENUM_SOCKET_EVENT.CONNECT, async (socket: Socket) => {
    const currentUserId = socket.handshake.query.id as string;
    const role = socket.handshake.query.role as string;

    socket.join(currentUserId);
    console.log("A user connected", currentUserId);

    // Add the user to the online users set
    onlineUsers.add(currentUserId);
    io.emit("onlineUser", Array.from(onlineUsers));

    // Handle message events
    // await handleMessageData(currentUserId, role, socket, io);

    // Handle notifications events
    // await handleNotification(currentUserId, role, socket, io);

    // Handle partner events
    // await handlePartnerData(currentUserId, role, socket, io);

    // Handle location update for orders
    socket.on('updateLocation', async (data: { lat: number; lon: number }) => {
      try {
        const { lat, lon } = data;

        // 1. Update Customer location in DB
        await Customer.findByIdAndUpdate(currentUserId, { lat, lon });

        // 2. Find all active orders for this customer
        const activeOrders = await Order.find({
          customerId: currentUserId,
          status: { $in: ['placed', 'preparing', 'ready'] }
        });

        if (activeOrders.length === 0) {
          // No active orders, no need to notify any shop owner
          return;
        }

        // 3. Notify shop owners for each active order
        for (const order of activeOrders) {
          const branch = await Branch.findById(order.branchId);
          if (branch) {
            const shopOwner = await ShopOwner.findById(branch.shopOwnerId);
            if (shopOwner) {
              const orderId = order.orderId;
              // Notify shop owner room
              io.to(shopOwner._id.toString()).emit(`locationUpdate/${orderId}`, {
                orderId,
                lat,
                lon,
                customerId: currentUserId,
              });
              console.log(`Location update sent to shop owner: ${shopOwner._id} for order: ${orderId}`);
            }
          }
        }
      } catch (error) {
        console.error('Error updating location via socket:', error);
      }
    });

    // Handle user disconnection
    socket.on("disconnect", () => {
      console.log("A user disconnected", currentUserId);
      onlineUsers.delete(currentUserId); // Remove user from online users
      io.emit("onlineUser", Array.from(onlineUsers)); // Update online user list
    });
  });
};

// Export the socket initialization function
export default socket;
