# Property Search App: CW2 (Saad Mazhar)

Advanced Client-Side Development (5COSC026C) coursework: a single-page estate-agent app for searching and saving properties.

## Features

- **Search** by property type, price range, bedroom range, postcode area and date added
- **Property page** (`/property/:id`) with image gallery, tabbed details and an embedded Google Map
- **Favourites** (`/favourites`) persisted in `localStorage`
- Light / dark theme toggle and responsive layout

## Tech stack

React 18 · TypeScript · Vite · Tailwind CSS · shadcn/ui · React Router

Property data lives in [`src/data/properties.json`](src/data/properties.json).

## Running locally

```bash
npm install
npm run dev      # start the dev server
npm run build    # production build into dist/
npm run lint     # ESLint
```
