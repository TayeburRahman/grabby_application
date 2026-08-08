import { useState } from "react";
import { ModalWrapper } from "@/components/ui/custom/modal-wrapper";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import {
  MapPin,
  Phone,
  Clock,
  Users,
  User,
  Calendar,
  Receipt,
  TrendingUp,
} from "lucide-react";
import { type Branch } from "./branch-modal";

interface BranchViewModalProps {
  branch: Branch;
}

export const BranchViewModal = ({ branch }: BranchViewModalProps) => {
  const [open, setOpen] = useState(false);

  return (
    <ModalWrapper
      open={open}
      onOpenChange={setOpen}
      title="Branch Details"
      description=""
      actionTrigger={
        <Button variant="outline" className="flex-1">
          View Details
        </Button>
      }
      showClose={true}
    >
      <div className="p-6">
        <div className="flex flex-col gap-8">
          {/* Header Info */}
          <div className="flex flex-col gap-4">
            <div className="flex items-start justify-between">
              <div className="flex items-center gap-3">
                <div className="h-12 w-12 rounded-xl bg-primary/10 flex items-center justify-center text-primary">
                  <MapPin className="h-6 w-6" />
                </div>
                <div className="flex flex-col">
                  <h2 className="text-xl font-bold">{branch.name}</h2>
                  <p className="text-muted-foreground">{branch.address}</p>
                </div>
              </div>
              <Badge
                variant={branch.status === "Active" ? "success" : "warning"}
              >
                {branch.status}
              </Badge>
            </div>
          </div>

          {/* Quick Stats Grid */}
          <div className="grid grid-cols-2 gap-4">
            <div className="flex flex-col gap-1 p-4 rounded-xl border bg-muted/5">
              <div className="flex items-center gap-2 text-muted-foreground">
                <Receipt className="h-4 w-4" />
                <span className="text-xs font-medium uppercase tracking-wider">
                  Today's Orders
                </span>
              </div>
              <p className="text-2xl font-bold">{branch.todayOrders}</p>
            </div>
            <div className="flex flex-col gap-1 p-4 rounded-xl border bg-green-50/50 dark:bg-green-950/20">
              <div className="flex items-center gap-2 text-green-600">
                <TrendingUp className="h-4 w-4" />
                <span className="text-xs font-medium uppercase tracking-wider">
                  Today's Revenue
                </span>
              </div>
              <p className="text-2xl font-bold text-green-600">
                {branch.todayRevenue}
              </p>
            </div>
          </div>

          {/* Detailed Info */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div className="flex flex-col gap-4">
              <h3 className="text-sm font-semibold text-muted-foreground uppercase tracking-wider">
                Contact & Schedule
              </h3>
              <div className="flex flex-col gap-3">
                <div className="flex items-center gap-3 text-sm">
                  <div className="h-8 w-8 rounded-lg bg-muted flex items-center justify-center">
                    <Phone className="h-4 w-4 text-muted-foreground" />
                  </div>
                  <span>{branch.phone}</span>
                </div>
                <div className="flex items-center gap-3 text-sm">
                  <div className="h-8 w-8 rounded-lg bg-muted flex items-center justify-center">
                    <Clock className="h-4 w-4 text-muted-foreground" />
                  </div>
                  <span>{branch.workingHours}</span>
                </div>
                <div className="flex items-center gap-3 text-sm">
                  <div className="h-8 w-8 rounded-lg bg-muted flex items-center justify-center">
                    <Calendar className="h-4 w-4 text-muted-foreground" />
                  </div>
                  <span>Operational Since: Jan 2024</span>
                </div>
              </div>
            </div>

            <div className="flex flex-col gap-4">
              <h3 className="text-sm font-semibold text-muted-foreground uppercase tracking-wider">
                Staffing
              </h3>
              <div className="flex flex-col gap-3">
                <div className="flex items-center gap-3 text-sm">
                  <div className="h-8 w-8 rounded-lg bg-muted flex items-center justify-center">
                    <User className="h-4 w-4 text-muted-foreground" />
                  </div>
                  <div className="flex flex-col">
                    <span className="font-medium">{branch.manager}</span>
                    <span className="text-xs text-muted-foreground">
                      Branch Manager
                    </span>
                  </div>
                </div>
                <div className="flex items-center gap-3 text-sm">
                  <div className="h-8 w-8 rounded-lg bg-muted flex items-center justify-center">
                    <Users className="h-4 w-4 text-muted-foreground" />
                  </div>
                  <span>{branch.staffCount} Staff Members</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </ModalWrapper>
  );
};
