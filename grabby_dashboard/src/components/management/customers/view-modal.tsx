import { useState } from "react";
import { Eye, Mail, Phone, Calendar, User } from "lucide-react";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { Button } from "@/components/ui/button";
import { ModalWrapper } from "@/components/ui/custom/modal-wrapper";
import { Badge } from "@/components/ui/badge";
import { type Customer } from "./customers-columns";
import { ScrollArea } from "@/components/ui/scroll-area";

interface CustomerViewModalProps {
  customer: Customer;
}

const CustomerViewModal = ({ customer }: CustomerViewModalProps) => {
  const [open, setOpen] = useState(false);

  return (
    <ModalWrapper
      open={open}
      onOpenChange={setOpen}
      title="Customer Details"
      actionTrigger={
        <Button variant="outline" size="sm">
          <Eye className="h-4 w-4 mr-2" />
          View
        </Button>
      }
      showClose={true}
    >
      <ScrollArea className="max-h-[80vh]">
        <div className="p-6 space-y-6">
          {/* Header Info */}
          <div className="flex items-center gap-4 p-4 rounded-xl border bg-muted/30">
            <Avatar className="h-16 w-16 border-2 border-background shadow-sm">
              <AvatarFallback className="bg-primary/10 text-primary font-bold text-xl">
                {customer.name.substring(0, 2).toUpperCase()}
              </AvatarFallback>
            </Avatar>
            <div className="flex flex-col gap-1">
              <h4 className="text-xl font-bold text-foreground leading-tight">
                {customer.name}
              </h4>
              <p className="text-sm text-muted-foreground">{customer.email}</p>
              <div className="flex mt-1">
                <Badge variant={customer.status === "active" ? "success" : "destructive"} className="font-medium capitalize">
                  {customer.status}
                </Badge>
              </div>
            </div>
          </div>

          {/* Stats Grid */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div className="p-4 rounded-xl border bg-card shadow-sm flex flex-col gap-1">
              <p className="text-xs font-semibold text-muted-foreground uppercase tracking-wider">
                Loyalty Points
              </p>
              <p className="text-2xl font-black text-orange-600">
                {customer.pointWallet ?? 0} pts
              </p>
            </div>
            <div className="p-4 rounded-xl border bg-card shadow-sm flex flex-col gap-1">
              <p className="text-xs font-semibold text-muted-foreground uppercase tracking-wider">
                Wallet Credit
              </p>
              <p className="text-2xl font-black text-primary">
                AED {(Number(customer.credWallet) || 0).toFixed(2)}
              </p>
            </div>
            <div className="p-4 rounded-xl border bg-card shadow-sm flex flex-col gap-1">
              <p className="text-xs font-semibold text-muted-foreground uppercase tracking-wider">
                Member Since
              </p>
              <p className="text-lg font-bold text-foreground">
                {new Date(customer.createdAt).toLocaleDateString()}
              </p>
            </div>
            <div className="p-4 rounded-xl border bg-card shadow-sm flex flex-col gap-1">
              <p className="text-xs font-semibold text-muted-foreground uppercase tracking-wider">
                Status
              </p>
              <p className="text-lg font-bold capitalize">
                {customer.status}
              </p>
            </div>
          </div>

          {/* Contact Details */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div className="p-4 rounded-xl border bg-muted/10 space-y-3">
              <h5 className="text-xs font-bold text-muted-foreground uppercase tracking-widest">
                Contact Information
              </h5>
              <div className="space-y-2">
                <div className="flex items-center gap-2 text-sm text-foreground/80">
                  <Mail className="h-4 w-4 text-muted-foreground" />
                  <span className="truncate">{customer.email}</span>
                </div>
                <div className="flex items-center gap-2 text-sm text-foreground/80">
                  <Phone className="h-4 w-4 text-muted-foreground" />
                  <span>{customer.phone_number}</span>
                </div>
              </div>
            </div>
            <div className="p-4 rounded-xl border bg-muted/10 space-y-3">
              <h5 className="text-xs font-bold text-muted-foreground uppercase tracking-widest">
                Account Info
              </h5>
              <div className="space-y-2">
                <div className="flex items-center gap-2 text-sm text-foreground/80">
                  <Calendar className="h-4 w-4 text-muted-foreground" />
                  <span>Joined: {new Date(customer.createdAt).toLocaleDateString()}</span>
                </div>
                <div className="flex items-center gap-2 text-sm text-foreground/80">
                  <User className="h-4 w-4 text-muted-foreground" />
                  <span className="truncate text-[10px]">ID: {customer._id}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </ScrollArea>
    </ModalWrapper>
  );
};

export default CustomerViewModal;
