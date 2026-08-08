import PageLayout from "@/components/common/page-layout";
import { useEffect, useState } from "react";
import { useForm } from "react-hook-form";
import {
  Form,
  FormField,
  FormItem,
  FormMessage,
} from "@/components/ui/form";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import TiptapEditor from "@/components/ui/custom/tiptap-editor";
import { ErrorToast, SuccessToast } from "@/lib/utils";
import { Save } from "lucide-react";
import PageHeader from "../../../components/ui/custom/page-header";
import { getTerms, saveTerms } from "@/services/terms";

type FormValues = {
  content: string;
};

const Terms = () => {
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [isLoading, setIsLoading] = useState(true);

  const form = useForm<FormValues>({
    defaultValues: {
      content: "",
    },
  });

  useEffect(() => {
    const fetchTerms = async () => {
      try {
        setIsLoading(true);
        const response = await getTerms();
        if (response?.success && response?.data) {
          form.reset({
            content: response.data.content,
          });
        }
      } catch (error) {
        console.error("Error fetching terms and conditions:", error);
      } finally {
        setIsLoading(false);
      }
    };

    fetchTerms();
  }, [form]);

  const onSubmit = async (data: FormValues) => {
    try {
      setIsSubmitting(true);
      const response = await saveTerms(data);
      if (response?.success) {
        SuccessToast("Terms and Conditions saved successfully");
      } else {
        ErrorToast(response?.message || "Failed to save Terms and Conditions");
      }
    } catch (error: any) {
      ErrorToast(error?.response?.data?.message || "Failed to save Terms and Conditions");
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <PageLayout>
      <PageHeader title="Terms and Conditions" description="Manage the Terms and Conditions page content" />

      {isLoading ? (
        <div className="flex items-center justify-center min-h-[400px]">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
        </div>
      ) : (
        <Form {...form}>
          <form onSubmit={form.handleSubmit(onSubmit)}>
            <Card className="p-0 mb-4 border-none shadow-none">
              <CardContent className="p-0">
                <div className="bg-card p-3 rounded-xl border shadow-sm">
                  <FormField
                    control={form.control}
                    name="content"
                    render={({ field }) => (
                      <FormItem className="space-y-0">
                        <TiptapEditor
                          value={field.value || ""}
                          onChange={field.onChange}
                        />
                        <FormMessage className="p-4" />
                      </FormItem>
                    )}
                  />
                </div>
              </CardContent>
            </Card>

            <div className="flex justify-end mt-6">
              <Button
                type="submit"
                disabled={isSubmitting}
                className="gap-2"
              >
                <Save className="w-4 h-4" /> {isSubmitting ? "Saving..." : "Save Changes"}
              </Button>
            </div>
          </form>
        </Form>
      )}
    </PageLayout>
  );
};

export default Terms;
