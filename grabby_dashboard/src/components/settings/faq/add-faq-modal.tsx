"use client";
import { useEffect, useState } from "react";
import { useForm } from "react-hook-form";
import { Plus } from "lucide-react";
import { Button } from "@/components/ui/button";
import { ModalWrapper } from "@/components/ui/custom/modal-wrapper";
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { type FAQ } from "./faq-columns";
import { createFaq, updateFaq } from "@/services/faq";
import { ErrorToast, SuccessToast } from "@/lib/utils";

interface AddFAQModalProps {
  mode?: "add" | "edit";
  faq?: FAQ;
  children?: React.ReactNode;
  onSuccess?: () => void;
}

type FAQFormValues = {
  question: string;
  answer: string;
};

const AddFAQModal = ({ mode = "add", faq, children, onSuccess }: AddFAQModalProps) => {
  const [open, setOpen] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);

  const form = useForm<FAQFormValues>({
    defaultValues: {
      question: faq?.question || "",
      answer: faq?.answer || "",
    },
  });

  useEffect(() => {
    if (open && mode === "edit" && faq) {
      form.reset({
        question: faq.question,
        answer: faq.answer,
      });
    }
  }, [open, mode, faq, form]);

  const onSubmit = async (data: FAQFormValues) => {
    try {
      setIsSubmitting(true);
      let response;
      if (mode === "add") {
        response = await createFaq(data);
      } else if (faq?.id) {
        response = await updateFaq(faq.id.toString(), data);
      }

      if (response?.success) {
        SuccessToast(mode === "add" ? "FAQ added successfully" : "FAQ updated successfully");
        setOpen(false);
        if (mode === "add") form.reset();
        if (onSuccess) onSuccess();
      } else {
        ErrorToast(response?.message || "Something went wrong");
      }
    } catch (error: any) {
      ErrorToast(error?.message || "Failed to save FAQ");
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <ModalWrapper
      open={open}
      onOpenChange={setOpen}
      title={mode === "add" ? "Add New FAQ" : "Edit FAQ"}
      description={mode === "add" ? "Add a new frequently asked question" : "Edit the frequently asked question"}
      actionTrigger={
        children || (
          <Button>
            <Plus className="w-4 h-4" />
            Add FAQ
          </Button>
        )
      }
    >
      <div className="p-6">
        <Form {...form}>
          <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
            <FormField
              control={form.control}
              name="question"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Question</FormLabel>
                  <FormControl>
                    <Input placeholder="Enter question" {...field} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
            <FormField
              control={form.control}
              name="answer"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Answer</FormLabel>
                  <FormControl>
                    <Textarea
                      placeholder="Enter answer"
                      className="min-h-[120px]"
                      {...field}
                    />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
            <div className="pt-4">
              <Button type="submit" className="w-full" disabled={isSubmitting}>
                {isSubmitting ? "Saving..." : (mode === "add" ? "Add FAQ" : "Save Changes")}
              </Button>
            </div>
          </form>
        </Form>
      </div>
    </ModalWrapper>
  );
};

export default AddFAQModal;
