import { useEffect, useState } from "react";
import PageLayout from "@/components/common/page-layout";
import PageHeader from "@/components/ui/custom/page-header";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import {
  TrendingUp,
  ShoppingCart,
  DollarSign,
  Users,
  Loader2,
} from "lucide-react";
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  PieChart,
  Pie,
  Cell,
  BarChart,
  Bar,
  Legend,
} from "recharts";
import { Progress } from "@/components/ui/progress";
import { DataTable } from "@/components/ui/custom/data-table";
import type { ColumnDef } from "@tanstack/react-table";
import { getAdminDashboardStats } from "@/services/dashboard";

const renderCustomizedLabel = ({
  cx,
  cy,
  midAngle,
  outerRadius,
  percent,
  name,
  color,
}: any) => {
  const RADIAN = Math.PI / 180;
  const radius = outerRadius * 1.4;
  const x = cx + radius * Math.cos(-midAngle * RADIAN);
  const y = cy + radius * Math.sin(-midAngle * RADIAN);

  return (
    <text
      x={x}
      y={y}
      fill={color}
      textAnchor={x > cx ? "start" : "end"}
      dominantBaseline="central"
      className="text-[12px] font-medium"
    >
      {`${name} ${(percent * 100).toFixed(0)}%`}
    </text>
  );
};

type TopProduct = {
  rank: number;
  name: string;
  shopName: string;
  unitsSold: number;
  revenue: string;
  performance: number;
};

const columns: ColumnDef<TopProduct>[] = [
  {
    accessorKey: "rank",
    header: "RANK",
    cell: ({ row }) => {
      const rank = row.getValue("rank") as number;
      return (
        <div
          className={`h-8 w-8 rounded-full flex items-center justify-center font-bold ${rank === 1 ? "bg-yellow-100 text-yellow-600" : "bg-muted text-muted-foreground"}`}
        >
          {rank}
        </div>
      );
    },
  },
  {
    accessorKey: "name",
    header: "PRODUCT",
    cell: ({ row }) => (
      <div className="font-medium">{row.getValue("name")}</div>
    ),
  },
  {
    accessorKey: "shopName",
    header: "SHOP NAME",
    cell: ({ row }) => (
      <div className="text-muted-foreground text-sm font-semibold">{row.getValue("shopName") || "Unknown"}</div>
    ),
  },
  {
    accessorKey: "unitsSold",
    header: "UNITS SOLD",
    cell: ({ row }) => (
      <div className="font-bold">{row.getValue("unitsSold")}</div>
    ),
  },
  {
    accessorKey: "revenue",
    header: "REVENUE",
    cell: ({ row }) => (
      <div className="font-bold text-green-600">{row.getValue("revenue")}</div>
    ),
  },
  {
    accessorKey: "performance",
    header: "PERFORMANCE",
    cell: ({ row }) => {
      const performance = row.getValue("performance") as number;
      return (
        <div className="flex items-center gap-3">
          <Progress value={performance} className="h-2 flex-1" />
          <span className="text-sm text-muted-foreground w-8">
            {performance}%
          </span>
        </div>
      );
    },
  },
];

