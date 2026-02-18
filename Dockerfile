# Use the official Node.js 18-alpine image as the base image for the build stage
FROM node:18-alpine AS build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the application
RUN npm run build

# Start a new stage from the official Node.js 18-alpine image for production
FROM node:18-alpine AS production

# Set the working directory
WORKDIR /app

# Copy the built application from the build stage
COPY --from=build /app/build ./build

# Install only production dependencies
COPY package*.json ./
RUN npm install --only=production

# Expose the application port
EXPOSE 3000

# Command to run the application
CMD ["node", "build/index.js"]