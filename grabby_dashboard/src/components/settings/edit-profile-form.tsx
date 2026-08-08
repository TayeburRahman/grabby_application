import { useEffect, useState } from "react";
import { zodResolver } from "@hookform/resolvers/zod";
import { useForm } from "react-hook-form";
import * as z from "zod";
import { Button } from "@/components/ui/button";
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Phone, Mail, User, MapPin, Save, Loader2 } from "lucide-react";
import { updateMyProfile } from "@/services/auth";
import { ErrorToast, SuccessToast } from "@/lib/utils";

const profileSchema = z.object({
  name: z.string().min(2, { message: "Name must be at least 2 characters." }),
  email: z.string().email({ message: "Please enter a valid email address." }),
  phone_number: z.string().min(10, { message: "Phone number must be at least 10 characters." }),
  address: z.string().optional(),
});

type ProfileFormValues = z.infer<typeof profileSchema>;

interface EditProfileFormProps {
  initialData?: any;
  onUpdate?: () => void;
}

const EditProfileForm = ({ initialData, onUpdate }: EditProfileFormProps) => {
  const [saving, setSaving] = useState(false);

  const form = useForm<ProfileFormValues>({
    resolver: zodResolver(profileSchema),
    defaultValues: {
      name: initialData?.name || "",
      email: initialData?.email || "",
      phone_number: initialData?.phone_number || "",
      address: initialData?.address || "",
    },
  });

  // Update form when initialData changes
  useEffect(() => {
    if (initialData) {
      form.reset({
        name: initialData.name || "",
        email: initialData.email || "",
        phone_number: initialData.phone_number || "",
        address: initialData.address || "",
      });
    }
  }, [initialData, form]);

  async function onSubmit(values: ProfileFormValues) {
    setSaving(true);
    const result = await updateMyProfile(values);
    if (result.success) {
      SuccessToast("Profile updated successfully");
      // Update local storage user data
      const user = JSON.parse(localStorage.getItem("adminUser") || "{}");
      localStorage.setItem("adminUser", JSON.stringify({ ...user, ...result.data }));
      onUpdate?.();
    } else {
      ErrorToast(result.message);
    }
    setSaving(false);
  }

  return (
    <Card className="border-none shadow-md bg-background/50 backdrop-blur-sm hover:shadow-lg transition-all duration-300">
      <CardHeader className="pb-4 flex flex-row items-center gap-4">
        <div className="p-3 bg-primary/10 rounded-xl shrink-0">
          <User className="h-6 w-6 text-primary" />
        </div>
        <div className="space-y-1">
          <CardTitle className="text-xl font-bold">Personal Information</CardTitle>
          <p className="text-sm text-muted-foreground">
            Update your personal details and contact information.
          </p>
        </div>
      </CardHeader>
      <CardContent>
        <Form {...form}>
          <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-5">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
              <FormField
                control={form.control}
                name="name"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel className="font-semibold">Full Name</FormLabel>
                    <FormControl>
                      <div className="relative group">
                        <User className="absolute left-3 top-3 h-4 w-4 text-muted-foreground group-focus-within:text-primary transition-colors" />
                        <Input placeholder="John Doe" className="pl-10 bg-muted/30 focus:bg-background transition-all" {...field} />
                      </div>
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />

              <FormField
                control={form.control}
                name="email"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel className="font-semibold">Email Address</FormLabel>
                    <FormControl>
                      <div className="relative group">
                        <Mail className="absolute left-3 top-3 h-4 w-4 text-muted-foreground group-focus-within:text-primary transition-colors" />
                        <Input placeholder="admin@example.com" type="email" className="pl-10 bg-muted/30 focus:bg-background transition-all" {...field} disabled />
                      </div>
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />

              <FormField
                control={form.control}
                name="phone_number"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel className="font-semibold">Phone Number</FormLabel>
                    <FormControl>
                      <div className="relative group">
                        <Phone className="absolute left-3 top-3 h-4 w-4 text-muted-foreground group-focus-within:text-primary transition-colors" />
                        <Input placeholder="+1 234 567 890" className="pl-10 bg-muted/30 focus:bg-background transition-all" {...field} />
                      </div>
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />

              <FormField
                control={form.control}
                name="address"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel className="font-semibold">Location</FormLabel>
                    <FormControl>
                      <div className="relative group">
                        <MapPin className="absolute left-3 top-3 h-4 w-4 text-muted-foreground group-focus-within:text-primary transition-colors" />
                        <Input placeholder="123 Main St, New York" className="pl-10 bg-muted/30 focus:bg-background transition-all" {...field} />
                      </div>
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
            </div>

            <div className="pt-2">
              <Button type="submit" className="w-full md:w-auto px-8 gap-2 shadow-lg shadow-primary/20" disabled={saving}>
                {saving ? (
                  <Loader2 className="h-4 w-4 animate-spin" />
                ) : (
                  <Save className="h-4 w-4" />
                )}
                Save Changes
              </Button>
            </div>
          </form>
        </Form>
      </CardContent>
    </Card>
  );
};

export default EditProfileForm;
