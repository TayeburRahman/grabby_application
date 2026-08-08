import { useState } from "react";
import { ModalWrapper } from "@/components/ui/custom/modal-wrapper";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Plus, Loader2 } from "lucide-react";
import { createAdmin } from "@/services/admin";
import { ErrorToast, SuccessToast } from "@/lib/utils";

export type Admin = {
  id: string;
  name: string;
  email: string;
  role: "Super Admin" | "Admin";
  joinedDate: string;
};

interface AdminModalProps {
  mode: "create" | "edit";
  admin?: Admin;
  trigger?: React.ReactNode;
  onSuccess?: () => void;
}

export const AdminModal = ({ mode, admin, trigger, onSuccess }: AdminModalProps) => {
  const [open, setOpen] = useState(false);
  const [loading, setLoading] = useState(false);
  const [formData, setFormData] = useState({
    name: admin?.name || "",
    email: admin?.email || "",
    password: "",
    phone_number: "", // Backend requires phone_number
  });

  const handleSubmit = async () => {
    setLoading(true);
    try {
      if (mode === "create") {
        const result = await createAdmin(formData);
        if (result.success) {
          SuccessToast("Admin created successfully");
          setOpen(false);
          onSuccess?.();
          setFormData({ name: "", email: "", password: "", phone_number: "" });
        } else {
          ErrorToast(result.message);
        }
      } else {
        // Edit logic would go here if implemented in backend
        ErrorToast("Editing is not yet fully implemented in backend");
      }
    } catch (error: any) {
      ErrorToast(error.message);
    }
    setLoading(false);
  };

  return (
    <ModalWrapper
      open={open}
      onOpenChange={setOpen}
      title={mode === "create" ? "Add New Admin" : "Edit Admin"}
      actionTrigger={
        trigger || (
          <Button>
            <Plus className="mr-2 h-4 w-4" />
            Add Admin
          </Button>
        )
      }
    >
      <div className="p-6">
        <div className="flex flex-col gap-5">
          <div className="flex flex-col gap-2">
            <Label htmlFor="name" className="text-xs font-bold uppercase tracking-widest text-muted-foreground">Full Name</Label>
            <Input 
              id="name" 
              placeholder="John Doe" 
              value={formData.name}
              onChange={(e) => setFormData({ ...formData, name: e.target.value })}
            />
          </div>

          <div className="flex flex-col gap-2">
            <Label htmlFor="email" className="text-xs font-bold uppercase tracking-widest text-muted-foreground">Email Address</Label>
            <Input 
              id="email" 
              type="email" 
              placeholder="john@example.com" 
              value={formData.email}
              onChange={(e) => setFormData({ ...formData, email: e.target.value })}
            />
          </div>

          <div className="flex flex-col gap-2">
            <Label htmlFor="phone" className="text-xs font-bold uppercase tracking-widest text-muted-foreground">Phone Number</Label>
            <Input 
              id="phone" 
              placeholder="+971 50 123 4567" 
              value={formData.phone_number}
              onChange={(e) => setFormData({ ...formData, phone_number: e.target.value })}
            />
          </div>

          <div className="flex flex-col gap-2">
            <Label htmlFor="role" className="text-xs font-bold uppercase tracking-widest text-muted-foreground">Role</Label>
            <Select defaultValue="Admin">
              <SelectTrigger id="role">
                <SelectValue placeholder="Select role" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="Admin">Admin</SelectItem>
                <SelectItem value="Super Admin" disabled>Super Admin (System Only)</SelectItem>
              </SelectContent>
            </Select>
          </div>

          {mode === "create" && (
            <div className="flex flex-col gap-2">
              <Label htmlFor="password" className="text-xs font-bold uppercase tracking-widest text-muted-foreground">Password</Label>
              <Input 
                id="password" 
                type="password" 
                placeholder="••••••••" 
                value={formData.password}
                onChange={(e) => setFormData({ ...formData, password: e.target.value })}
              />
            </div>
          )}

          <div className="flex gap-3 pt-4">
            <Button variant="outline" className="flex-1" onClick={() => setOpen(false)}>
              Cancel
            </Button>
            <Button className="flex-1" onClick={handleSubmit} disabled={loading}>
              {loading ? <Loader2 className="h-4 w-4 animate-spin" /> : (mode === "create" ? "Add Admin" : "Save Changes")}
            </Button>
          </div>
        </div>
      </div>
    </ModalWrapper>
  );
};
