import PageLayout from "@/components/common/page-layout";
import { useState } from "react";
import { useForm } from "react-hook-form";
import {
  Form,
  // FormControl,
  FormField,
  FormItem,
  FormMessage,
} from "@/components/ui/form";
import { Button } from "@/components/ui/button";
// import { Input } from "@/components/ui/input";
import { Card, CardContent } from "@/components/ui/card";
import TiptapEditor from "@/components/ui/custom/tiptap-editor";
// import { ErrorToast, SuccessToast } from "@/lib/utils";
import { Save } from "lucide-react";
import PageHeader from "../../../components/ui/custom/page-header";


type FormValues = {
  title: string;
  content: string;
};

const Disclaimers = () => {
  const [isSubmitting, setIsSubmitting] = useState(false);

  const form = useForm<FormValues>({
    defaultValues: {
      title: "Disclaimers",
      content: "",
    },
  });

  const onSubmit = async (data: FormValues) => {
    console.log(data);
    try {
      setIsSubmitting(true);
      // const slug = generateSlug(data.title || "disclaimers");
      // await upsertPage({
      //   slug,
      //   title: data.title,
      //   content: data.content,
      // });
      // SuccessToast("Disclaimers page saved successfully");
      // eslint-disable-next-line @typescript-eslint/no-unused-vars
    } catch (error) {
      // ErrorToast("Failed to save Disclaimers page");
    } finally {
      setIsSubmitting(false);
    }
  };
  return (
    <PageLayout>
      <PageHeader title="Disclaimers" description="Manage the Disclaimers page content" />

      <Form {...form}>
        <form onSubmit={form.handleSubmit(onSubmit)}>
          <Card className="p-0 mb-4">
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

          <div className="flex justify-end">
            <Button
              type="submit"
              loadingText="Saving..."
              loading={isSubmitting}
            >
              <Save /> Save
            </Button>
          </div>
        </form>
      </Form>
    </PageLayout>
  );
};

export default Disclaimers;
