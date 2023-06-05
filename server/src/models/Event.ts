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
  CINEMA = 'movie',
  THEATER = 'theater',
  FESTIVALS = 'festival'
}

export interface IEvent extends Document {
  title: string;
  location: string;
  city: string;
  startTime: Date;
  endTime: Date;
  prices: IPrice[];
  mediaCategory: EventMediaCategory;
  imageId: string;
  description: string;
  bookedSeats: ISeat[];
  genres: string[];
}

const EventSchema = new mongoose.Schema({
  title: String,
  city: String,
  location: String,
  startTime: Date,
  endTime: Date,
  prices: [{ category: String, value: Number }],
  mediaCategory: {
    type: String,
    enum: Object.values(EventMediaCategory)
  },
  genres: [String],
  imageId: String,
  description: String,
  bookedSeats: [{ row: String, seatNumber: String }]
});

export const Event = mongoose.model<IEvent>('Event', EventSchema);
