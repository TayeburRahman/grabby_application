import { useState, useEffect, useCallback } from "react";
import PageLayout from "@/components/common/page-layout";
import PageHeader from "@/components/ui/custom/page-header";
import { DataTable } from "@/components/ui/custom/data-table";
import { Tabs, TabsList, TabsTrigger } from "@/components/ui/tabs";
import {
  type Order,
  ordersColumns,
} from "@/components/management/orders/orders-columns";
import { ScrollArea, ScrollBar } from "@/components/ui/scroll-area";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Download, MapPin, Loader2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import * as XLSX from "xlsx";
import { getAllOrders, getBranchOrders, getAllBranches } from "@/services/order";
import { ErrorToast } from "@/lib/utils";

const Orders = () => {
  const [activeTab, setActiveTab] = useState<string>("All");
  const [orders, setOrders] = useState<Order[]>([]);
  const [branches, setBranches] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedBranch, setSelectedBranch] = useState<string>("all");
  const [meta, setMeta] = useState<any>(null);
  const [page, setPage] = useState(1);
  const [limit, setLimit] = useState(10);

  const fetchBranches = useCallback(async () => {
    const result = await getAllBranches();
    if (result.success) {
      setBranches(result.data);
    } else {
      ErrorToast(result.message || "Failed to fetch branches");
    }
  }, []);

  const fetchOrders = useCallback(async () => {
    setLoading(true);
    let result;
    const query: any = {
      page,
      limit,
    };
    if (activeTab !== "All") {
      query.status = activeTab.toLowerCase();
    }

    if (selectedBranch === "all") {
      result = await getAllOrders(query);
    } else {
      result = await getBranchOrders(selectedBranch, query);
    }

    if (result.success) {
      setOrders(result.data);
      setMeta(result.meta);
    } else {
      ErrorToast(result.message || "Failed to fetch orders");
    }
    setLoading(false);
  }, [activeTab, selectedBranch, page, limit]);

  useEffect(() => {
    fetchBranches();
  }, [fetchBranches]);

  useEffect(() => {
    fetchOrders();
  }, [fetchOrders]);

  // Reset to first page when tab or branch changes
  useEffect(() => {
    setPage(1);
  }, [activeTab, selectedBranch]);

  const counts = {
    All: meta?.total || 0,
    Pending: orders.filter((o) => o.status === "placed").length, // Note: these are current page counts
    Preparing: orders.filter((o) => o.status === "preparing").length,
    Ready: orders.filter((o) => o.status === "ready").length,
    Completed: orders.filter((o) => o.status === "completed").length,
  };

  const handleExport = () => {
    const exportData = orders.map(order => ({
      OrderNumber: order.orderId,
      Date: new Date(order.createdAt).toLocaleDateString(),
      Customer: order.customerId?.name,
      Items: order.items.map(item => `${item.menuName} (x${item.quantity})`).join(", "),
      Total: `AED ${order.totalAmount.toFixed(2)}`,
      Pickup: order.pickupType === "carPickup" ? "Car Pickup" : "Counter Pickup",
      CarPlate: order.carPlates || "-",
      Status: order.status
    }));

    const ws = XLSX.utils.json_to_sheet(exportData);
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, "Orders");
    XLSX.writeFile(wb, `orders_${new Date().toISOString().split('T')[0]}.xlsx`);
  };

  const onPaginationChange = (newPage: number, newLimit: number) => {
    setPage(newPage);
    setLimit(newLimit);
  };

  return (
    <PageLayout>
      <div className="flex flex-col md:flex-row gap-2 justify-between">
        <PageHeader
          title="Orders Management"
          description="Manage and track all customer orders"
        />

        <div className="flex items-center gap-2">
          <Select value={selectedBranch} onValueChange={setSelectedBranch}>
            <SelectTrigger className="w-64 bg-background">
              <div className="flex items-center gap-2">
                <div className="bg-primary/10 p-1 rounded-md">
                  <MapPin className="h-3.5 w-3.5 text-primary" />
                </div>
                <SelectValue placeholder="Select Branch" />
              </div>
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="all">All Branches</SelectItem>
              {branches.map((branch) => (
                <SelectItem key={branch._id} value={branch._id}>
                  {branch.branch_name}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>

          {/* Export Button */}
          <Button onClick={handleExport} variant="outline" disabled={loading}>
            Export <Download className="h-4 w-4" />
          </Button>
        </div>
      </div>

      <Tabs defaultValue="All" value={activeTab} onValueChange={setActiveTab} className="w-full">
        <ScrollArea className="w-87 sm:w-full">
          <TabsList>
            {Object.entries(counts).map(([status]) => (
              <TabsTrigger key={status} value={status}>
                {status}
              </TabsTrigger>
            ))}
          </TabsList>
          <ScrollBar orientation="horizontal" />
        </ScrollArea>
      </Tabs>

      {loading ? (
        <div className="flex items-center justify-center h-64">
          <Loader2 className="h-8 w-8 animate-spin text-primary" />
        </div>
      ) : (
        <DataTable
          columns={ordersColumns}
          data={orders}
          meta={meta}
          onPaginationChange={onPaginationChange}
        />
      )}
    </PageLayout>
  );
};

export default Orders;
