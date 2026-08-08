import { useState, useEffect, useCallback } from "react";
import PageLayout from "@/components/common/page-layout";
import { DataTable } from "@/components/ui/custom/data-table";
import PageHeader from "@/components/ui/custom/page-header";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Search, Loader2, Users, Clock, CheckCircle2, XCircle } from "lucide-react";
import { shopOwnersColumns, type ShopOwner } from "@/components/management/shop-owners/shop-owners-columns";
import { getShopOwnerRequests } from "@/services/admin";
import { ErrorToast } from "@/lib/utils";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";

const ShopOwners = () => {
  const [data, setData] = useState<ShopOwner[]>([]);
  const [loading, setLoading] = useState(true);
  const [meta, setMeta] = useState<any>(null);
  const [page, setPage] = useState(1);
  const [limit, setLimit] = useState(10);
  const [searchTerm, setSearchTerm] = useState("");
  const [statusFilter, setStatusFilter] = useState("all");

  const fetchData = useCallback(async () => {
    setLoading(true);
    const result = await getShopOwnerRequests({
      page,
      limit,
      searchTerm,
      approval_status: statusFilter === "all" ? "all" : statusFilter
    });

    if (result.success) {
      setData(result.data);
      setMeta(result.meta);
    } else {
      ErrorToast(result.message || "Failed to fetch shop owners");
    }
    setLoading(false);
  }, [page, limit, searchTerm, statusFilter]);

  useEffect(() => {
    fetchData();
  }, [fetchData]);

  const onPaginationChange = (newPage: number, newLimit: number) => {
    setPage(newPage);
    setLimit(newLimit);
  };

  const stats = {
    total: meta?.total || 0,
    pending: data.filter(d => d.approval_status === "pending").length,
    approved: data.filter(d => d.approval_status === "approved").length,
    rejected: data.filter(d => d.approval_status === "rejected").length,
  };

  return (
    <PageLayout>
      <div className="flex flex-col gap-6">
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <PageHeader
            title="Shop Owner Management"
            description="Manage and review shop owner registrations and account statuses"
          />
          
          <div className="flex flex-col sm:flex-row items-center gap-3">
            <div className="relative w-full sm:w-64">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
              <Input
                placeholder="Search by name, email, shop..."
                className="pl-9 h-11 bg-background border-muted-foreground/20 rounded-xl focus:ring-primary/20"
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
              />
            </div>
            
            <Select value={statusFilter} onValueChange={setStatusFilter}>
              <SelectTrigger className="h-11 w-full sm:w-40 rounded-xl border-muted-foreground/10 bg-background font-bold text-xs uppercase tracking-widest">
                <SelectValue placeholder="All Status" />
              </SelectTrigger>
              <SelectContent className="rounded-xl border-muted-foreground/10 shadow-xl">
                <SelectItem value="all" className="cursor-pointer font-bold text-xs uppercase tracking-widest">All Accounts</SelectItem>
                <SelectItem value="pending" className="cursor-pointer font-bold text-xs uppercase tracking-widest">Pending</SelectItem>
                <SelectItem value="approved" className="cursor-pointer font-bold text-xs uppercase tracking-widest">Approved</SelectItem>
                <SelectItem value="rejected" className="cursor-pointer font-bold text-xs uppercase tracking-widest">Rejected</SelectItem>
              </SelectContent>
            </Select>
          </div>
        </div>

        {/* Stats Grid */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          <Card className="bg-primary/5 border-primary/10 shadow-sm rounded-2xl overflow-hidden group hover:shadow-md transition-all">
            <CardContent className="p-6">
              <div className="flex items-center gap-4">
                <div className="h-12 w-12 rounded-xl bg-primary/10 flex items-center justify-center text-primary group-hover:scale-110 transition-transform">
                  <Users className="h-6 w-6" />
                </div>
                <div className="flex flex-col">
                  <p className="text-[10px] font-black text-muted-foreground uppercase tracking-widest">Total Shops</p>
                  <p className="text-2xl font-black text-primary">{stats.total}</p>
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="bg-orange-50 border-orange-100 shadow-sm rounded-2xl overflow-hidden group hover:shadow-md transition-all">
            <CardContent className="p-6">
              <div className="flex items-center gap-4">
                <div className="h-12 w-12 rounded-xl bg-orange-100 flex items-center justify-center text-orange-600 group-hover:scale-110 transition-transform">
                  <Clock className="h-6 w-6" />
                </div>
                <div className="flex flex-col">
                  <p className="text-[10px] font-black text-orange-700/60 uppercase tracking-widest">Pending Requests</p>
                  <p className="text-2xl font-black text-orange-600">{stats.pending}</p>
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="bg-green-50 border-green-100 shadow-sm rounded-2xl overflow-hidden group hover:shadow-md transition-all">
            <CardContent className="p-6">
              <div className="flex items-center gap-4">
                <div className="h-12 w-12 rounded-xl bg-green-100 flex items-center justify-center text-green-600 group-hover:scale-110 transition-transform">
                  <CheckCircle2 className="h-6 w-6" />
                </div>
                <div className="flex flex-col">
                  <p className="text-[10px] font-black text-green-700/60 uppercase tracking-widest">Approved Partners</p>
                  <p className="text-2xl font-black text-green-600">{stats.approved}</p>
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="bg-red-50 border-red-100 shadow-sm rounded-2xl overflow-hidden group hover:shadow-md transition-all">
            <CardContent className="p-6">
              <div className="flex items-center gap-4">
                <div className="h-12 w-12 rounded-xl bg-red-100 flex items-center justify-center text-red-600 group-hover:scale-110 transition-transform">
                  <XCircle className="h-6 w-6" />
                </div>
                <div className="flex flex-col">
                  <p className="text-[10px] font-black text-red-700/60 uppercase tracking-widest">Rejected Shops</p>
                  <p className="text-2xl font-black text-red-600">{stats.rejected}</p>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Table Section */}
        <div className="relative">
          {loading && (
            <div className="absolute inset-0 bg-background/50 backdrop-blur-[1px] z-10 flex items-center justify-center rounded-2xl">
              <div className="flex flex-col items-center gap-2">
                <Loader2 className="h-8 w-8 animate-spin text-primary" />
                <p className="text-sm font-bold text-primary animate-pulse tracking-widest uppercase">Syncing Partners...</p>
              </div>
            </div>
          )}
          <DataTable 
            columns={shopOwnersColumns(fetchData)} 
            data={data} 
            meta={meta}
            onPaginationChange={onPaginationChange}
          />
        </div>
      </div>
    </PageLayout>
  );
};

export default ShopOwners;
