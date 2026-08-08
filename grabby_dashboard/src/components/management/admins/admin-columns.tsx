import { type ColumnDef } from "@tanstack/react-table";
import { Button } from "@/components/ui/button";
import { Trash2, Edit, User, ShieldCheck, UserCog } from "lucide-react";
import { ConfirmationModal } from "@/components/ui/custom/confirmation-modal";
import { AdminModal, type Admin } from "./admin-modal";
import { ErrorToast, SuccessToast } from "@/lib/utils";

import { API_BASE_URL } from "@/services/auth";

export const adminColumns = (onSuccess: () => void): ColumnDef<Admin>[] => [
  {
    accessorKey: "name",
    header: "ADMIN NAME",
    cell: ({ row }) => (
      <div className="flex items-center gap-3">
        <div className="rounded-full bg-primary/10 flex items-center justify-center h-8 w-8 text-primary">
          <User className="h-4 w-4" />
        </div>
        <div className="flex flex-col">
          <span className="font-medium text-foreground">{row.getValue("name")}</span>
          <span className="text-[10px] text-muted-foreground">{row.original.email}</span>
        </div>
      </div>
    ),
  },
  {
    accessorKey: "role",
    header: "ROLE",
    cell: ({ row }) => {
      const role = row.getValue("role") as string;
      const isSuper = role === "Super Admin";
      return (
        <div className="flex items-center gap-2">
          {isSuper ? (
            <ShieldCheck className="h-4 w-4 text-purple-600" />
          ) : (
            <UserCog className="h-4 w-4 text-blue-600" />
          )}
          <span className="text-xs font-medium text-muted-foreground uppercase tracking-tight">{role}</span>
        </div>
      );
    },
  },
  {
    accessorKey: "joinedDate",
    header: "JOINED DATE",
    cell: ({ row }) => (
      <span className="text-muted-foreground text-xs">{row.getValue("joinedDate")}</span>
    ),
  },
  {
    id: "actions",
    header: () => <div className="text-right">ACTIONS</div>,
    cell: ({ row }) => {
      const isSuperAdmin = row.original.role === "Super Admin";
      
      return (
        <div className="flex items-center justify-end">
          <AdminModal 
            mode="edit" 
            admin={row.original} 
            onSuccess={onSuccess}
            trigger={
              <Button variant="ghost" size="icon" className="h-8 w-8">
                <Edit className="h-4 w-4" />
              </Button>
            } 
          />
          {!isSuperAdmin && (
            <ConfirmationModal
              title="Delete Admin"
              description={`Are you sure you want to delete admin "${row.original.name}"? This action cannot be undone.`}
              onConfirm={async () => {
                try {
                  const token = localStorage.getItem("accessToken");
                  const res = await fetch(`${API_BASE_URL}/admin/${row.original.id}`, {
                    method: "DELETE",
                    headers: {
                      "Authorization": `Bearer ${token}`
                    }
                  });
                  const result = await res.json();
                  if (res.ok) {
                    SuccessToast("Admin deleted successfully");
                    onSuccess();
                  } else {
                    ErrorToast(result.message || "Failed to delete admin");
                  }
                } catch (error: any) {
                  ErrorToast(error.message);
                }
              }}
              trigger={
                <Button variant="ghost" size="icon" className="text-destructive h-8 w-8">
                  <Trash2 className="h-4 w-4" />
                </Button>
              }
            />
          )}
        </div>
      );
    },
  },
];
