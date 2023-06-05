# Start from a Node.js version 16.13.0 (LTS as of September 2021) based on Alpine Linux
FROM node:16.13.0-alpine

# Set working directory in the Docker container
WORKDIR /usr/src/app

# Install Node.js dependencies
# First, copy both 'package.json' and 'package-lock.json' (if available)
COPY package*.json ./
# Install Node.js dependencies
RUN npm ci --only=production

# Copy source code
COPY . .

# Build the TypeScript app
RUN npm run build

# Set production environment variable
ENV NODE_ENV production

# Expose API port to the outside
EXPOSE 80

# Run the API server
CMD ["node", "dist/index.js"]
