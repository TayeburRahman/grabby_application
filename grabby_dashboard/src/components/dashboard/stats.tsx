import { Card, CardContent } from "@/components/ui/card";
import { TrendingUp, DollarSign, ShoppingCart, Users } from "lucide-react";

interface StatsProps {
  data: {
    totalRevenue: number;
    totalOrders: number;
    totalCustomers: number;
    totalShops: number;
  };
}

const Stats = ({ data }: StatsProps) => {
  const stats = [
    {
      label: "Total Orders",
      value: data.totalOrders.toString(),
      trend: "+12% from yesterday",
      icon: ShoppingCart,
      iconBg: "bg-blue-50",
      iconColor: "text-blue-500",
      trendColor: "text-green-500",
    },
    {
      label: "Total Revenue",
      value: `AED ${data.totalRevenue.toLocaleString()}`,
      trend: "+8% from yesterday",
      icon: DollarSign,
      iconBg: "bg-green-50",
      iconColor: "text-green-500",
      trendColor: "text-green-500",
    },
    {
      label: "Total Shops",
      value: data.totalShops.toString(),
      trend: "Across all regions",
      icon: TrendingUp,
      iconBg: "bg-orange-50",
      iconColor: "text-orange-500",
      trendColor: "text-orange-500",
    },
    {
      label: "Total Customers",
      value: data.totalCustomers.toLocaleString(),
      trend: "+24 new today",
      icon: Users,
      iconBg: "bg-purple-50",
      iconColor: "text-purple-500",
      trendColor: "text-green-500",
    },
  ];

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
      {stats.map((stat, index) => (
        <Card key={index}>
          <CardContent>
            <div className="flex justify-between items-start pt-6">
              <div className="space-y-2">
                <p className="text-sm text-muted-foreground font-medium">{stat.label}</p>
                <h3 className="text-2xl font-bold">{stat.value}</h3>
                <p className={`text-xs font-medium flex items-center gap-1 ${stat.trendColor}`}>
                  {stat.trend.startsWith("+") && <TrendingUp className="w-3 h-3" />}

                </p>
              </div>
              <div className={`p-3 rounded-xl ${stat.iconBg}`}>
                <stat.icon className={`w-5 h-5 ${stat.iconColor}`} />
              </div>
            </div>
          </CardContent>
        </Card>
      ))}
    </div>
  );
};

export default Stats;