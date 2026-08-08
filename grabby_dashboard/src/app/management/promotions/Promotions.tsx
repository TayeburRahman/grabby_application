import { useState, useEffect, useCallback } from "react";
import PageLayout from "@/components/common/page-layout";
import { DataTable } from "@/components/ui/custom/data-table";
import PageHeader from "@/components/ui/custom/page-header";
import { Card, CardContent } from "@/components/ui/card";
import {
  promotionsColumns,
  type Promotion,
} from "@/components/management/promotions/promotions-columns";
import { PromotionModal } from "@/components/management/promotions/promotion-modal";
import { getAllPromos, deletePromo, updatePromoStatus } from "@/services/promo";
import { ErrorToast, SuccessToast } from "@/lib/utils";
import { Input } from "@/components/ui/input";
import { Search, Loader2 } from "lucide-react";

const Promotions = () => {
  const [promotions, setPromotions] = useState<Promotion[]>([]);
  const [loading, setLoading] = useState(true);
  const [meta, setMeta] = useState<any>(null);
  const [page, setPage] = useState(1);
  const [limit, setLimit] = useState(10);
  const [searchTerm, setSearchTerm] = useState("");

  const fetchPromos = useCallback(async () => {
    setLoading(true);
    const query: any = { page, limit };
    if (searchTerm) query.shopName = searchTerm;

    const result = await getAllPromos(query);
    if (result.success) {
      setPromotions(result.data);
      setMeta(result.meta);
    } else {
      ErrorToast(result.message || "Failed to fetch promo codes");
    }
    setLoading(false);
  }, [page, limit, searchTerm]);

  useEffect(() => {
    fetchPromos();
  }, [fetchPromos]);

  const handleDelete = async (id: string) => {
    const result = await deletePromo(id);
    if (result.success) {
      SuccessToast("Promo code deleted successfully");
      fetchPromos();
    } else {
      ErrorToast(result.message || "Failed to delete promo code");
    }
  };

  const handleStatusChange = async (id: string, status: string) => {
    const result = await updatePromoStatus(id, status);
    if (result.success) {
      SuccessToast(`Promo code is now ${status}`);
      fetchPromos();
    } else {
      ErrorToast(result.message || "Failed to update promo status");
    }
  };

  const onPaginationChange = (newPage: number, newLimit: number) => {
    setPage(newPage);
    setLimit(newLimit);
  };

  const stats = {
    total: meta?.total || 0,
    active: promotions.filter(p => p.status === "active").length,
    averageDiscount: promotions.length > 0 
      ? (promotions.reduce((acc, p) => acc + p.discountPercent, 0) / promotions.length).toFixed(1)
      : 0,
  };

  return (
    <PageLayout>
      <div className="flex flex-col gap-6">
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <PageHeader
            title="Promotions & Discounts"
            description="Create and manage promotional offers across your network"
          />
          <div className="flex items-center gap-3">
            <div className="relative w-64">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
              <Input
                placeholder="Search by Shop Name..."
                className="pl-9 bg-background border-muted-foreground/20 focus:ring-primary/20"
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
              />
            </div>
            <PromotionModal mode="create" onSuccess={fetchPromos} />
          </div>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
          <Card className="bg-primary/5 border-primary/10">
            <CardContent className="pt-6">
              <div className="flex flex-col gap-1">
                <p className="text-sm font-bold text-muted-foreground uppercase tracking-wider">Total Active Promos</p>
                <div className="flex items-baseline gap-2">
                  <p className="text-4xl font-black text-primary">{stats.total}</p>
                  <p className="text-xs text-muted-foreground font-medium">codes in system</p>
                </div>
              </div>
            </CardContent>
          </Card>
          <Card className="bg-green-50 border-green-100">
            <CardContent className="pt-6">
              <div className="flex flex-col gap-1">
                <p className="text-sm font-bold text-green-700 uppercase tracking-wider">Current Live</p>
                <div className="flex items-baseline gap-2">
                  <p className="text-4xl font-black text-green-600">{stats.active}</p>
                  <p className="text-xs text-green-700/60 font-medium">active now</p>
                </div>
              </div>
            </CardContent>
          </Card>
          <Card className="bg-orange-50 border-orange-100">
            <CardContent className="pt-6">
              <div className="flex flex-col gap-1">
                <p className="text-sm font-bold text-orange-700 uppercase tracking-wider">Avg. Discount</p>
                <div className="flex items-baseline gap-2">
                  <p className="text-4xl font-black text-orange-600">{stats.averageDiscount}%</p>
                  <p className="text-xs text-orange-700/60 font-medium">customer savings</p>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Promotions Table */}
        <div className="relative">
          {loading && (
            <div className="absolute inset-0 bg-background/50 backdrop-blur-[1px] z-10 flex items-center justify-center rounded-2xl">
              <div className="flex flex-col items-center gap-2">
                <Loader2 className="h-8 w-8 animate-spin text-primary" />
                <p className="text-sm font-bold text-primary animate-pulse">Syncing Promos...</p>
              </div>
            </div>
          )}
          <DataTable 
            columns={promotionsColumns(handleDelete, handleStatusChange, fetchPromos)} 
            data={promotions} 
            meta={meta}
            onPaginationChange={onPaginationChange}
          />
        </div>
      </div>
    </PageLayout>
  );
};

export default Promotions;
