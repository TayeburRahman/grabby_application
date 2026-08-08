import { useEffect, useState } from "react";
import PageLayout from "@/components/common/page-layout";
import Stats from "@/components/dashboard/stats";
import WeeklyRevenueChart from "@/components/dashboard/weekly-revenue";
import OrderStatusChart from "@/components/dashboard/order-status";
import { DataTable } from "@/components/ui/custom/data-table";
import { ordersColumns } from "@/components/management/orders/orders-columns";
import { getAdminDashboardStats } from "@/services/dashboard";
import { Loader2 } from "lucide-react";

const Dashboard = () => {
  const [data, setData] = useState<any>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const fetchData = async () => {
      const result = await getAdminDashboardStats();
      if (result.success) {
        setData(result.data);
      }
      setIsLoading(false);
    };
    fetchData();
  }, []);

  if (isLoading) {
    return (
      <div className="h-[60vh] flex items-center justify-center">
        <Loader2 className="w-8 h-8 animate-spin text-primary" />
      </div>
    );
  }

  if (!data) {
    return (
      <div className="h-[60vh] flex items-center justify-center">
        <p className="text-muted-foreground">Failed to load dashboard data.</p>
      </div>
    );
  }

  return (
    <PageLayout >
      <div className="space-y-6">
        <div>
          <h1 className="text-2xl font-bold">Dashboard Overview</h1>
          <p className="text-sm text-muted-foreground">Welcome back! Here's what's happening today.</p>
        </div>

        <Stats data={data.stats} />

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <div className="lg:col-span-2">
            <WeeklyRevenueChart data={data.weeklyRevenue} />
          </div>
          <div className="lg:col-span-1">
            <OrderStatusChart data={data.orderStatus} />
          </div>
        </div>

        <div className="space-y-4">
          <div className="flex items-center justify-between px-1">
            <h2 className="text-xl font-bold tracking-tight text-foreground">Recent Orders</h2>
          </div>
          <div className="bg-card/50 backdrop-blur-sm rounded-3xl border border-muted-foreground/10 shadow-xl overflow-hidden">
            <div className="p-1 sm:p-4">
              <DataTable 
                columns={ordersColumns} 
                data={data.recentOrders || []} 
              />
            </div>
          </div>
        </div>
      </div>
    </PageLayout>
  );
};

export default Dashboard;
