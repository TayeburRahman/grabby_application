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
    socket.on('updateLocation', async (data: { orderId: string; lat: number; lon: number }) => {
      try {
        const { orderId, lat, lon } = data;

        console.log("data", data)

        // 1. Find the order
        const order = await Order.findOne({ orderId });
        if (!order) {
          console.log(`Order not found: ${orderId}`);
          return;
        }

        // 2. Update Customer location
        await Customer.findByIdAndUpdate(order.customerId, { lat, lon });

        // 3. Find shop owner to notify
        const branch = await Branch.findById(order.branchId);
        if (branch) {
          const shopOwner = await ShopOwner.findById(branch.shopOwnerId);
          if (shopOwner) {
            // Notify shop owner room (authId)
            io.to(shopOwner._id.toString()).emit(`locationUpdate/${orderId}`, {
              orderId,
              lat,
              lon,
              customerId: order.customerId,
            });
            console.log(`Location update sent to shop owner: ${shopOwner.authId}`);
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
