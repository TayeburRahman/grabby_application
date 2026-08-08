/* eslint-disable @typescript-eslint/no-explicit-any */
import { useState } from "react";
import { ModalWrapper } from "@/components/ui/custom/modal-wrapper";
import { Badge } from "@/components/ui/badge";
import { Separator } from "@/components/ui/separator";
import { Button } from "@/components/ui/button";
import { Building2, User, Phone, Mail, MapPin, FileText, Eye, CheckCircle, XCircle, Loader2 } from "lucide-react";
import { ScrollArea } from "@/components/ui/scroll-area";
import { type ShopOwner } from "./shop-owners-columns";
import { acceptShopOwner, rejectShopOwner } from "@/services/admin";
import { SuccessToast, ErrorToast } from "@/lib/utils";
import { API_BASE_URL } from "@/services/auth";

interface ShopOwnerViewModalProps {
  shopOwner: ShopOwner;
  trigger?: React.ReactNode;
  onSuccess?: () => void;
}

export function ShopOwnerViewModal({ shopOwner, trigger, onSuccess }: ShopOwnerViewModalProps) {
  const [open, setOpen] = useState(false);
  const [loading, setLoading] = useState(false);

  const handleApprove = async () => {
    setLoading(true);
    const result = await acceptShopOwner(shopOwner._id);
    if (result.success) {
      SuccessToast(`${shopOwner.shop_name} has been approved!`);
      setOpen(false);
      onSuccess?.();
    } else {
      ErrorToast(result.message || "Failed to approve shop");
    }
    setLoading(false);
  };

  const handleReject = async () => {
    setLoading(true);
    const result = await rejectShopOwner(shopOwner._id);
    if (result.success) {
      SuccessToast(`${shopOwner.shop_name} has been rejected.`);
      setOpen(false);
      onSuccess?.();
    } else {
      ErrorToast(result.message || "Failed to reject shop");
    }
    setLoading(false);
  };

  return (
    <ModalWrapper
      open={open}
      onOpenChange={setOpen}
      title={`Shop Details: ${shopOwner.shop_name}`}
      description="Review shop owner's information for approval"
      actionTrigger={
        trigger || (
          <Button variant="outline" size="icon-sm" className="h-8 w-8 hover:bg-primary/10 hover:text-primary transition-all">
            <Eye className="h-4 w-4" />
          </Button>
        )
      }
      showClose={true}
    >
      <ScrollArea className="h-[70vh]">
        <div className="p-6 space-y-6">
          {/* Status Badge */}
          <div className="flex justify-between items-center">
            <span className="text-sm text-muted-foreground font-bold uppercase tracking-widest text-[10px]">
              Registration Status
            </span>
            <Badge
              variant={
                shopOwner.approval_status === "approved"
                  ? "success"
                  : shopOwner.approval_status === "rejected"
                  ? "destructive"
                  : ("warning" as any)
              }
              className="text-[10px] px-3 py-1 font-black uppercase tracking-widest"
            >
              {shopOwner.approval_status}
            </Badge>
          </div>

          <div className="grid grid-cols-2 gap-4 bg-muted/30 p-4 rounded-2xl border border-muted-foreground/10 shadow-sm">
            <div className="space-y-1">
              <span className="text-[10px] text-muted-foreground uppercase tracking-wider font-bold">
                Joined Date
              </span>
              <p className="text-sm font-black text-foreground">{new Date(shopOwner.createdAt).toLocaleDateString()}</p>
            </div>
            <div className="space-y-1">
              <span className="text-[10px] text-muted-foreground uppercase tracking-wider font-bold">
                License No.
              </span>
              <p className="text-sm font-black text-foreground">{shopOwner.shop_license_number || "PENDING"}</p>
            </div>
          </div>

          <Separator className="opacity-50" />

          {/* Shop Info */}
          <div className="space-y-3">
            <div className="flex items-center gap-2 text-primary">
              <div className="h-8 w-8 rounded-lg bg-primary/10 flex items-center justify-center">
                <Building2 className="h-4 w-4" />
              </div>
              <span className="font-black text-xs uppercase tracking-widest">Shop Information</span>
            </div>
            <div className="space-y-4 text-sm bg-muted/20 p-4 rounded-2xl border border-dashed">
              <div className="flex justify-between items-center">
                <span className="text-muted-foreground font-medium">Shop Name:</span>
                <span className="font-black text-primary uppercase tracking-tight">{shopOwner.shop_name}</span>
              </div>
              <div className="flex gap-3 items-start pt-2 border-t border-muted-foreground/10 mt-2">
                <MapPin className="h-4 w-4 text-primary mt-0.5 shrink-0" />
                <span className="text-foreground font-medium text-xs leading-relaxed">{shopOwner.location?.address || "Location not specified"}</span>
              </div>
            </div>
          </div>

          {/* Owner Info */}
          <div className="space-y-3">
            <div className="flex items-center gap-2 text-primary">
              <div className="h-8 w-8 rounded-lg bg-primary/10 flex items-center justify-center">
                <User className="h-4 w-4" />
              </div>
              <span className="font-black text-xs uppercase tracking-widest">Owner Information</span>
            </div>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="flex items-center gap-3 bg-muted/30 p-4 rounded-2xl border border-muted-foreground/10">
                <div className="h-10 w-10 rounded-xl bg-primary/10 flex items-center justify-center text-primary font-black text-lg shadow-sm border border-primary/20">
                  {shopOwner.name?.charAt(0).toUpperCase()}
                </div>
                <div className="flex flex-col">
                  <span className="text-[10px] text-muted-foreground font-bold uppercase tracking-tighter">Full Name</span>
                  <span className="text-sm font-black text-foreground">{shopOwner.name}</span>
                </div>
              </div>
              <div className="flex items-center gap-3 bg-muted/30 p-4 rounded-2xl border border-muted-foreground/10">
                <div className="h-10 w-10 rounded-xl bg-orange-100 flex items-center justify-center text-orange-600 border border-orange-200">
                  <Phone className="h-5 w-5" />
                </div>
                <div className="flex flex-col">
                  <span className="text-[10px] text-muted-foreground font-bold uppercase tracking-tighter">Phone</span>
                  <span className="text-sm font-black text-foreground font-mono">{shopOwner.phone_number}</span>
                </div>
              </div>
              <div className="flex items-center gap-3 bg-muted/30 p-4 rounded-2xl border border-muted-foreground/10 col-span-full">
                <div className="h-10 w-10 rounded-xl bg-blue-100 flex items-center justify-center text-blue-600 border border-blue-200">
                  <Mail className="h-5 w-5" />
                </div>
                <div className="flex flex-col">
                  <span className="text-[10px] text-muted-foreground font-bold uppercase tracking-tighter">Email Address</span>
                  <span className="text-sm font-black text-foreground">{shopOwner.email}</span>
                </div>
              </div>
            </div>
          </div>

          <Separator className="opacity-50" />

          {/* Documents Section */}
          <div className="space-y-3">
            <div className="flex items-center gap-2 text-primary">
              <div className="h-8 w-8 rounded-lg bg-primary/10 flex items-center justify-center">
                <FileText className="h-4 w-4" />
              </div>
              <span className="font-black text-xs uppercase tracking-widest">Business Documents</span>
            </div>
            {shopOwner.business_license ? (
              <div className="space-y-4">
                {/* PDF Preview if it's a PDF */}
                {shopOwner.business_license.toLowerCase().endsWith('.pdf') ? (
                  <div className="relative group rounded-2xl overflow-hidden border border-muted-foreground/10 bg-muted/20 shadow-inner p-1 h-[450px]">
                    <iframe 
                      src={`${API_BASE_URL}${shopOwner.business_license}#toolbar=0&navpanes=0`} 
                      className="w-full h-full rounded-xl border-none bg-white shadow-sm"
                      title="Business License PDF Preview"
                    />
                    <div className="absolute top-4 right-4 opacity-0 group-hover:opacity-100 transition-opacity">
                      <Button 
                        variant="secondary" 
                        size="sm" 
                        className="font-black text-[10px] uppercase tracking-widest shadow-xl border-primary/20"
                        onClick={() => window.open(`${API_BASE_URL}${shopOwner.business_license}`, '_blank')}
                      >
                        <Eye className="mr-2 h-3.5 w-3.5" />
                        Full Screen
                      </Button>
                    </div>
                  </div>
                ) : (shopOwner.business_license.toLowerCase().endsWith('.doc') || 
                     shopOwner.business_license.toLowerCase().endsWith('.docx')) ? (
                  /* Doc File Placeholder Image/Card */
                  <div className="relative group rounded-2xl overflow-hidden border border-muted-foreground/10 bg-blue-50/30 p-8 flex flex-col items-center justify-center text-center gap-4">
                    <div className="h-20 w-16 bg-white rounded-lg border-2 border-blue-200 shadow-md flex items-center justify-center relative">
                      <div className="absolute top-0 right-0 w-6 h-6 bg-blue-100 border-b-2 border-l-2 border-blue-200 rounded-bl-lg" />
                      <FileText className="h-8 w-8 text-blue-600" />
                    </div>
                    <div>
                      <p className="text-sm font-black text-blue-900 uppercase tracking-tight">Microsoft Word Document</p>
                      <p className="text-[10px] text-blue-600 font-bold">Direct download required for viewing</p>
                    </div>
                    <Button 
                      variant="outline" 
                      size="sm" 
                      className="border-blue-200 text-blue-600 hover:bg-blue-100 font-black text-[10px] uppercase tracking-widest"
                      onClick={() => window.open(`${API_BASE_URL}${shopOwner.business_license}`, '_blank')}
                    >
                      Download to View
                    </Button>
                  </div>
                ) : (
                  /* Visual Preview if Image */
                  (shopOwner.business_license.toLowerCase().endsWith('.jpg') || 
                    shopOwner.business_license.toLowerCase().endsWith('.jpeg') || 
                    shopOwner.business_license.toLowerCase().endsWith('.png')) && (
                    <div className="relative group rounded-2xl overflow-hidden border border-muted-foreground/10 bg-muted/20 shadow-inner p-1">
                      <img 
                        src={`${API_BASE_URL}${shopOwner.business_license}`} 
                        alt="Business License Preview" 
                        className="w-full h-auto max-h-[300px] object-contain rounded-xl transition-transform duration-500 group-hover:scale-[1.02]"
                      />
                      <div className="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center">
                        <Button 
                          variant="secondary" 
                          size="sm" 
                          className="font-black text-[10px] uppercase tracking-widest"
                          onClick={() => window.open(`${API_BASE_URL}${shopOwner.business_license}`, '_blank')}
                        >
                          <Eye className="mr-2 h-3.5 w-3.5" />
                          Full Preview
                        </Button>
                      </div>
                    </div>
                  )
                )}
                
                <div className="p-4 bg-primary/5 rounded-2xl border border-primary/10 flex items-center justify-between shadow-sm">
                  <div className="flex items-center gap-4">
                    <div className={`h-12 w-12 rounded-xl flex items-center justify-center border ${
                      shopOwner.business_license.toLowerCase().endsWith('.pdf') ? 'bg-red-100 border-red-200' : 
                      (shopOwner.business_license.toLowerCase().endsWith('.doc') || shopOwner.business_license.toLowerCase().endsWith('.docx')) ? 'bg-blue-100 border-blue-200' : 
                      'bg-primary/10 border-primary/20'
                    }`}>
                      <FileText className={`h-6 w-6 ${
                        shopOwner.business_license.toLowerCase().endsWith('.pdf') ? 'text-red-600' : 
                        (shopOwner.business_license.toLowerCase().endsWith('.doc') || shopOwner.business_license.toLowerCase().endsWith('.docx')) ? 'text-blue-600' : 
                        'text-primary'
                      }`} />
                    </div>
                    <div>
                      <p className="text-sm font-black text-foreground uppercase tracking-tight">
                        {shopOwner.business_license.toLowerCase().endsWith('.pdf') ? 'Business License (PDF)' : 
                         (shopOwner.business_license.toLowerCase().endsWith('.doc') || shopOwner.business_license.toLowerCase().endsWith('.docx')) ? 'Business License (DOC)' : 
                         'Business License Image'}
                      </p>
                      <p className="text-[10px] text-primary font-bold italic uppercase tracking-tighter">Verified Business Entity</p>
                    </div>
                  </div>
                  <Button 
                    variant="ghost" 
                    size="sm" 
                    className="font-black text-xs uppercase tracking-widest text-primary hover:bg-primary/10"
                    onClick={() => window.open(`${API_BASE_URL}${shopOwner.business_license}`, '_blank')}
                  >
                    <Eye className="mr-2 h-4 w-4" />
                    {shopOwner.business_license.toLowerCase().endsWith('.pdf') ? 'Open PDF' : 
                     (shopOwner.business_license.toLowerCase().endsWith('.doc') || shopOwner.business_license.toLowerCase().endsWith('.docx')) ? 'Download' : 
                     'View'}
                  </Button>
                </div>
              </div>
            ) : (
              <div className="p-8 bg-muted/20 rounded-2xl border border-dashed flex flex-col items-center justify-center text-center gap-2">
                <XCircle className="h-8 w-8 text-muted-foreground/30" />
                <p className="text-sm font-bold text-muted-foreground">No documents uploaded yet</p>
              </div>
            )}
          </div>

          {/* Action Buttons */}
          {shopOwner.approval_status === "pending" && (
            <div className="flex flex-col md:flex-row gap-4 pt-6 border-t border-muted-foreground/10">
              <Button
                onClick={handleApprove}
                disabled={loading}
                className="flex-1 h-14 rounded-2xl bg-green-600 hover:bg-green-700 text-white font-black uppercase tracking-widest shadow-lg shadow-green-600/20 gap-3 text-xs"
              >
                {loading ? <Loader2 className="h-5 w-5 animate-spin" /> : <CheckCircle className="h-5 w-5" />}
                Approve Shop
              </Button>
              <Button
                onClick={handleReject}
                disabled={loading}
                variant="destructive"
                className="flex-1 h-14 rounded-2xl font-black uppercase tracking-widest shadow-lg shadow-destructive/20 gap-3 text-xs"
              >
                {loading ? <Loader2 className="h-5 w-5 animate-spin" /> : <XCircle className="h-5 w-5" />}
                Reject Shop
              </Button>
            </div>
          )}
        </div>
      </ScrollArea>
    </ModalWrapper>
  );
}
