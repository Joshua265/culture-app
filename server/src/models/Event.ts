import mongoose, { Document } from 'mongoose';

export interface IPrice {
  category: string;
  value: number;
}

export interface ISeat {
  id: string;
  category: string;
}

export enum EventMediaCategory {
  CONCERT = 'concert',
  THEATER = 'theater',
  SPORTS = 'sports'
}

export interface IEvent extends Document {
  title: string;
  location: string;
  startTime: Date;
  endTime: Date;
  prices: IPrice[];
  mediaCategory: EventMediaCategory;
  contentId: string;
  imageUrl: string;
  description: string;
  bookedSeats: ISeat[];
}

const EventSchema = new mongoose.Schema({
  title: String,
  location: String,
  startTime: Date,
  endTime: Date,
  prices: [{ category: String, value: Number }],
  mediaCategory: {
    type: String,
    enum: Object.values(EventMediaCategory)
  },
  contentId: String,
  imageUrl: String,
  description: String,
  bookedSeats: [{ id: String, category: String }]
});

export const Event = mongoose.model<IEvent>('Event', EventSchema);
