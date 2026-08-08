import { useState } from "react";
import { Eye, Utensils, Tag, CircleDollarSign, Info, Clock, CheckCircle2, XCircle } from "lucide-react";
import { Button } from "@/components/ui/button";
import { ModalWrapper } from "@/components/ui/custom/modal-wrapper";
import { Badge } from "@/components/ui/badge";
import { ScrollArea } from "@/components/ui/scroll-area";
import { type Product } from "./products-columns";
import { API_BASE_URL } from "@/services/auth";

interface ProductViewModalProps {
  product: Product;
}

export const ProductViewModal = ({ product }: ProductViewModalProps) => {
  const [open, setOpen] = useState(false);
  const imageUrl = product.image ? `${API_BASE_URL.replace("/api/v1", "")}${product.image}` : null;

  return (
    <ModalWrapper
      open={open}
      onOpenChange={setOpen}
      title="Product Details"
      actionTrigger={
        <Button variant="ghost" size="sm" className="bg-primary/10 text-primary hover:text-primary hover:bg-primary/20">
          <Eye className="mr-2 h-4 w-4" />
          View
        </Button>
      }
      showClose={true}
    >
      <ScrollArea className="max-h-[80vh]">
        <div className="p-6 space-y-6">
          {/* Product Header */}
          <div className="flex items-start gap-6 p-4 rounded-xl border bg-muted/30">
            <div className="h-24 w-24 rounded-xl bg-background border flex items-center justify-center overflow-hidden shrink-0 shadow-sm">
              {imageUrl ? (
                <img src={imageUrl} alt={product.itemName} className="h-full w-full object-cover" />
              ) : (
                <Utensils className="h-10 w-10 text-muted-foreground" />
              )}
            </div>
            <div className="flex flex-col gap-2 grow">
              <div className="flex items-center justify-between">
                <h4 className="text-2xl font-black text-foreground leading-tight">{product.itemName}</h4>
                <Badge variant={product.isAvailable ? "success" : "destructive"}>
                  {product.isAvailable ? <CheckCircle2 className="w-3 h-3 mr-1" /> : <XCircle className="w-3 h-3 mr-1" />}
                  {product.isAvailable ? "Available" : "Unavailable"}
                </Badge>
              </div>
              <div className="flex items-center gap-2">
                <Badge variant="outline" className="bg-primary/10 text-primary border-primary/20">
                  <Tag className="w-3 h-3 mr-1" />
                  {product.category?.name || "Uncategorized"}
                </Badge>
              </div>
            </div>
          </div>

          {/* Key Stats */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div className="p-4 rounded-xl border bg-card shadow-sm flex flex-col gap-1">
              <p className="text-xs font-semibold text-muted-foreground uppercase tracking-wider flex items-center gap-1">
                <CircleDollarSign className="w-3 h-3" /> Price
              </p>
              <p className="text-2xl font-black text-primary">AED {(Number(product.price) || 0).toFixed(2)}</p>
            </div>
            <div className="p-4 rounded-xl border bg-card shadow-sm flex flex-col gap-1">
              <p className="text-xs font-semibold text-muted-foreground uppercase tracking-wider flex items-center gap-1">
                <Clock className="w-3 h-3" /> Availability
              </p>
              <p className={`text-2xl font-black ${product.isAvailable ? "text-green-600" : "text-red-600"}`}>
                {product.isAvailable ? "In Stock" : "Out of Stock"}
              </p>
            </div>
          </div>

          {/* Description */}
          <div className="p-5 rounded-xl border bg-muted/10 space-y-3">
            <h5 className="text-xs font-bold text-muted-foreground uppercase tracking-widest flex items-center gap-1">
              <Info className="w-3 h-3" /> Description
            </h5>
            <p className="text-sm text-foreground/80 leading-relaxed">
              {product.description || "No description provided for this product."}
            </p>
          </div>

          {/* Additional Info Grid */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div className="p-4 rounded-xl border bg-card shadow-sm space-y-3">
              <h5 className="text-xs font-bold text-muted-foreground uppercase tracking-widest">Pricing Details</h5>
              <div className="space-y-2">
                <div className="flex justify-between text-sm">
                  <span className="text-muted-foreground">Unit Price</span>
                  <span className="font-medium">AED {(Number(product.price) || 0).toFixed(2)}</span>
                </div>
                <div className="flex justify-between text-sm">
                  <span className="text-muted-foreground">Currency</span>
                  <span className="font-medium">AED</span>
                </div>
              </div>
            </div>
            <div className="p-4 rounded-xl border bg-card shadow-sm space-y-3">
              <h5 className="text-xs font-bold text-muted-foreground uppercase tracking-widest">Account Info</h5>
              <div className="space-y-2">
                <div className="flex justify-between text-sm">
                  <span className="text-muted-foreground">Product ID</span>
                  <span className="font-medium text-[10px] truncate max-w-32">{product._id}</span>
                </div>
                <div className="flex justify-between text-sm">
                  <span className="text-muted-foreground">Status</span>
                  <span className={`font-medium ${product.isAvailable ? "text-green-600" : "text-red-600"}`}>
                    {product.isAvailable ? "Active" : "Inactive"}
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </ScrollArea>
    </ModalWrapper>
  );
};
