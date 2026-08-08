import { useState } from "react";
import { ModalWrapper } from "@/components/ui/custom/modal-wrapper";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";

export type Branch = {
  id: string;
  name: string;
  address: string;
  phone: string;
  manager: string;
  staffCount: number;
  workingHours: string;
  status: "Active" | "Temporarily Closed";
  todayOrders: number;
  todayRevenue: string;
};

interface BranchModalProps {
  mode: "create" | "edit";
  branch?: Branch;
  trigger?: React.ReactNode;
}

export const BranchModal = ({ mode, branch, trigger }: BranchModalProps) => {
  const [open, setOpen] = useState(false);

  return (
    <ModalWrapper
      open={open}
      onOpenChange={setOpen}
      title={mode === "create" ? "Add New Branch" : "Edit Branch"}
      actionTrigger={
        trigger || (
          <Button>
            + Add New Branch
          </Button>
        )
      }
    >
      <div className="p-6">
        <div className="flex flex-col gap-5">
          <div className="flex flex-col gap-2">
            <Label htmlFor="name" className="font-medium text-muted-foreground">Branch Name</Label>
            <Input id="name" placeholder="Main Branch" defaultValue={branch?.name} />
          </div>

          <div className="flex flex-col gap-2">
            <Label htmlFor="address" className="font-medium text-muted-foreground">Address</Label>
            <Input id="address" placeholder="123 Main Street, Downtown" defaultValue={branch?.address} />
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div className="flex flex-col gap-2">
              <Label htmlFor="phone" className="font-medium text-muted-foreground">Phone</Label>
              <Input id="phone" placeholder="+1 234 567 8901" defaultValue={branch?.phone} />
            </div>
            <div className="flex flex-col gap-2">
              <Label htmlFor="manager" className="font-medium text-muted-foreground">Manager</Label>
              <Input id="manager" placeholder="John Smith" defaultValue={branch?.manager} />
            </div>
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div className="flex flex-col gap-2">
              <Label htmlFor="staff" className="font-medium text-muted-foreground">Staff Count</Label>
              <Input id="staff" type="number" placeholder="0" defaultValue={branch?.staffCount} />
            </div>
            <div className="flex flex-col gap-2">
              <Label htmlFor="status" className="font-medium text-muted-foreground">Status</Label>
              <Select defaultValue={branch?.status || "Active"}>
                <SelectTrigger id="status">
                  <SelectValue placeholder="Select status" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="Active">Active</SelectItem>
                  <SelectItem value="Temporarily Closed">Temporarily Closed</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>

          <div className="flex flex-col gap-2">
            <Label htmlFor="hours" className="font-medium text-muted-foreground">Working Hours</Label>
            <Input id="hours" placeholder="8:00 AM - 10:00 PM" defaultValue={branch?.workingHours} />
          </div>

          <div className="flex gap-3 pt-4">
            <Button variant="outline" className="flex-1" onClick={() => setOpen(false)}>
              Cancel
            </Button>
            <Button className="flex-1" onClick={() => setOpen(false)}>
              {mode === "create" ? "Add Branch" : "Save Changes"}
            </Button>
          </div>
        </div>
      </div>
    </ModalWrapper>
  );
};