const Reports = () => {
  const [loading, setLoading] = useState(true);
  const [data, setData] = useState<any>(null);

  useEffect(() => {
    const fetchData = async () => {
      const res = await getAdminDashboardStats();
      if (res.success) {
        setData(res.data);
      }
      setLoading(false);
    };
    fetchData();
  }, []);

  if (loading) {
    return (
      <PageLayout>
        <div className="h-[80vh] flex items-center justify-center">
          <Loader2 className="h-8 w-8 animate-spin text-primary" />
        </div>
      </PageLayout>
    );
  }

  const { stats, weeklyRevenue, categoryData, branchPerformance, topProducts } = data;

  const formattedWeeklyData = (weeklyRevenue || []).map((d: any) => ({
    name: d.dayName,
    orders: d.orders,
    revenue: d.revenue,
  }));

  return (
    <PageLayout>
      <div className="flex flex-col gap-6">
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <PageHeader
            title="Reports & Analytics"
            description="Track performance and business insights"
          />

        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          <Card>
            <CardContent className="pt-6">
              <div className="flex items-start justify-between">
                <div className="flex flex-col gap-1">
                  <p className="text-sm font-medium text-muted-foreground">
                    Total Revenue
                  </p>
                  <p className="text-2xl font-bold">AED {stats.totalRevenue?.toLocaleString()}</p>
                  <div className="flex items-center gap-1 text-xs text-green-600 font-medium">
                    <TrendingUp className="h-3 w-3" />
                    <span>Live data from store</span>
                  </div>
                </div>
                <div className="h-10 w-10 rounded-lg bg-green-100 flex items-center justify-center text-green-600">
                  <DollarSign className="h-5 w-5" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardContent className="pt-6">
              <div className="flex items-start justify-between">
                <div className="flex flex-col gap-1">
                  <p className="text-sm font-medium text-muted-foreground">
                    Total Orders
                  </p>
                  <p className="text-2xl font-bold">{stats.totalOrders}</p>
                  <div className="flex items-center gap-1 text-xs text-green-600 font-medium">
                    <TrendingUp className="h-3 w-3" />
                    <span>Across all branches</span>
                  </div>
                </div>
                <div className="h-10 w-10 rounded-lg bg-blue-100 flex items-center justify-center text-blue-600">
                  <ShoppingCart className="h-5 w-5" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardContent className="pt-6">
              <div className="flex items-start justify-between">
                <div className="flex flex-col gap-1">
                  <p className="text-sm font-medium text-muted-foreground">
                    Avg Order Value
                  </p>
                  <p className="text-2xl font-bold">AED {stats.avgOrderValue?.toFixed(2)}</p>
                  <div className="flex items-center gap-1 text-xs text-green-600 font-medium">
                    <TrendingUp className="h-3 w-3" />
                    <span>Per customer session</span>
                  </div>
                </div>
                <div className="h-10 w-10 rounded-lg bg-purple-100 flex items-center justify-center text-purple-600">
                  <DollarSign className="h-5 w-5" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardContent className="pt-6">
              <div className="flex items-start justify-between">
                <div className="flex flex-col gap-1">
                  <p className="text-sm font-medium text-muted-foreground">
                    New Customers
                  </p>
                  <p className="text-2xl font-bold">{stats.newCustomers}</p>
                  <div className="flex items-center gap-1 text-xs text-green-600 font-medium">
                    <TrendingUp className="h-3 w-3" />
                    <span>Last 30 days</span>
                  </div>
                </div>
                <div className="h-10 w-10 rounded-lg bg-orange-100 flex items-center justify-center text-orange-600">
                  <Users className="h-5 w-5" />
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Main Chart */}
        <Card>
          <CardHeader>
            <CardTitle className="text-lg font-bold">
              Sales Trend (Last 7 Days)
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="h-[300px] w-full">
              <ResponsiveContainer width="100%" height="100%">
                <LineChart
                  data={formattedWeeklyData}
                  margin={{ top: 5, right: 30, left: 20, bottom: 5 }}
                >
                  <CartesianGrid strokeDasharray="3 3" vertical={false} />
                  <XAxis
                    dataKey="name"
                    axisLine={false}
                    tickLine={false}
                    tick={{ fontSize: 12, fill: "#94a3b8" }}
                  />
                  <YAxis
                    yAxisId="left"
                    axisLine={false}
                    tickLine={false}
                    tick={{ fontSize: 12, fill: "#94a3b8" }}
                  />
                  <YAxis
                    yAxisId="right"
                    orientation="right"
                    axisLine={false}
                    tickLine={false}
                    tick={{ fontSize: 12, fill: "#94a3b8" }}
                  />
                  <Tooltip />
                  <Legend verticalAlign="bottom" height={36} />
                  <Line
                    yAxisId="left"
                    type="monotone"
                    dataKey="orders"
                    stroke="#10b981"
                    strokeWidth={2}
                    dot={{ r: 4 }}
                    activeDot={{ r: 6 }}
                    name="Orders"
                  />
                  <Line
                    yAxisId="right"
                    type="monotone"
                    dataKey="revenue"
                    stroke="#8b5cf6"
                    strokeWidth={2}
                    dot={{ r: 4 }}
                    activeDot={{ r: 6 }}
                    name="Revenue (AED)"
                  />
                </LineChart>
              </ResponsiveContainer>
            </div>
          </CardContent>
        </Card>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* Sales by Category */}
          <Card>
            <CardHeader>
              <CardTitle className="text-lg font-bold">
                Sales by Category
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="h-[350px] w-full flex items-center justify-center">
                <ResponsiveContainer width="100%" height="100%">
                  <PieChart>
                    <Pie
                      data={categoryData}
                      cx="50%"
                      cy="50%"
                      innerRadius={60}
                      outerRadius={100}
                      paddingAngle={5}
                      dataKey="value"
                      labelLine={false}
                      label={renderCustomizedLabel}
                      stroke="none"
                    >
                      {(categoryData || []).map((entry: any, index: number) => (
                        <Cell key={`cell-${index}`} fill={entry.color} />
                      ))}
                    </Pie>
                    <Tooltip />
                  </PieChart>
                </ResponsiveContainer>
              </div>
            </CardContent>
          </Card>

          {/* Branch Performance */}
          <Card>
            <CardHeader>
              <CardTitle className="text-lg font-bold">
                Branch Performance
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="h-[300px] w-full">
                <ResponsiveContainer width="100%" height="100%">
                  <BarChart
                    data={branchPerformance}
                    margin={{ top: 5, right: 30, left: 20, bottom: 5 }}
                  >
                    <CartesianGrid strokeDasharray="3 3" vertical={false} />
                    <XAxis
                      dataKey="name"
                      axisLine={false}
                      tickLine={false}
                      tick={{ fontSize: 12, fill: "#94a3b8" }}
                    />
                    <YAxis
                      axisLine={false}
                      tickLine={false}
                      tick={{ fontSize: 12, fill: "#94a3b8" }}
                    />
                    <Tooltip />
                    <Legend />
                    <Bar
                      dataKey="orders"
                      fill="#10b981"
                      radius={[4, 4, 0, 0]}
                      name="Orders"
                      barSize={40}
                    />
                    <Bar
                      dataKey="revenue"
                      fill="#8b5cf6"
                      radius={[4, 4, 0, 0]}
                      name="Revenue (AED)"
                      barSize={40}
                    />
                  </BarChart>
                </ResponsiveContainer>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Top Selling Products */}
        <div className="space-y-4">
          <h2 className="text-lg font-bold">Top Selling Products</h2>
          <DataTable columns={columns} data={topProducts} />
        </div>
      </div>
    </PageLayout>
  );
};

export default Reports;

