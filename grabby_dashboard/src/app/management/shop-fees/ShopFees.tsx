import { useMemo } from "react";
import PageLayout from "@/components/common/page-layout";
import PageHeader from "@/components/ui/custom/page-header";
import { DataTable } from "@/components/ui/custom/data-table";
import { Button } from "@/components/ui/button";
import { Save, Percent } from "lucide-react";
import { Input } from "@/components/ui/input";
import {
  getShopFeeColumns,
  type ShopFee,
} from "@/components/management/shop-fees/shop-fees-columns";

const INITIAL_DATA: ShopFee[] = [
  {
    id: "1",
    name: "Urban Brews Coffee",
    category: "Coffee Shop",
    ownerName: "Sarah Ahmed",
    location: "Downtown",
    status: "Active",
    joinedDate: "2024-03-10",
    feePercentage: 10,
    isFeeActive: true,
    useGlobalFee: true,
  },
  {
    id: "2",
    name: "Gourmet Garden",
    category: "Restaurant",
    ownerName: "John Doe",
    location: "North District",
    status: "Active",
    joinedDate: "2024-02-15",
    feePercentage: 8,
    isFeeActive: true,
    useGlobalFee: false,
  },
  {
    id: "3",
    name: "The Healthy Bite",
    category: "Gourmet",
    ownerName: "David Lee",
    location: "South Side",
    status: "Active",
    joinedDate: "2024-02-28",
    feePercentage: 12,
    isFeeActive: true,
    useGlobalFee: false,
  },
  {
    id: "4",
    name: "Desert Rose Cafe",
    category: "Cafe",
    ownerName: "Emma Watson",
    location: "West End",
    status: "Inactive",
    joinedDate: "2024-03-12",
    feePercentage: 8,
    isFeeActive: false,
    useGlobalFee: true,
  },
  {
    id: "5",
    name: "Al-Madina Gourmet",
    category: "Premium Dining",
    ownerName: "Michael Smith",
    location: "Marina Mall",
    status: "Active",
    joinedDate: "2024-01-20",
    feePercentage: 10,
    isFeeActive: true,
    useGlobalFee: true,
  },
];

const ShopFees = () => {
  const globalFee = 10;
  const columns = useMemo(() => getShopFeeColumns({ globalFee }), [globalFee]);

  return (
    <PageLayout>
      <div className="flex flex-col gap-8">
        <div className="flex flex-col gap-6">
          <PageHeader
            title="Shop Fees"
            description="Manage platform-wide fee structures and individual shop commissions"
          />

          {/* Global Fee Settings Card */}
          <div className="bg-card border border-border rounded-2xl p-6 shadow-sm">
            <div className="flex flex-col gap-4">
              <div className="flex flex-col gap-1">
                <h3 className="text-lg font-bold text-foreground">Global Fee Settings</h3>
                <p className="text-sm text-muted-foreground">Set dynamic fees that apply across the platform during checkout</p>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                {/* Platform Commission */}
                <div className="flex flex-col gap-3 p-4 bg-muted/30 rounded-xl border border-border/50">
                  <div className="flex flex-col gap-1">
                    <span className="text-[10px] font-extrabold uppercase tracking-widest text-primary/80">Platform Fee</span>
                    <span className="text-sm font-semibold text-foreground">Global Commission</span>
                  </div>
                  <div className="flex items-center gap-2">
                    <div className="relative flex-1">
                      <Input
                        type="number"
                        defaultValue={10}
                        className="pr-8 font-bold text-primary"
                      />
                      <Percent className="absolute right-2.5 top-1/2 -translate-y-1/2 h-3.5 w-3.5 text-muted-foreground/60 pointer-events-none" />
                    </div>
                    <Button size="icon" className="shrink-0">
                      <Save className="h-4 w-4" />
                    </Button>
                  </div>
                </div>

                {/* Processing Fee */}
                <div className="flex flex-col gap-3 p-4 bg-muted/30 rounded-xl border border-border/50">
                  <div className="flex flex-col gap-1">
                    <span className="text-[10px] font-extrabold uppercase tracking-widest text-primary/80">Transaction</span>
                    <span className="text-sm font-semibold text-foreground">Processing Fee</span>
                  </div>
                  <div className="flex items-center gap-2">
                    <div className="relative flex-1">
                      <Input
                        type="number"
                        defaultValue={2.5}
                        className="pr-8 font-bold text-primary"
                      />
                      <Percent className="absolute right-2.5 top-1/2 -translate-y-1/2 h-3.5 w-3.5 text-muted-foreground/60 pointer-events-none" />
                    </div>
                    <Button size="icon" className="shrink-0">
                      <Save className="h-4 w-4" />
                    </Button>
                  </div>
                </div>

                {/* Service Fee */}
                {/* <div className="flex flex-col gap-3 p-4 bg-muted/30 rounded-xl border border-border/50">
                  <div className="flex flex-col gap-1">
                    <span className="text-[10px] font-extrabold uppercase tracking-widest text-primary/80">Maintenance</span>
                    <span className="text-sm font-semibold text-foreground">Service Fee</span>
                  </div>
                  <div className="flex items-center gap-2">
                    <div className="relative flex-1">
                      <Input
                        type="number"
                        defaultValue={1.5}
                        className="pr-8 font-bold text-primary"
                      />
                      <Percent className="absolute right-2.5 top-1/2 -translate-y-1/2 h-3.5 w-3.5 text-muted-foreground/60 pointer-events-none" />
                    </div>
                    <Button size="icon" className="shrink-0">
                      <Save className="h-4 w-4" />
                    </Button>
                  </div>
                </div> */}
              </div>
            </div>
          </div>
        </div>

        <div className="flex flex-col gap-4">
          <div className="flex items-center justify-between">
            <div className="flex flex-col gap-1">
              <h3 className="text-lg font-bold text-foreground">Individual Shop Fees</h3>
              <p className="text-sm text-muted-foreground">Adjust commissions for specific shops</p>
            </div>
          </div>
          <DataTable columns={columns} data={INITIAL_DATA} />
        </div>
      </div>
    </PageLayout>
  );
};

export default ShopFees;
