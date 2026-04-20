import QueryBuilder from '../../../builder/QueryBuilder';
import { IUpcomingEvents } from './upcoming_events.interface';
import { UpcomingEvents } from './upcoming_events.model';

const create = async (payload: IUpcomingEvents): Promise<IUpcomingEvents> => {
  const result = await UpcomingEvents.create(payload);
  return result;
};

const getAll = async (query: Record<string, unknown>) => {
  const upcomingEventsQuery = new QueryBuilder(UpcomingEvents.find(), query)
    .search(['name'])
    .filter()
    .sort()
    .paginate()
    .fields();

  const result = await upcomingEventsQuery.modelQuery;
  const meta = await upcomingEventsQuery.countTotal();

  return { result, meta };
};

const getById = async (id: string) => {
  const result = await UpcomingEvents.findById(id);
  return result;
};

const updateById = async (id: string, payload: Partial<IUpcomingEvents>) => {
  const result = await UpcomingEvents.findByIdAndUpdate(id, payload, {
    new: true,
  });
  return result;
};

const deleteById = async (id: string) => {
  const result = await UpcomingEvents.findByIdAndDelete(id);
  return result;
};

export const UpcomingEventsService = {
  create,
  getAll,
  getById,
  updateById,
  deleteById,
};
