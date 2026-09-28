# CLAUDE.md

This file gives Claude Code (and any other AI assistant) the context needed to work effectively in the PlantPal repository.

## Project Overview

PlantPal is a mobile app that helps users identify, understand, and care for plants. It combines a plant care guide, AI-based plant diagnosis, fertilizer information, an e-commerce shop, and gamification (points/rewards).

Core features:
- **AI Doctor** — photo-based plant diagnosis (Gemini / Groq)
- **Plant Care** — plant management + daily/recurring care tasks
- **Fertilizer** — fertilizer/nutrient info and recommendations
- **Shop** — browse, wishlist, cart, checkout, reviews
- **Gamification** — points for completed care tasks, redeemable rewards

## Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Flutter / Dart |
| Backend | Go (REST API) |
| Database | MongoDB |
| AI | Gemini / Groq (plant image analysis) |
| Navigation | GoRouter |
| Animation | Rive |
| Image storage | Cloudinary |
| Client–server | REST API only |

**Hard rule:** Flutter never talks to MongoDB, Gemini/Groq, Cloudinary, or payment providers directly. All of that goes through the Go backend.

```
Flutter App --REST API--> Go Backend --> MongoDB
                                    --> Gemini / Groq
                                    --> Cloudinary
                                    --> Payment Services
```

## Architecture: Feature-Based "LEGO" Architecture

Each major feature is a self-contained, swappable module with its own UI, models, and data handling. Shared code lives in `core/`. This is meant to keep features independently developable, testable, and replaceable — don't reach across feature boundaries except through defined interfaces.

### Directory structure

```
lib/
├── main.dart
├── app/
│   ├── app.dart
│   └── router/
│       └── app_router.dart
├── core/
│   ├── network/
│   ├── storage/
│   ├── theme/
│   ├── widgets/
│   ├── services/
│   └── utils/
└── features/
    ├── auth/
    ├── home/
    ├── plants/
    ├── ai_doctor/
    ├── fertilizer/
    ├── care_guide/
    ├── shop/
    ├── wishlist/
    ├── cart/
    ├── checkout/
    ├── payments/
    ├── reviews/
    ├── gamification/
    └── profile/
```

Each feature follows a clean-architecture-style split:

```
feature/
├── presentation/   # widgets, screens, controllers/state
├── domain/         # entities, use cases, repository interfaces
└── data/           # repository implementations, DTOs, API/data sources
```

**Conventions when adding code:**
- New screens/widgets → `feature/presentation/`
- Business rules / use cases → `feature/domain/`
- API calls, DTOs, repository implementations → `feature/data/`
- Anything reused across ≥2 features → `core/`, not duplicated per feature
- Never import one feature's internals directly from another feature; go through `domain` interfaces or `core` services

### Data flow (client side)

```
Flutter UI → Feature Controller → Repository → REST API → Go Backend
```

## Backend (Go)

The Go backend owns: authentication, user management, plant data, care tasks, AI requests, fertilizer info, products, wishlist/cart, orders, payments, reviews, and points/rewards.

Backend responsibilities Claude should respect when writing backend code:
- Validate all orders and prices server-side (never trust client-submitted prices)
- Validate all point balance changes server-side
- Handle authentication and payment verification securely, server-side only
- Keep MongoDB access, AI calls, and Cloudinary calls out of the client entirely

## Database (MongoDB)

Expected collections: `Users`, `Plants`, `CareTasks`, `Diagnoses`, `Fertilizers`, `Products`, `Reviews`, `Wishlists`, `Carts`, `Orders`, `Payments`, `RewardTransactions`.

Schema is expected to evolve per-entity, which is why MongoDB was chosen over a rigid relational schema — don't assume a fixed schema when generating models; check existing struct/BSON definitions first.

## Navigation (GoRouter)

Key routes:
```
/login
/register
/home
/plants
/plants/:id
/ai-doctor
/fertilizer
/care-guide
/shop
/shop/product/:id
/wishlist
/cart
/checkout
/orders
/rewards
/profile
```

Authenticated routes are protected by route guards — new authenticated screens must be registered behind the guard, not as open routes.

## Security Rules (non-negotiable)

- Flutter must never connect directly to MongoDB.
- Never expose sensitive API keys in the Flutter client.
- All authentication logic lives in the backend.
- All order/price validation happens server-side.
- All point-balance validation happens server-side.
- Payment verification must be handled securely on the backend.

## Development Phases (roadmap reference)

1. Project foundation — Flutter project, LEGO architecture, GoRouter, Go backend, MongoDB connection
2. Authentication — register, login, auth, profile
3. Plant Care — My Plants, plant details, care guide, daily tasks
4. AI Doctor — image capture/upload, AI integration, diagnosis, treatment guidance
5. Fertilizer — list, details, recommendations
6. Shop — products, search/filtering, wishlist, cart, reviews
7. Checkout — order creation, address, payment, confirmation
8. Gamification — points, care streaks, rewards, shop redemption
9. Testing — unit, widget, API, integration tests, final UI/perf polish

When asked to implement a feature, check which phase it belongs to and prefer building on top of prior phases' foundations (e.g. don't build Shop checkout logic before auth and cart exist).

## Notes for AI-assisted development

- AI Doctor results should always be presented as assistance, not a guaranteed diagnosis — reflect this in UI copy and API response handling (e.g. include disclaimers, avoid absolute language).
- When generating new Flutter code, follow the existing feature's `presentation/domain/data` split rather than putting logic directly in widgets.
- When unsure which feature a piece of shared logic belongs in, default to `core/` if it's used by 2+ features, otherwise keep it local to the feature.
- Prefer REST calls through a shared `core/network` client rather than ad hoc HTTP calls per feature.