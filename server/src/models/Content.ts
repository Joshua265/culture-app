import mongoose, { Document } from 'mongoose';

export interface IContent extends Document {
  title: string;
  description: string;
  imageUrl: string;
  genre: string;
}

const ContentSchema = new mongoose.Schema({
  title: String,
  description: String,
  imageUrl: String,
  genre: String
});

export const Content = mongoose.model<IContent>('Content', ContentSchema);
