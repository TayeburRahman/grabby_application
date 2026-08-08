import { useState, useEffect } from "react";
import { ModalWrapper } from "@/components/ui/custom/modal-wrapper";
import { type Order } from "./orders-columns";
import { Badge } from "@/components/ui/badge";
import { Separator } from "@/components/ui/separator";
import { Button } from "@/components/ui/button";
import { User, ShoppingBag, Truck, Receipt, Eye, Award, Wallet, Loader2 } from "lucide-react";
import { ScrollArea } from "@/components/ui/scroll-area";
import { getCustomerDetails } from "@/services/customer";

interface OrderViewModalProps {
  order: Order;
  trigger?: React.ReactNode;
}

export function OrderViewModal({ order, trigger }: OrderViewModalProps) {
  const [open, setOpen] = useState(false);
  const [customerDetails, setCustomerDetails] = useState<any>(null);
  const [loadingCustomer, setLoadingCustomer] = useState(false);

  useEffect(() => {
    if (open && order.customerId?._id) {
      const fetchCustomer = async () => {
        setLoadingCustomer(true);
        const result = await getCustomerDetails(order.customerId._id);
        if (result.success) {
          setCustomerDetails(result.data);
        }
        setLoadingCustomer(false);
      };
      fetchCustomer();
    }
  }, [open, order.customerId?._id]);

  const getStatusVariant = (status: string) => {
    switch (status.toLowerCase()) {
      case "placed":
        return "destructive";
      case "preparing":
        return "warning";
      case "ready":
        return "info";
      case "completed":
        return "success";
      case "cancelled":
        return "secondary";
      default:
        return "default";
    }
  };

  return (
    <ModalWrapper
      open={open}
      onOpenChange={setOpen}
      title={`Order #${order.orderId}`}
      description={`Details for order placed on ${new Date(order.createdAt).toLocaleDateString()}`}
      actionTrigger={
        trigger || (
          <Button variant="outline" size="icon-sm">
            <Eye className="h-4 w-4" />
          </Button>
        )
      }
      showClose={true}
    >
      <ScrollArea className="max-h-[80vh]">
        <div className="p-6 space-y-6">
          {/* Status Badge */}
          <div className="flex justify-between items-center">
            <span className="text-sm text-muted-foreground font-medium">
              Order Status
            </span>
            <Badge
              variant={getStatusVariant(order.status) as any}
              className="text-sm px-3 py-1 capitalize"
            >
              {order.status}
            </Badge>
          </div>

          <div className="grid grid-cols-2 gap-4 bg-muted/30 p-4 rounded-lg border">
            <div className="space-y-1">
              <span className="text-xs text-muted-foreground uppercase tracking-wider font-semibold">
                Order Date
              </span>
              <p className="text-sm font-medium">
                {new Date(order.createdAt).toLocaleDateString()}
              </p>
            </div>
            <div className="space-y-1">
              <span className="text-xs text-muted-foreground uppercase tracking-wider font-semibold">
                Time
              </span>
              <p className="text-sm font-medium">
                {new Date(order.createdAt).toLocaleTimeString()}
              </p>
            </div>
          </div>

          <Separator />

          {/* Customer Info */}
          <div className="space-y-4">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2 text-primary">
                <User className="h-4 w-4" />
                <span className="font-medium text-sm">Customer Details</span>
              </div>
              {loadingCustomer && <Loader2 className="h-3 w-3 animate-spin text-muted-foreground" />}
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-1">
                <span className="text-xs text-muted-foreground">Name</span>
                <p className="font-medium text-sm">{order.customerId?.name || "N/A"}</p>
              </div>
              <div className="space-y-1">
                <span className="text-xs text-muted-foreground">Phone</span>
                <p className="font-medium text-sm">{order.customerId?.phone_number || "N/A"}</p>
              </div>
              <div className="col-span-2 space-y-1">
                <span className="text-xs text-muted-foreground">Email</span>
                <p className="font-medium text-sm">{order.customerId?.email || "N/A"}</p>
              </div>
              
              {/* Extra Details from Full Fetch */}
              {customerDetails && (
                <>
                  <div className="p-2 rounded-md bg-blue-50 border border-blue-100 flex items-center gap-2">
                    <Award className="h-4 w-4 text-blue-600" />
                    <div className="flex flex-col">
                      <span className="text-[10px] text-blue-600 uppercase font-bold leading-none">Points</span>
                      <span className="text-sm font-bold text-blue-700">{customerDetails.pointWallet ?? 0}</span>
                    </div>
                  </div>
                  <div className="p-2 rounded-md bg-green-50 border border-green-100 flex items-center gap-2">
                    <Wallet className="h-4 w-4 text-green-600" />
                    <div className="flex flex-col">
                      <span className="text-[10px] text-green-600 uppercase font-bold leading-none">Wallet</span>
                      <span className="text-sm font-bold text-green-700">AED {(customerDetails.credWallet ?? 0).toFixed(2)}</span>
                    </div>
                  </div>
                </>
              )}
            </div>
          </div>

          {/* Delivery Info */}
          <div className="bg-muted/30 p-4 rounded-lg space-y-3">
            <div className="flex items-center gap-2 text-primary">
              <Truck className="h-4 w-4" />
              <span className="font-medium text-sm">Delivery Information</span>
            </div>
            <div className="grid grid-cols-2 gap-4 text-sm">
              <div>
                <span className="text-muted-foreground block text-xs mb-1">
                  Type
                </span>
                <span className="font-medium">
                  {order.pickupType === "carPickup" ? "Car Pickup" : "Counter Pickup"}
                </span>
              </div>
              <div>
                <span className="text-muted-foreground block text-xs mb-1">
                  Car Plate
                </span>
                <span className="font-medium">
                  {order.carPlates || "-"}
                </span>
              </div>
              <div className="col-span-2">
                <span className="text-muted-foreground block text-xs mb-1">
                  Branch
                </span>
                <span className="font-medium">
                  {order.branchId?.branch_name} ({order.branchId?.address})
                </span>
              </div>
            </div>
          </div>

          {/* Order Items */}
          <div className="space-y-3">
            <div className="flex items-center gap-2 text-primary">
              <ShoppingBag className="h-4 w-4" />
              <span className="font-medium text-sm">Order Items</span>
            </div>
            <div className="border rounded-md divide-y overflow-hidden">
              {order.items.map((item, index) => (
                <div
                  key={index}
                  className="p-3 text-sm flex justify-between items-center"
                >
                  <div className="flex flex-col">
                    <span className="font-medium">{item.menuName}</span>
                    <span className="text-xs text-muted-foreground">AED {(Number(item.totalPrice) || 0).toFixed(2)}</span>
                  </div>
                  <Badge variant="outline">x{item.quantity}</Badge>
                </div>
              ))}
            </div>
          </div>

          <Separator />

          {/* Total Amount */}
          <div className="flex justify-between items-center bg-primary/5 p-4 rounded-lg border border-primary/10">
            <div className="flex items-center gap-2">
              <Receipt className="h-4 w-4 text-primary" />
              <span className="font-medium text-primary">Total Amount</span>
            </div>
            <span className="text-xl font-bold text-primary">
              AED {(Number(order.totalAmount) || 0).toFixed(2)}
            </span>
          </div>
        </div>
      </ScrollArea>
    </ModalWrapper>
  );
}
