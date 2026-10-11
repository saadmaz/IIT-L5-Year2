# Ticketing System: Front End

React front end for the OOP ticketing system coursework (December 2024). It is a UI prototype:
the pages work, but they are not yet connected to the back end, so sign-up, login and the event
list use local placeholder data.

## Pages

| Route      | Component        | What it does                                              |
|------------|------------------|-----------------------------------------------------------|
| `/`        | `HomePage`       | Landing page with links to sign up, log in and browse     |
| `/events`  | `EventPage`      | Grid of upcoming events                                   |
| `/login`   | `LoginPage`      | Log in as a customer or vendor                            |
| `/signup`  | `SignUpPage`     | Two-step sign-up as a customer or vendor                  |

```
src/
├── App.js          Routes
├── components/     One file per page
└── styles/         One stylesheet per page
```

## Running

Requires Node.js 18+.

```bash
npm install
npm start          # http://localhost:3000
npm test           # run the tests once with: npm test -- --watchAll=false
npm run build      # production build in build/
```
