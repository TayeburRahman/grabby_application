import { useState, useEffect } from "react";
import { ModalWrapper } from "@/components/ui/custom/modal-wrapper";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Percent, Loader2, Store, Badge } from "lucide-react";
import { type Promotion } from "./promotions-columns";
import { createPromo, updatePromo } from "@/services/promo";
import { getAllShopOwners } from "@/services/order";
import { ErrorToast, SuccessToast } from "@/lib/utils";
import MultipleSelector, { type Option } from "@/components/ui/multiple-selector";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";

import {
  Avatar,
  AvatarFallback,
  AvatarImage,
} from "@/components/ui/avatar";
import { API_BASE_URL } from "@/services/auth";

interface PromotionModalProps {
  mode: "create" | "edit";
  promotion?: Promotion;
  trigger?: React.ReactNode;
  onSuccess?: () => void;
}

export const PromotionModal = ({ mode, promotion, trigger, onSuccess }: PromotionModalProps) => {
  const [open, setOpen] = useState(false);
  const [loading, setLoading] = useState(false);
  const [shops, setShops] = useState<any[]>([]);
  const [selectedShops, setSelectedShops] = useState<Option[]>([]);
  const [formData, setFormData] = useState<{
    code: string;
    discountPercent: number;
    shopOwnerId: string;
    branchIds: "all" | string[];
    status: string;
  }>({
    code: promotion?.code || "",
    discountPercent: promotion?.discountPercent || 0,
    shopOwnerId: promotion?.shopOwnerId?._id || "",
    branchIds: "all",
    status: promotion?.status || "active",
  });

  const getShopImageUrl = (path: string) => {
    if (!path) return "";
    return `${API_BASE_URL.replace("/api/v1", "")}${path}`;
  };

  useEffect(() => {
    if (mode === "edit" && promotion) {
      setFormData({
        code: promotion.code || "",
        discountPercent: promotion.discountPercent || 0,
        shopOwnerId: promotion.shopOwnerId?._id || "",
        branchIds: promotion.branchIds || "all",
        status: promotion.status || "active",
      });
      setSelectedShops([{
        value: promotion.shopOwnerId?._id || "",
        label: promotion.shopOwnerId?.shop_name || "Unknown Shop"
      }]);
    } else if (mode === "create") {
      setFormData({
        code: "",
        discountPercent: 0,
        shopOwnerId: "",
        branchIds: "all",
        status: "active",
      });
      setSelectedShops([]);
    }
  }, [promotion, mode, open]);

  useEffect(() => {
    if (open) {
      const fetchShops = async () => {
        const result = await getAllShopOwners();
        if (result.success) setShops(result.data);
      };
      fetchShops();
    }
  }, [open]);

  const handleSubmit = async () => {
    if (!formData.code || !formData.discountPercent) {
      ErrorToast("Please fill all required fields");
      return;
    }

    if (mode === "create" && selectedShops.length === 0) {
      ErrorToast("Please select at least one shop");
      return;
    }

    if (mode === "edit" && !formData.shopOwnerId) {
      ErrorToast("Please select a shop");
      return;
    }

    setLoading(true);

    if (mode === "create") {
      let successCount = 0;
      let lastMessage = "";

      for (const shopOption of selectedShops) {
        const result = await createPromo({
          ...formData,
          shopOwnerId: shopOption.value
        });
        if (result.success) {
          successCount++;
        } else {
          lastMessage = result.message;
        }
      }

      if (successCount > 0) {
        SuccessToast(`${successCount} promo code(s) created!`);
        if (successCount < selectedShops.length) {
          ErrorToast(`Failed to create ${selectedShops.length - successCount} promo codes: ${lastMessage}`);
        }
        setOpen(false);
        onSuccess?.();
      } else {
        ErrorToast(lastMessage || "Failed to create promo codes");
      }
    } else {
      const result = await updatePromo(promotion!._id, formData);
      if (result.success) {
        SuccessToast("Changes saved!");
        setOpen(false);
        onSuccess?.();
      } else {
        ErrorToast(result.message || "Something went wrong");
      }
    }
    
    setLoading(false);
  };

  const shopOptions: Option[] = shops.map(shop => ({
    value: shop._id,
    label: shop.shop_name,
  }));

  return (
    <ModalWrapper
      open={open}
      onOpenChange={setOpen}
      title={mode === "create" ? "Create New Promo Code" : "Edit Promo Code"}
      actionTrigger={
        trigger || (
          <Button className="bg-primary text-primary-foreground hover:bg-primary/90 font-bold uppercase tracking-widest text-xs h-10 px-6 rounded-xl">
            + New Promo Code
          </Button>
        )
      }
    >
      <div className="p-6">
        <div className="flex flex-col gap-6">
          <div className="flex flex-col gap-2">
            <Label className="font-bold text-muted-foreground uppercase tracking-widest text-[10px]">
              {mode === "create" ? "Target Shops (Multiple)" : "Target Shop"}
            </Label>
            
            {mode === "create" ? (
              <MultipleSelector
                value={selectedShops}
                onChange={setSelectedShops}
                options={shopOptions}
                placeholder="Select one or more shops..."
                emptyIndicator={
                  <p className="text-center text-sm leading-10 text-muted-foreground">
                    No shops found.
                  </p>
                }
                className="bg-muted/50 border-muted-foreground/10 rounded-2xl p-1"
              />
            ) : (
              <Select
                value={formData.shopOwnerId}
                onValueChange={(val) => setFormData(prev => ({ ...prev, shopOwnerId: val }))}
                disabled={mode === "edit"}
              >
                <SelectTrigger className="bg-muted/50 border-muted-foreground/10 h-14 rounded-2xl ring-offset-background transition-all focus:ring-2 focus:ring-primary/20">
                  <div className="flex items-center gap-3">
                    {formData.shopOwnerId ? (
                      <Avatar className="h-8 w-8 border-2 border-primary/20 shadow-sm">
                        <AvatarImage src={getShopImageUrl(shops.find(s => s._id === formData.shopOwnerId)?.profile_image)} />
                        <AvatarFallback className="bg-primary/10 text-primary font-black text-[10px]">SH</AvatarFallback>
                      </Avatar>
                    ) : (
                      <div className="h-8 w-8 rounded-full bg-muted flex items-center justify-center border border-dashed border-muted-foreground/30">
                        <Store className="h-4 w-4 text-muted-foreground" />
                      </div>
                    )}
                    <SelectValue placeholder="Select a target shop" />
                  </div>
                </SelectTrigger>
                <SelectContent className="rounded-2xl border-muted-foreground/10 shadow-2xl p-2 max-h-[400px]">
                  {shops.map((shop) => (
                    <SelectItem key={shop._id} value={shop._id} className="cursor-pointer rounded-xl focus:bg-primary/5 py-3 px-3 transition-colors mb-1 last:mb-0">
                      <div className="flex items-center gap-4">
                        <Avatar className="h-10 w-10 border-2 border-muted shadow-sm">
                          <AvatarImage src={getShopImageUrl(shop.profile_image)} />
                          <AvatarFallback className="bg-primary/10 text-primary font-black text-xs">
                            {shop.shop_name?.substring(0, 2).toUpperCase() || "SO"}
                          </AvatarFallback>
                        </Avatar>
                        <div className="flex flex-col gap-0.5">
                          <span className="font-black text-foreground text-sm tracking-tight">{shop.shop_name}</span>
                          <span className="text-[10px] text-muted-foreground font-medium italic flex items-center gap-1.5 uppercase tracking-widest">
                            <div className="h-1 w-1 rounded-full bg-primary" />
                            Owner: {shop.name}
                          </span>
                        </div>
                      </div>
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            )}
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div className="flex flex-col gap-2">
              <Label htmlFor="code" className="font-bold text-muted-foreground uppercase tracking-widest text-[10px]">Promo Code</Label>
              <Input
                id="code"
                placeholder="SAVE20"
                className="h-12 rounded-xl border-muted-foreground/10 bg-muted/50 font-black uppercase tracking-widest"
                value={formData.code}
                onChange={(e) => setFormData(prev => ({ ...prev, code: e.target.value.toUpperCase() }))}
              />
            </div>

            <div className="flex flex-col gap-2">
              <Label htmlFor="discount" className="font-bold text-muted-foreground uppercase tracking-widest text-[10px]">Discount (%)</Label>
              <div className="relative">
                <Input
                  id="discount"
                  type="number"
                  placeholder="0"
                  className="h-12 rounded-xl border-muted-foreground/10 bg-muted/50 font-black"
                  value={formData.discountPercent}
                  onChange={(e) => setFormData(prev => ({ ...prev, discountPercent: Number(e.target.value) }))}
                />
                <div className="absolute right-4 top-1/2 -translate-y-1/2 text-primary">
                  <Percent className="h-4 w-4 font-black" />
                </div>
              </div>
            </div>
          </div>

          <div className="flex flex-col gap-2">
            <Label className="font-bold text-muted-foreground uppercase tracking-widest text-[10px]">Applicable At</Label>
            <div className="p-4 bg-primary/5 border border-primary/10 rounded-xl flex items-center justify-between">
              <span className="text-xs font-bold text-primary italic">All Branches for this Shop</span>
              <Badge className="rounded-full px-3 py-0.5 text-[9px] font-black uppercase tracking-widest">Global</Badge>
            </div>
          </div>

          <div className="flex gap-4 pt-4">
            <Button
              variant="outline"
              className="flex-1 h-12 rounded-xl border-muted-foreground/10 font-bold uppercase tracking-widest text-xs"
              onClick={() => setOpen(false)}
            >
              Cancel
            </Button>
            <Button
              className="flex-1 h-12 rounded-xl font-bold uppercase tracking-widest text-xs"
              onClick={handleSubmit}
              disabled={loading}
            >
              {loading ? <Loader2 className="h-4 w-4 animate-spin" /> : mode === "create" ? "Create Promo" : "Save Changes"}
            </Button>
          </div>
        </div>
      </div>
    </ModalWrapper>
  );
};
