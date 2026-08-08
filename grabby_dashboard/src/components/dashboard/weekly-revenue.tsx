import { Bar, BarChart, CartesianGrid, XAxis, YAxis, } from "recharts";

import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import {
  ChartContainer,
  ChartTooltip,
  ChartTooltipContent,
  type ChartConfig,
} from "@/components/ui/chart";

const chartConfig = {
  revenue: {
    label: "Revenue",
    color: "hsl(var(--primary))",
  },
} satisfies ChartConfig;

interface WeeklyRevenueChartProps {
  data: {
    dayName: string;
    revenue: number;
  }[];
}

const WeeklyRevenueChart = ({ data }: WeeklyRevenueChartProps) => {
  return (
    <Card>
      <CardHeader>
        <CardTitle className="text-lg font-bold">
          Weekly Revenue
        </CardTitle>
      </CardHeader>
      <CardContent>
        <ChartContainer
          config={chartConfig}
          className="aspect-auto h-87.5 w-full"
        >
          <BarChart data={data} margin={{ top: 0, right: 0, left: 0, bottom: 0 }}>
            <defs>
              <linearGradient id="barGradient" x1="0" y1="0" x2="0" y2="1">
                <stop offset="0%" stopColor="#60a5fa" stopOpacity={1} />
                <stop offset="100%" stopColor="#a855f7" stopOpacity={1} />
              </linearGradient>
            </defs>
            <CartesianGrid vertical={false} strokeDasharray="3 3" stroke="var(--border)" />
            <XAxis
              dataKey="dayName"
              tickLine={false}
              axisLine={false}
              tickMargin={12}
              tick={{ fill: 'var(--muted-foreground)', fontSize: 12 }}
            />
            <YAxis
              tickLine={false}
              axisLine={false}
              tickMargin={12}
              tick={{ fill: 'var(--muted-foreground)', fontSize: 12 }}
              tickFormatter={(value) => `${value}`}
            />
            <ChartTooltip
              cursor={{ fill: "rgba(0,0,0,0.05)" }}
              content={<ChartTooltipContent hideLabel />}
            />
            <Bar
              dataKey="revenue"
              fill="url(#barGradient)"
              radius={[6, 6, 0, 0]}
              barSize={45}
            />
          </BarChart>
        </ChartContainer>
      </CardContent>
    </Card>
  );
};

export default WeeklyRevenueChart;
