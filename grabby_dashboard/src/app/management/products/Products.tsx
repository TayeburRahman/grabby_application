import { useState, useEffect, useCallback } from "react";
import PageLayout from "@/components/common/page-layout";
import { DataTable } from "@/components/ui/custom/data-table";
import PageHeader from "@/components/ui/custom/page-header";
import {
  productsColumns,
  type Product,
} from "@/components/management/products/products-columns";
import { Card } from "@/components/ui/card";
import { Loader2 } from "lucide-react";
import { getAllProducts } from "@/services/product";
import { getAllCategories } from "@/services/category";
import { getAllShopOwners } from "@/services/order";
import { ErrorToast } from "@/lib/utils";
import { Store, Filter, ListFilter, LayoutGrid } from "lucide-react";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";

const Products = () => {
  const [products, setProducts] = useState<Product[]>([]);
  const [shopOwners, setShopOwners] = useState<any[]>([]);
  const [categories, setCategories] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedShop, setSelectedShop] = useState<string>("all");
  const [selectedCategory, setSelectedCategory] = useState<string>("all");
  const [page, setPage] = useState(1);
  const [limit, setLimit] = useState(10);
  const [meta, setMeta] = useState<any>(null);


  const fetchShopOwners = useCallback(async () => {
    const result = await getAllShopOwners();
    console.log("Fetch shop owners result:", result);
    if (result.success) {
      setShopOwners(result.data);
    }
  }, []);

  const fetchCategories = useCallback(async () => {
    const result = await getAllCategories();
    console.log("Fetch categories result:", result);
    if (result.success) {
      setCategories(result.data);
    }
  }, []);

  const fetchProducts = useCallback(async () => {
    setLoading(true);
    const query: any = {
      page,
      limit,
    };
    if (selectedShop !== "all") query.shop = selectedShop;
    if (selectedCategory !== "all") query.category = selectedCategory;

    const result = await getAllProducts(query);
    console.log("Fetch products result:", result);
    if (result.success) {
      setProducts(result.data);
      setMeta(result.meta);
    } else {
      ErrorToast(result.message || "Failed to fetch products");
    }
    setLoading(false);
  }, [page, limit, selectedCategory, selectedShop]);

  useEffect(() => {
    fetchShopOwners();
    fetchCategories();
  }, [fetchShopOwners, fetchCategories]);

  useEffect(() => {
    fetchProducts();
  }, [fetchProducts]);


  useEffect(() => {
    setPage(1);
  }, [selectedShop, selectedCategory]);

  const onPaginationChange = (newPage: number, newLimit: number) => {
    setPage(newPage);
    setLimit(newLimit);
  };

  const stats = {
    total: meta?.total || 0,
    available: meta?.totalAvailable || products.filter(p => p.isAvailable).length,
    unavailable: meta?.totalUnavailable || products.filter(p => !p.isAvailable).length,
    categories: categories.length
  };

  return (
    <PageLayout>
      <div className="flex flex-col gap-6">
        {/* Header */}
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <PageHeader
            title="Menu / Products"
            description="Manage your menu items and pricing"
          />
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          <Card className="p-4 bg-muted/50 border-none flex flex-col gap-2">
            <p className="text-sm font-medium text-muted-foreground">
              Total Items
            </p>
            <p className="text-3xl font-bold text-foreground">{stats.total}</p>
          </Card>
          <Card className="p-4 bg-muted/50 border-none flex flex-col gap-2">
            <p className="text-sm font-medium text-muted-foreground">
              Available (Total)
            </p>
            <p className="text-3xl font-bold text-green-600">{stats.available}</p>
          </Card>
          <Card className="p-4 bg-muted/50 border-none flex flex-col gap-2">
            <p className="text-sm font-medium text-muted-foreground">
              Unavailable (Total)
            </p>
            <p className="text-3xl font-bold text-red-600">{stats.unavailable}</p>
          </Card>
          <Card className="p-4 bg-muted/50 border-none flex flex-col gap-2">
            <p className="text-sm font-medium text-muted-foreground">
              Categories
            </p>
            <p className="text-3xl font-bold text-foreground">{stats.categories}</p>
          </Card>
        </div>

        {/* Filter Section */}
        <div className="bg-card/30 backdrop-blur-md border border-muted-foreground/10 p-5 rounded-2xl shadow-sm flex flex-col md:flex-row items-end gap-5">
          {/* Shop Selection */}
          <div className="w-full md:flex-1 space-y-2">
            <div className="flex items-center gap-2 px-1">
              <Store className="h-3.5 w-3.5 text-primary" />
              <span className="text-[11px] font-bold uppercase tracking-wider text-muted-foreground">Shop / Brand</span>
            </div>
            <Select value={selectedShop} onValueChange={setSelectedShop}>
              <SelectTrigger className="h-11 bg-background/50 border-muted-foreground/20 focus:ring-primary/20">
                <div className="flex items-center gap-2">
                  <LayoutGrid className="h-4 w-4 text-muted-foreground/70" />
                  <SelectValue placeholder="Select Shop" />
                </div>
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="all">All Shops / Brands</SelectItem>
                {shopOwners.map((shop) => (
                  <SelectItem key={shop._id} value={shop._id}>
                    {shop.shop_name || shop.name}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          {/* Category Selection */}
          <div className="w-full md:flex-1 space-y-2">
            <div className="flex items-center gap-2 px-1">
              <Filter className="h-3.5 w-3.5 text-primary" />
              <span className="text-[11px] font-bold uppercase tracking-wider text-muted-foreground">Category Filter</span>
            </div>
            <Select value={selectedCategory} onValueChange={setSelectedCategory}>
              <SelectTrigger className="h-11 bg-background/50 border-muted-foreground/20 focus:ring-primary/20">
                <div className="flex items-center gap-2">
                  <ListFilter className="h-4 w-4 text-muted-foreground/70" />
                  <SelectValue placeholder="Select Category" />
                </div>
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="all">All Categories</SelectItem>
                {categories.map((category) => (
                  <SelectItem key={category._id} value={category._id}>
                    {category.name}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
        </div>

        {/* Products Table Section */}
        <div className="flex flex-col gap-5">
          <div className="flex items-center justify-between px-1">
            <div className="flex items-center gap-2">
              <div className="h-5 w-1.5 bg-primary rounded-full shadow-[0_0_10px_rgba(var(--primary),0.5)]" />
              <h2 className="text-xl font-bold tracking-tight">Inventory Explorer</h2>
            </div>
            {!loading && (
              <div className="flex items-center gap-2 text-xs font-medium text-muted-foreground bg-muted/50 px-3 py-1.5 rounded-full border border-muted-foreground/10">
                <span className="h-2 w-2 rounded-full bg-green-500 animate-pulse" />
                {products.length} Items Loaded
              </div>
            )}
          </div>

          <div className="bg-card/50 backdrop-blur-sm rounded-3xl border border-muted-foreground/10 shadow-xl overflow-hidden">
            {loading ? (
              <div className="flex flex-col items-center justify-center h-[500px]">
                <div className="relative">
                  <div className="h-20 w-20 rounded-full border-4 border-primary/20 border-t-primary animate-spin" />
                  <Loader2 className="h-10 w-10 text-primary animate-pulse absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2" />
                </div>
                <p className="mt-6 text-lg font-semibold text-foreground/80 tracking-tight">Synchronizing inventory...</p>
                <p className="text-sm text-muted-foreground mt-2">Fetching the latest product data from our servers.</p>
              </div>
            ) : (
              <div className="p-1 sm:p-4">
                <DataTable
                  columns={productsColumns}
                  data={products}
                  meta={meta}
                  onPaginationChange={onPaginationChange}
                />
              </div>
            )}
          </div>
        </div>
      </div>
    </PageLayout>
  );
};

export default Products;
