import PageLayout from "@/components/common/page-layout";
import {
  newsfeedColumns,
  type NewsfeedItem,
} from "@/components/management/newsfeed/newsfeed-columns";
import { NewsfeedFilter } from "@/components/management/newsfeed/newsfeed-filter";
import { DataTable } from "@/components/ui/custom/data-table";
import PageHeader from "@/components/ui/custom/page-header";

const newsfeed: NewsfeedItem[] = [
  {
    id: 1,
    name: "Hilda Reinger",
    avatar: "https://i.pravatar.cc/150?u=1",
    caption: "Lorem ipsum dolor sit amet",
    date: "2 days ago",
    views: "1.5k",
    accountType: "User",
  },
  {
    id: 2,
    name: "Kerry Trantow",
    avatar: "https://i.pravatar.cc/150?u=2",
    caption: "Lorem ipsum dolor sit amet",
    date: "2 days ago",
    views: "1.5k",
    accountType: "User",
  },
  {
    id: 3,
    name: "Geneva Pfannerstill",
    avatar: "https://i.pravatar.cc/150?u=3",
    caption: "Lorem ipsum dolor sit",
    date: "2 days ago",
    views: "1.5k",
    accountType: "User",
  },
  {
    id: 4,
    name: "Everett Williamson",
    avatar: "https://i.pravatar.cc/150?u=4",
    caption: "Lorem ipsum dolor sit amet",
    date: "2 days ago",
    views: "1.5k",
    accountType: "Trainer",
  },
  {
    id: 5,
    name: "Tonya Parker",
    avatar: "https://i.pravatar.cc/150?u=5",
    caption: "Lorem ipsum dolor sit",
    date: "2 days ago",
    views: "1.5k",
    accountType: "User",
  },
  {
    id: 6,
    name: "Jan Leuschke",
    avatar: "https://i.pravatar.cc/150?u=6",
    caption: "Lorem ipsum dolor sit",
    date: "2 days ago",
    views: "1.5k",
    accountType: "User",
  },
  {
    id: 7,
    name: "Melinda Cummings",
    avatar: "https://i.pravatar.cc/150?u=7",
    caption: "Lorem ipsum dolor sit amet",
    date: "2 days ago",
    views: "1.5k",
    accountType: "Trainer",
  },
  {
    id: 8,
    name: "Kelvin Gusikowski",
    avatar: "https://i.pravatar.cc/150?u=8",
    caption: "Lorem ipsum dolor sit amet",
    date: "2 days ago",
    views: "1.5k",
    accountType: "Trainer",
  },
  {
    id: 9,
    name: "Meredith Labadie",
    avatar: "https://i.pravatar.cc/150?u=9",
    caption: "Lorem ipsum dolor sit amet",
    date: "2 days ago",
    views: "1.5k",
    accountType: "Trainer",
  },
  {
    id: 10,
    name: "Simon Emard",
    avatar: "https://i.pravatar.cc/150?u=10",
    caption: "Lorem ipsum dolor sit amet",
    date: "2 days ago",
    views: "1.5k",
    accountType: "Trainer",
  },
];

const meta = {
  total: newsfeed.length,
  page: 1,
  limit: 10,
  totalPages: Math.ceil(newsfeed.length / 10),
};

const Newsfeed = () => {
  return (
    <PageLayout>
      <div className="flex flex-col md:flex-row md:justify-between">
        <PageHeader title="Newsfeed Moderation" description="Manage the newsfeed here" />
        <NewsfeedFilter />
      </div>
      <DataTable columns={newsfeedColumns} data={newsfeed} meta={meta} />
    </PageLayout>
  );
};

export default Newsfeed;
